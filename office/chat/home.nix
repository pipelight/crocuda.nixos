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

    # Messaging apps
    session-desktop
    signal-desktop
    element-desktop
    telegram-desktop

    # Bottom tier apps
    discord
  ];
}
