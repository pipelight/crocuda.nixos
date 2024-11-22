{
  config,
  pkgs,
  lib,
  inputs,
  cfg,
  ...
}:
with lib;
  mkIf cfg.wm.gnome.enable {
    home.packages = with pkgs; [
      ## Gnome minimal apps
      # image viewer
      loupe
      # pdf viewer
      evince
      invoice
    ];

    # Default apps
    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "application/pdf" = ["org.gnome.Evince.desktop"];
        "application/images" = ["org.gnome.Loupe.desktop"];
        "image/jpeg" = ["org.gnome.Loupe.desktop"];
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
      };
      defaultApplications = {
        "application/pdf" = ["org.gnome.Evince.desktop"];
        "application/images" = ["org.gnome.Loupe.desktop"];
        "image/jpeg" = ["org.gnome.Loupe.desktop"];
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
      };
    };
  }
