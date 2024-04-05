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
    mkIf cfg.terminal.emulators.enable {
      home.file = {
        ".config/pacman/makepkg.conf".source = dotfiles/pacman/makepkg.conf;
        ".config/kitty/ssh.conf".source = dotfiles/kitty/ssh.conf;
      };

      home.packages = with pkgs; [
        zellij
        # Packaging for AUR
        pacman
    # utils
    vhs
      ];

      # Shell
      programs = {
        # Terminal
        kitty = {
          enable = true;
          extraConfig = builtins.readFile dotfiles/kitty/kitty.conf;
          theme = "GitHub Dark Dimmed";
        };
      };
    }
