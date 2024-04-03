
{
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}: let
  cfg = config.crocuda;
  darkfi = inputs.darkfi.packages.${system}.default;
in
  with lib;
    mkIf cfg.finance.darkfi.enable {
      environment.systemPackages = with pkgs; [
        # Darkfi suit
        # darkfi
        ];
      ## Darkirc messaging background service
      systemd.user.services."darkircd" = {
        enable = false;
        after = ["network.target"];
        serviceConfig = {
          ExecStart = "${darkfi}/bin/darkirc";
        };
        wantedBy = ["multi-user.target"];
      };
      }
