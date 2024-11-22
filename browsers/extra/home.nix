{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # Torrent Gui
    pkgs-unstable.qbittorrent

    ## Additional web browsers
    # GUI
    # qutebrowser
    # tor-browser

    # TUI
    # browsh-vim
    # lynx
    # ddgr
  ];
}
