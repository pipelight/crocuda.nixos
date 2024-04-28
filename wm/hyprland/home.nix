{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
  convert_to_grayscale = pkgs.writeShellScriptBin "convert_to_grayscale" ''
    convert $1 -colorspace gray $1.gray.jpeg
  '';
in {
  home.packages = with pkgs; [
    # Yofi and dependencies
    inputs.yofi.packages.${system}.default
    #libnotify
    #fontconfig

    # Wallpapers
    #inputs.wpaperd.packages.${system}.default
    feh
    convert_to_grayscale
    swww

    # toolbars
    eww

    # utils
    wev

    # notifications
    dunst
  ];
  home.file = {
    ## Hyprland specific
    # Utils functions
    # ".config/hypr".source = dotfiles/hypr;
    ".config/hypr/utils".source = dotfiles/hypr/utils;
    ".config/hypr/rules.conf".source = dotfiles/hypr/rules;
    ".config/hypr/theme.conf".source = dotfiles/hypr/rules;

    # Keyboard layouts
    ".config/hypr/binds.conf".source = with lib;
      mkMerge [
        (mkIf (cfg.keyboard.layout == "colemak-dh") dotfiles/hypr/binds/colemak.conf)
        (mkIf (cfg.keyboard.layout == "azerty") dotfiles/hypr/binds/azerty.conf)
        (mkIf (cfg.keyboard.layout == "qwerty") dotfiles/hypr/binds/qwerty.conf)
      ];

    ".profile".source = dotfiles/.profile;

    ".config/wpaperd/wallpaper.toml".source = dotfiles/wpaperd/wallpaper.toml;

    # Widgets
    ".config/eww".source = dotfiles/eww;
    ".config/yofi".source = dotfiles/yofi;
  };
}
