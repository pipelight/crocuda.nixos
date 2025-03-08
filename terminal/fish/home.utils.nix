{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf cfg.terminal.shell.utils.enable {
    home.packages = with pkgs; [
      # Mini man pages
      # tealdeer
      # Nixos doc
      # manix

      # File convertion
      # dasel

      # Get info on dir
      fastfetch
      onefetch

      # Js utils
      # jo
      jq
      # yq-go

      # Inspect fs and io
      pciutils
      lshw

      # Process management
      # btop
      lsof
    ];
  }
