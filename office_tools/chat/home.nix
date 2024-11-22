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
    mkIf cfg.chat.enable {
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
