{
  config,
  pkgs,
  lib,
  inputs,
  system,
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
        "d '/run/maddy' 774 maddy users - -"
        "Z '/run/maddy' 774 maddy users - -"
      ];

      environment.etc = {
        "jucenit/juceni.maddy.toml".source = ./dotfiles/jucenit.maddy.toml;
      };

      systemd.services = {
        maddy-ensure-accounts.enable = lib.mkForce false;
        maddy = {
          postStart = let
            jucenit = inputs.jucenit.packages.${system}.default;
          in
            lib.mkForce ''
              ${jucenit} push --file /etc/jucenit/jucenit.maddy.toml
            '';
        };
      };

      # The mail server
      services.maddy = {
        group = "users";
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
