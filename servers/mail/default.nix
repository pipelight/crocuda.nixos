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
      environment.etc = {
        "jucenit/juceni.maddy.toml".source = ./dotfiles/jucenit.maddy.toml;
      };
      systemd.services.maddy.serviceConfig = {
        ExecStart = ''
          jucenit push --file /etc/jucenit/jucenit.maddy.toml
        '';
      };
      # The mail server
      services.maddy = {
        enable = true;
        config = builtins.readFile ./dotfiles/maddy.conf;
        openFirewall = false;
        inherit primaryDomain;
        ensureAccounts =
          [
            "anon@${primaryDomain}"
          ]
          ++ accounts;
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
    }
