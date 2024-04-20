{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
  # A dedicated unpriviledged user for public node
  username = "caddy";
in
  with lib;
    mkIf cfg.servers.web.caddy.enable {
      users.users."${username}" = {
        isSystemUser = true;
      };
      environment.defaultPackages = with pkgs; [
        caddy
      ];

      environment.etc = {
        "caddy/Caddyfile" = {
          # source = ./dotfiles/Caddyfile;
          text = let
          dns_list = lib.concatStringsSep " " cfg.servers.web.caddy.ssl;
          in with lib;
              concatLines [

              (builtins.readFile ./dotfiles/Caddyfile)
              ''
                ${dns_list} {
                  reverse_proxy localhost:10443
                }
              ''
              ];
        };
      };

      services.caddy = {
        enable = true;
        user = username;
        group = "users";
        acmeCA = "https://acme-staging-v02.api.letsencrypt.org/directory";
      };

      systemd.services."caddy_expose" = {
        enable = true;
        after = ["caddy.service"];
        description = "Load a caddy proxy config to redirect tls to maddy mail server and nginx unit";
        serviceConfig = {
          User = "caddy";
          Group = "users";
          WorkingDirectory = "~";
          ExecStart = ''
            ${pkgs.caddy}/bin/caddy reload \
              --adapter caddyfile \
              --config /etc/caddy/Caddyfile
          '';
        };
        wantedBy = ["multi-user.target"];
      };
    }
