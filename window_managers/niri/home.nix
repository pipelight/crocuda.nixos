{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf cfg.wm.niri.enable {
    home.file = {
      ".config/wlr-which-key/config.yaml".source = dotfiles/wlr-which-key/config.yaml;
      # ".config/niri/config.kdl".source = dotfiles/niri/config.kdl;
    };
  }
