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
      # Import home files
      home-merger = {
        enable = true;
        users = cfg.users;
        modules = [
          ./home.nix
          ./dconf.nix
        ];
      };

      # Gaming
      allow-unfree = [
        "steam"
        "steam-*"
      ];

      services.xserver.desktopManager.gnome.enable = true;

      environment.systemPackages = with pkgs;
      with pkgs.gnome; [
        gnome-session
        gnome-shell
        gnome-initial-setup
        gnome-control-center
        gnome-bluetooth
        gnome-backgrounds
        nautilus
      ];
      # Temporary fix one line full gnome installation
      # services.xserver.desktopManager.gnome.enable = true;

      # App store
      services.flatpak.enable = false;

      environment.gnome.excludePackages =
        (with pkgs; [
          gnome-photos
          gnome-tour
          gedit # text editor
        ])
        ++ (with pkgs.gnome; [
          seahorse
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
        ]);

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
      # Hyprland
      programs.dconf.enable = true;
      xdg.portal = {
        enable = lib.mkForce false;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];
      };
    }
