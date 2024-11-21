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
    mkIf cfg.terminal.editors.neovim.enable {
      # Import home files
      home-merger = {
        enable = true;
        extraSpecialArgs = {inherit cfg pkgs pkgs-unstable inputs;};
        users = cfg.users;
        modules = [
          ./home.nix
        ];
      };

      # Set default editor
      programs.nano = {
        enable = false;
      };
      programs = {
        neovim = {
          defaultEditor = true;
        };
      };

      # Add essential developer packages
      environment.systemPackages = with pkgs; [
        # Minimal text editor
        vim
        # neovim as IDE
        pkgs-unstable.neovim
      ];
    }
