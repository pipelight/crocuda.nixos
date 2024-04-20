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
      environment.systemPackages = with pkgs; [
        obs-studio
        obs-studio-plugins.wlrobs
        obs-studio-plugins.input-overlay
        obs-cli
      ];
    }
