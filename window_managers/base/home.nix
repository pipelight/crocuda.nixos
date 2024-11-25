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
    mkIf cfg.wm.hyprland.enable
    || cfg.wm.gnome.enabled
    || cfg.wm.bspwm.enable {
      home.file = {
        ".profile".source = ./dotfiles/.profile;
      };
    }
