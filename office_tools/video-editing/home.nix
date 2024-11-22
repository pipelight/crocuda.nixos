{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
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

      home.file = {
        # ".config/keepassxc/keepassxc.ini".source = dotfiles/keepassxc/keepassxc.ini;
        ".profile".source = dotfiles/.profile;
      };
    }
