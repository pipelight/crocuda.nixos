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
    mkIf cfg.terminal.file_manager.enable {
      home.file = {
        ".config/yazi/keymap.toml".source = dotfiles/yazi/keymap.toml;
      };

      home.packages = with pkgs; [
        # File manager
        # ranger
        yazi
      ];
    }
