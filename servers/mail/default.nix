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
        openFirewall = true;
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
            server = domain;
            port = 587;
          };
        };
      };
    }
