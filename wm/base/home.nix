{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # Media player
    vlc
    # Image manipulation tools
    gimp
    # Video manipulation tools
    ffmpeg
    mkvtoolnix
    mediainfo
    # Download videos
    yt-dlp
  ];

  home.file = {
    # ".config/keepassxc/keepassxc.ini".source = dotfiles/keepassxc/keepassxc.ini;
    ".profile".source = dotfiles/.profile;
  };
}
