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
    mkIf cfg.terminal.editors.enable {
      # Import home files
      home-merger = {
        enable = true;
        extraSpecialArgs = {inherit cfg pkgs inputs;};
        users = cfg.users;
        modules = [
          ./home.nix
        ];
      };

      # Set default editor
      programs.nano.enable = false;

      # Add essential developer packages
      environment.systemPackages = with pkgs; [
        # Text editor (IDE)
        vim
        pkgs-unstable.neovim
        # charmbracelet / Charm.sh
        # glow
        # mods
      ];
    }
