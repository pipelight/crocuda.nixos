{
  config,
  pkgs,
  lib,
  utils,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.wm.gnome.enable {
      services.gnome.gnome-settings-daemon.enable = true;
      environment.systemPackages = with pkgs;
      with pkgs; [
        gnome-control-center
        gnome-initial-setup
        gnome-session
        gnome-shell
        gnome-bluetooth
        gnome-backgrounds
        gnome-power-manager
        gnome-maps

        gnome.nixos-gsettings-overrides
        gnome-settings-daemon
        gnome-menus

        nautilus
        emote
      ];
      # Temporary fix one line full gnome installation
      # services.xserver.desktopManager.gnome.enable = true;

      # App store
      services.flatpak.enable = true;

      environment.gnome.excludePackages = with pkgs; [
        gnome-photos
        gnome-tour
        gedit # text editor
        # seahorse
        cheese # webcam tool
        gnome-music
        gnome-terminal
        epiphany # web browser
        geary # email reader
        # evince # document viewer
        gnome-characters
        totem # video player
        # Games
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ];
    }
