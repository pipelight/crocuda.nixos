{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
  niri-latest = pkgs.callPackage ./niri.latest.nix {};
in
  with lib;
    mkIf cfg.wm.niri.enable {
      # Do not use following option as it tweaks systemd.
      # programs.niri.enable = true;

      environment.systemPackages = with pkgs; [
        # niri
        niri-latest

        # keyboard daemon
        inputs.mudras.packages.${system}.default

        # Bars
        waybar

        # wlr-which-key
        # Waiting for newest than 1.1.0
        # inputs.wlr-which-key.packages.${system}.default
      ];
    }
