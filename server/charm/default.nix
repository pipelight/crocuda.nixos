{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # Set globals
  username = "anon";
in {
  # system.disableInstallerTools = true;
  # Loose security
  security.sudo.wheelNeedsPassword = false;

  users.groups = {
    docker.members = [username];
    unit.members = [username];
  };
  ## Add global packages
  # environment.systemPackages = [];
  environment.defaultPackages = with pkgs; [
    # Crocuda dependencies
    util-linux
    tree
    git
    sqlite
    soft-serve
    charm
    docker
    curl
    openssl
    unit
    deno
    certbot
    # fail2ban

    # Pipelight from flake
    inputs.pipelight.packages.${system}.default
  ];
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

  # Allow docker usage
  virtualisation.docker.enable = true;

  # Git server
  users.users.git = {
    isNormalUser = true;
    homeMode = "770";
  };

  environment.etc = {
    # charm's soft-serve
    # "soft/config.yaml".source = dotfiles/soft/config.yaml;
    "charm.conf".source = dotfiles/charm/charm.conf;
  };

  systemd.services."soft-serve" = {
    enable = true;
    description = "Soft Serve git server";
    documentation = ["https://github.com/charmbracelet/soft-serve"];
    requires = ["network-online.target"];
    serviceConfig = {
      ExecStart = "${pkgs.soft-serve}/bin/soft serve";
      User = "${username}";
      Group = "users";
      Type = "simple";
      Restart = "always";
      RestartSec = 1;
      Environment = [
        "SOFT_SERVE_DATA_PATH=/var/lib/soft-serve"
        # "SOFT_SERVE_INITIAL_ADMIN_KEYS=${(builtins.readFile /dotfiles/.ssh/authorized_keys)}"
        "SOFT_SERVE_INITIAL_ADMIN_KEYS=${(builtins.readFile
          /home/${username}/.ssh/id_rsa_deku)}"
      ];
      EnvironmentFile = "/home/${username}/soft/env";
      WorkingDirectory = "/home/${username}/soft";
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.services."charm" = {
    enable = true;
    description = "Charm server";
    documentation = ["https://github.com/charmbracelet/charm"];
    requires = ["network-online.target"];
    serviceConfig = {
      ExecStart = "${pkgs.charm}/bin/charm serve";
      User = "${username}";
      Group = "users";
      Type = "simple";
      Restart = "always";
      RestartSec = 1;
      WorkingDirectory = "/home/${username}/charm";
      EnvironmentFile = ["/etc/charm.conf"];
    };
    wantedBy = ["multi-user.target"];
  };

  # Create working dir for Soft and Charm
  systemd.tmpfiles.rules = [
    "d /home/${username}/soft 755 ${username} users"
    "d /home/${username}/charm 755 ${username} users"
    "d /var/lib/soft-serve 755 ${username} users"
  ];

  programs.ssh.extraConfig = ''
    Host soft
      HostName localhost
      IdentitiesOnly yes
      Port 23231
      IdentityFile ~/.ssh/id_rsa_deku

    Host charm
      HostName localhost
      Port 35353
      IdentityFile ~/.local/share/charm/localhost/charm_ed25519
  '';

  # Ssh Server
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
  # Set directory loose permissions
  users.users."${username}" = {
    isNormalUser = true;
    ## Permission
    ## Add user to priviliedge groups
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keyFiles = [
      dotfiles/.ssh/authorized_keys
    ];
  };
  # Authorized keys
  users.users."git".openssh.authorizedKeys.keyFiles = [
    dotfiles/.ssh/authorized_keys
  ];

  # Link to host terminal
  # systemd.services."serial-getty@ttyS0".enable = true;
  environment.variables = {
    # TERM = "xterm";
  };
}
