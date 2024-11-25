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
      environment.systemPackages = with pkgs; [
        transmission
      ];
      ################################
      ### Torrent
      services.transmission = {
        enable = true;
      };
    }
