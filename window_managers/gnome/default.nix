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
      # Gnome applications compatibility for other WM

      # Bspwm
      # xdg.portal.enable = lib.mkForce false;

      environment.etc = {
        # Qt4
        "xdg/Trolltech.conf".text = ''
          [Qt]
          style=GTK+
        '';
      };
      environment.sessionVariables = {
        QT_WAYLAND_DECORATION = "adwaita";
        QT_QPA_PLATFORMTHEME = "gtk2";
      };
      # Hyprland
      programs.dconf.enable = true;
      xdg.portal = {
        enable = true;
        # enable = lib.mkForce false;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];
      };
    }
