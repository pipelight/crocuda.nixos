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
        isNormalUser = true;
    homeMode = "770";
      };

      environment.defaultPackages = with pkgs; [
        caddy
      ];

      systemd.services.caddy = {
        enable = true;
        serviceConfig = {
          ExecStart = "${pkgs.caddy}/bin/caddy run";
          User = "${username}";
          Group = "users";
          Restart = "always";
          RestartSec = 3;
        };
      };
    }
