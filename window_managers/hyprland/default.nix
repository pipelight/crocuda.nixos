{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  utils,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.wm.hyprland.enable {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      environment.systemPackages = with pkgs; [
        wl-clipboard
        # hyprlock
        # hypridle

        # Screen light
        # wl-sunset
        redshift
        gammastep

        #Keyboard
        via
      ];

      services.udev.packages = with pkgs; [
        via
      ];

      services.udev.extraRules = ''
        ACTION=="add",\
        ENV{SUBSYSTEM}=="usb",\
        ENV{PRODUCT}=="a8f8/1828/200",\
        RUN+="",\

        ACTION=="remove",\
        ENV{SUBSYSTEM}=="usb",\
        ENV{PRODUCT}=="a8f8/1828/200",\
        RUN+="${pkgs.hyprland}/bin/hyprctl switchxkblayout next",\
      '';
    }
