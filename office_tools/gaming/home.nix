##########################
## Gaming suite
# Emulators
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.office.gaming.enable {
      home.packages = with pkgs; [
        lutris
        bottles
      ];
    }
