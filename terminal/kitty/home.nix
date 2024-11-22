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
    mkIf cfg.terminal.emulator.kitty.enable {
      home.file = {
        ".config/kitty/ssh.conf".source = dotfiles/kitty/ssh.conf;
      };

      # Terminal
      programs = {
        kitty = {
          enable = true;
          extraConfig = builtins.readFile dotfiles/kitty/kitty.conf;
          theme = "GitHub Dark Dimmed";
          # theme = "Doom One";
        };
      };
    }
