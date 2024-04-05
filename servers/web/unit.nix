{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  users.groups = {
    unit.members = cfg.users;
  };

  environment.defaultPackages = with pkgs; [
    # Crocuda dependencies
    caddy

    # Vercel server anything
    nodePackages.serve

    openssl
    unit
    deno
    certbot
    # fail2ban
  ];

  ## Add global packages
  services.unit.enable = true;
  # Replace default secure unix socket with local tcp socket
  systemd.services.unit = {
    serviceConfig = {
      ExecStart = lib.mkForce ''
        ${pkgs.unit}/bin/unitd \
          --control '127.0.0.1:8080' \
          --pid '/run/unit/unit.pid' \
          --log '/var/log/unit/unit.log' \
          --statedir '/var/spool/unit' \
          --tmpdir '/tmp' \
          --user unit \
          --group unit
      '';
      # Provision server with minimal config
      # route: Certbot acme challenge
      ExecStartPost = let
        data = builtins.toJSON ''
          {
            "listeners": {},
            "applications": {},
            "routes": {
                "acme": [
                    {
                      "match": {
                          "uri": "/.well-known/acme-challenge/*"
                      },
                      "action": {
                          "share": "/var/www/www.example.com/"
                      }
                    }
                ]
            }
          } '';
      in
        lib.mkForce ''
          ${pkgs.curl}/bin/curl \
            -X PUT \
            --data-binary ${data} \
            'http://localhost:8080/config'
        '';
    };
  };

  # SSL suport
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "admin+acme@example.org";
  # };

  # Enable the OpenSSH daemon.
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    # settings.PasswordAuthentication = true;
    settings.PasswordAuthentication = false;
    # settings.KbdInteractiveAuthentication = true;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };
}
