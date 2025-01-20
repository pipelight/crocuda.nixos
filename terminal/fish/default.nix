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
      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };
      environment.systemPackages = with pkgs; [
        # Move fast in filesystem
        fzf
        fd
        atuin
        zoxide
        ripgrep
        eza

        ## Fish Shell dependencies
        starship
        fish

        # Recolorize commands
        grc

        eza

        # Process management
        htop

        # Display file
        bat
      ];
    }
