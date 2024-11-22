## Drawing software
{
  config,
  pkgs,
  lib,
  cfg,
  ...
}:
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
