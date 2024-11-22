{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # https://nixos.wiki/wiki/Cursor_Themes
  bibata = pkgs.runCommand "moveUp" {} ''
    mkdir -p $out/share/icons
    ln -s ${pkgs.fetchzip {
      url = "https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Ice.tar.xz";
      hash = "sha256-wCrIjQo7eKO+piIz88TZDpMnc51iCWDYBR7HBV8/CPI=";
    }} $out/share/icons/bibata
  '';
  # Bspwm gnome css fix
  css = ''
    .window-frame, .window-frame:backdrop {
      box-shadow: 0 0 0 black;
      border-style: none;
      margin: 0;
      border-radius: 0;
    }
    .titlebar {
      border-radius: 0;
    }
  '';
in {
  home.sessionVariables = {
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
  };
  home.packages = with pkgs; [
    ## Gtk/Qt theme compatibility
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    qgnomeplatform
  ];
  # Cursor theming
  home.pointerCursor = {
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    name = "bibata";
    package = bibata;
  };

  # Gnome theming
  gtk = with pkgs; {
    gtk3.extraCss = css;
    gtk4.extraCss = css;
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = adw-gtk3;
    };
    iconTheme = {
      name = "Tela-circle";
      package = tela-circle-icon-theme;
    };
    font = {
      name = "JetBrainsMono";
      size = 11;
    };
  };
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "";
      };
    };
  };
  # Qt theming
  qt = with pkgs; {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "adwaita-dark";
      package = adwaita-qt;
    };
  };
}
