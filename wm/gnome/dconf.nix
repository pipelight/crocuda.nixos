{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "fish.desktop"
        "lutris.desktop"
        "nautilus.desktop"
      ];
    };
  };
  home.packages = with pkgs; [
    lutris
    bottle
  ];
}
