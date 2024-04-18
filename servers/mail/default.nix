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
        openFirewall = false;
        inherit primaryDomain;
      };

      environment.etc = {
        "caddy/Maddy.Caddyfile".source = ./dotfiles/Maddy.Caddyfile;
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

      systemd.services."caddy_expose_maddy" = {
        enable = true;
        after = ["caddy.service"];
        description = "Load a caddy proxy config to redirect tls to maddy mail server";
        serviceConfig = {
          User = "caddy";
          Group = "caddy";
          WorkingDirectory = "~";
          ExecStart = ''
            ${pkgs.caddy}/bin/caddy reload --config
          '';
        };
        wantedBy = ["multi-user.target"];
      };
    }
