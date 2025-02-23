{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf cfg.terminal.torrent.enable {
    home.packages = with pkgs; [
      # Torrenting
      # inputs.rustmission.packages.${system}.default
      rustmission
    ];
    home.file = {
      ".config/rustmission/config.toml".source = dotfiles/rustmission/config.toml;
    };
  }
