{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf cfg.office.video-editing.enable {
    home.packages = with pkgs; [
      # Media player
      vlc

      # Video manipulation tools
      ffmpeg
      mkvtoolnix
      mediainfo

      # Download videos
      yt-dlp
    ];
  }
