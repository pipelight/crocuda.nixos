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
    mkIf
    (cfg.wm.hyprland.enable
      || cfg.wm.gnome.enable)
    {
      programs = {
        fish = {
          loginShellInit = lib.readFile ./dotfiles/.profile.fish;
        };
        bash = {
          loginShellInit = lib.readFile ./dotfiles/.profile.sh;
        };
      };
    }
