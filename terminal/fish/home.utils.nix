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
      # nushell

      # Mini man pages
      cheat
      tealdeer

      expect

      # File convertion
      dasel

      # Get info on dir
      fastfetch
      onefetch

      # A terminal based chat application plugable with
      # ircd and darkirc
      weechat

      # Js utils
      jo
      jq
      yq-go

      # Nixos doc
      manix

      # Inspect fs and io
      pciutils
      lshw

      # Process management
      # btop
      lsof

      # Dotenv, environment autoload
      nix-index
    ];
  }
