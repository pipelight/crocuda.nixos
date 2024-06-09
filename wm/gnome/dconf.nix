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

  allow-unfree = [
    "steam"
  ];

  home.packages = with pkgs; [
    lutris
    bottles
  ];
}
