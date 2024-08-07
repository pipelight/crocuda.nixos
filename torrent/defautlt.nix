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
    mkIf cfg.terminal.torrent.enable {
      # Import home files
      home-merger = {
        enable = true;
        users = cfg.users;
        modules = [
          ./home.nix
        ];
      };
      environment.systemPackages = with pkgs; [
        transmission
      ];
      ################################
      ### Torrent
      services.transmission = {
        enable = true;
      };
    }
