{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf (cfg.terminal.editors.neovim.enable
      || cfg.terminal.editors.nvchad.enable
      || cfg.terminal.editors.nvchad-ide.enable)
    {
      # Set default editor
      programs = {
        nano = {
          enable = false;
        };
        neovim = {
          defaultEditor = true;
        };
      };

      # Add essential developer packages
      environment.systemPackages = with pkgs; [
        # Minimal text editor
        vim
        # neovim as IDE
        neovim
      ];
    }
