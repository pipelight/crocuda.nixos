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
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };
  };

  home.packages = with pkgs; [
    lutris
    bottles
  ];
}
