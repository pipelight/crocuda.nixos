## Drawing software
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # Drawing
    inkscape
    gimp

    # Image manipulation tools
    imagemagick
    ghostscript
  ];
}
