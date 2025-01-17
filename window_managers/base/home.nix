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
    || cfg.wm.gnome.enable)
  {
    home.file = {
      ".profile".source = ./dotfiles/.profile;
    };
  }
