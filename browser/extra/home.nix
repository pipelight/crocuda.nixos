{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # Torrent Gui
    qbittorrent

    # Additional web browsers
    # GUI
    # qutebrowser
    # TUI
    # browsh-vim
    lynx
    ddgr
  ];
}
