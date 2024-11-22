{
  config,
  pkgs,
  lib,
  utils,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.office.gaming.enable {
      allow-unfree = [
        "steam.*"
      ];
    }
