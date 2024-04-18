{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda.servers;
  domains = cfg.mail.maddy.domains;
  primaryDomain = builtins.elemAt domains 0;
in
  with lib;
    mkIf cfg.mail.maddy.enable {
      # The mail server
      services.maddy = {
        enable = true;
        config = builtins.readFile ./dotfiles/maddy.conf;
        openFirewall = false;
        inherit primaryDomain;
      };

      # Autodiscovery services
      services.go-autoconfig = {
        enable = true;
        settings = {
          service_addr = ":1323";
          domain = "autoconfig.${primaryDomain}";
          imap = {
            server = primaryDomain;
            port = 993;
          };
          smtp = {
            server = primaryDomain;
            port = 587;
          };
        };
      };

      environment.etc = {
        "caddy/Maddy.Caddyfile".source = ./dotfiles/Maddy.Caddyfile;
      };
      systemd.services."caddy_expose_maddy" = {
        enable = true;
        after = ["caddy.service"];
        description = "Load a caddy proxy config to redirect tls to maddy mail server";
        serviceConfig = {
          User = "caddy";
          Group = "users";
          WorkingDirectory = "~";
          ExecStart = ''
            ${pkgs.caddy}/bin/caddy reload \
              --adapter caddyfile \
              --config /etc/caddy/Maddy.Caddyfile
          '';
        };
        wantedBy = ["multi-user.target"];
      };
    }
