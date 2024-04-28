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
    mkIf cfg.wm.hyprland.enable {
      # Import home file
      home-merger = {
        enable = true;
        extraSpecialArgs = {inherit cfg pkgs inputs;};
        users = cfg.users;
        modules = [
          ./home.nix
        ];
      };
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
      environment.systemPackages = with pkgs; [
        wl-clipboard
        hyprlock
        hypridle
        # Screen light
        redshift

        #Keyboard
        via
      ];

      services.udev.packages = with pkgs; [
        via
      ];
    }
