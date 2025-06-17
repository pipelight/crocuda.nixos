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
    mkIf cfg.wm.niri.enable {
      programs.niri.enable = true;
      environment.systemPackages = with pkgs; [
        niri
        wlr-which-key
      ];
    }
