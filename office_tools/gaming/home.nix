##########################
## Gaming suite
# Emulators
{
  config,
  pkgs,
  lib,
  cfg,
  ...
}:
with lib;
  mkIf cfg.office.gaming.enable {
    home.packages = with pkgs; [
      lutris
      bottles
    ];
  }
