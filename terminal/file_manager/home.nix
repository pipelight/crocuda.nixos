{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}:
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
