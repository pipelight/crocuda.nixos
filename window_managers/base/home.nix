{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf
  (cfg.wm.hyprland.enable
    || cfg.wm.gnome.enable
    || cfg.wm.bspwm.enable)
  {
    home.file = {
      ".profile".source = ./dotfiles/.profile;
    };
  }
