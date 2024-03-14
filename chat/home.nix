{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # Mail client
    thunderbird-bin

    # A terminal based chat application plugable with
    # ircd and darkirc
    weechat
    # Messaging apps
    session-desktop
    signal-desktop
    element-desktop
    telegram-desktop

    # Bottom tier apps
    discord
  ];
}
