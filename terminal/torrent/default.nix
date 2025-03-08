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
    mkIf cfg.terminal.torrent.enable {
      ################################
      ### Torrent
      services.transmission = {
        enable = true;
        package = pkgs.transmission_4;
      };
    }
