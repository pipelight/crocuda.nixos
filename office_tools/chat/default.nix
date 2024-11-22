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
      # Allow bottom tier apps
      allow-unfree = [
        "discord"
      ];
    }
