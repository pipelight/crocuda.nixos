{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.servers.web.unit.enable {
      users.groups = {
        unit.members = cfg.users;
      };

      environment.defaultPackages = with pkgs; [
        # Vercel server anything
        nodePackages.serve

        unit
        deno
        openssl
        certbot
      ];

      ## Add global packages
      services.unit.enable = true;

      ## Custom optionnal systemd unit
      # Replace default secure unix socket with local tcp socket
      systemd.services.unit = {
        enable = true;
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
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
          ExecStartPost = let
            data = builtins.toJSON ''
              {
                "listeners": {},
                "applications": {},
                "routes": {}
              } '';
          in
            lib.mkForce ''
              ${pkgs.curl}/bin/curl \
                -X POST \
                --data-binary ${data} \
                'http://localhost:8080/config'
            '';
        };
      };
    }
