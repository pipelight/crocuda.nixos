{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # WebBrowsers
    # qutebrowser
    lynx
    ddgr

    # Media
    vlc

    # Mail client
    thunderbird-bin

    # Messaging app
    # Top tier
    session-desktop
    signal-desktop
    element-desktop
    telegram-desktop

    # Bottom tier apps
    discord

    # Image and video manipulation
    gimp
    ffmpeg
    mkvtoolnix
    mediainfo
  ];

  home.file = {
    # ".config/keepassxc/keepassxc.ini".source = dotfiles/keepassxc/keepassxc.ini;
  };
}
