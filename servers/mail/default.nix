{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda.servers;
  domains = cfg.mail.maddy.domains;
  accounts = cfg.mail.maddy.accounts;
  primaryDomain = builtins.elemAt domains 0;
in
  with lib;
    mkIf cfg.mail.maddy.enable {
      systemd.tmpfiles.rules = [
        # Maddy directories
        # Make them by hand if maddy unit fails
        "d /run/maddy 774 maddy users - -"
        "Z /run/maddy 774 maddy users - -"
        # Symlink to nginx-unit certs
        "L+ /etc/maddy/certs - - - - /var/spool/unit/certs"
        "Z /etc/letsencrypt 754 root users - -"
      ];

      # The mail server
      services.maddy = {
        group = "users";
        enable = true;

        hostname = primaryDomain;
        localDomains = domains;
        inherit primaryDomain;

        openFirewall = false;
        ensureAccounts = accounts;
        config = builtins.readFile ./dotfiles/maddy.conf;
        tls = {
          loader = "file";
          certificates = [
            {
              certPath = "/etc/letsencrypt/live/crocuda.com/fullchain.pem";
              keyPath = "/etc/letsencrypt/live/crocuda.com/privkey.pem";
            }
            {
              certPath = "/etc/letsencrypt/live/areskul.com/fullchain.pem";
              keyPath = "/etc/letsencrypt/live/areskul.com/privkey.pem";
            }
          ];
        };
      };

      # Autodiscovery services
      # services.go-autoconfig = {
      #   enable = true;
      #   settings = {
      #     service_addr = "O.O.O.O:1323";
      #     domain = "autoconfig.${primaryDomain}";
      #     imap = {
      #       server = primaryDomain;
      #       port = 993;
      #     };
      #     smtp = {
      #       server = primaryDomain;
      #       port = 587;
      #     };
      #   };
      # };
    }
