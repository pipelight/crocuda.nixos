{
  config,
  pkgs,
  lib,
  inputs,
  cfg,
  ...
}:
with lib;
  mkIf cfg.office.chat.enable {
    home.packages = with pkgs; [
      # Mail client
      thunderbird-bin

      # Messaging apps
      # session-desktop
      signal-desktop
      # element-desktop
      # telegram-desktop

      # Bottom tier apps
      discord

      # A terminal based chat application plugable with
      # ircd and darkirc
      weechat

      # Social network
      # tuba
    ];
  }
