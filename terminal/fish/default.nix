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
    mkIf cfg.terminal.shell.fish.enable {
      programs.fish.enable = true;
      environment.systemPackages = with pkgs; [
        # nushell

        ## Fish Shell dependencies
        starship
        fish

        # Recolorize commands
        grc
      ];
    }
