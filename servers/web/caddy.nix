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
    mkIf cfg.servers.web.caddy.enable {
      environment.defaultPackages = with pkgs; [
        # Crocuda dependencies
        caddy
      ];
      systemd.services.caddy = {
        enable = true;
        serviceConfig = {
          ExecStart = "${pkgs.caddy}/bin/caddy run";
        };
      };
    }
