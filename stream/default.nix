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
    mkIf cfg.stream.enable {
      # https://nixos.wiki/wiki/OBS_Studio
      boot.extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      boot.extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
      '';
      security.polkit.enable = true;

      environment.systemPackages = with pkgs; [
        obs-cli
      ];
      # Import home files
      home-merger = {
        enable = true;
        extraSpecialArgs = {inherit cfg pkgs inputs;};
        users = cfg.users;
        modules = [
          ./home.nix
        ];
      };
    }
