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
    programs = rec {
      fish = {
        loginShellInit = lib.readFile ./dotfiles/.profile.sh;
      };
      bash = {
        loginShellInit = lib.readFile ./dotfiles/.profile.fish;
      };
    };
  }
