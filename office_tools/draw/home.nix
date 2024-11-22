## Drawing software
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.office.draw.enable {
      home.packages = with pkgs; [
        # Drawing
        inkscape
        gimp

        # Image manipulation tools
        imagemagick
        ghostscript
      ];
    }
