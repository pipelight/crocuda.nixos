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

    # Mail client
    thunderbird-bin

    # Media player
    vlc

    # Messaging apps
    session-desktop
    signal-desktop
    element-desktop
    telegram-desktop

    # Image manipulation tools
    gimp
    # Video manipulation tools
    ffmpeg
    mkvtoolnix
    mediainfo

    # Bottom tier apps
    discord
  ];

  home.file = {
    # ".config/keepassxc/keepassxc.ini".source = dotfiles/keepassxc/keepassxc.ini;
  };
}
