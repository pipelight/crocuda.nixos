{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # Torrent Gui
    pkgs-unstable.qbittorrent

    # Additional web browsers
    # GUI
    # qutebrowser
    # TUI
    # browsh-vim
    lynx
    ddgr
  ];
}
