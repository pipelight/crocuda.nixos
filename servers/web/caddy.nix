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
      services.caddy = {
        enable = true;
        user = username;
        group = "users";
        acmeCA = "https://acme-staging-v02.api.letsencrypt.org/directory";
      };

      # systemd.services.caddy = {
      #   enable = true;
      #   serviceConfig = {
      #     ExecStart = "${pkgs.caddy}/bin/caddy run";
      #     User = "${username}";
      #     Group = "users";
      #     Restart = "always";
      #     RestartSec = 3;
      #   };
      # };
    }
