{
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}: let
  # cfg = config.crocuda;
  convert_to_grayscale = pkgs.writeShellScriptBin "convert_to_grayscale" ''
    convert $1 -colorspace gray $1.gray.jpeg
  '';
in {
  ## Plugins
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # package = pkgs-unstable.hyprland;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.hyprscroller.packages.${pkgs.system}.default
      inputs.hyprfocus.packages.${pkgs.system}.default
    ];
    extraConfig = lib.readFile dotfiles/hypr/hyprland.conf;
  };

  home.packages = with pkgs; [
    # Yofi and dependencies
    inputs.yofi.packages.${system}.default

    # Font support
    libnotify
    fontconfig

    # Wallpapers
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
    ".config/hypr/utils".source = dotfiles/hypr/utils;

    # Keyindings
    ".config/hypr/binds".source = dotfiles/hypr/binds;

    ".config/hypr/rules.conf".source = dotfiles/hypr/rules.conf;
    ".config/hypr/theme.conf".source = dotfiles/hypr/theme.conf;
    # ".config/hypr/hyprland.conf".source = dotfiles/hypr/hyprland.conf;

    # Widgets
    ".config/eww".source = dotfiles/eww;
    ".config/yofi".source = dotfiles/yofi;
  };

  # Default keybindings
  systemd.user.tmpfiles.rules = with lib; let
    mode = "niri"; #or bspwm
  in [
    "L+ %h/.config/hypr/binds.default.conf - - - - %h/.config/hypr/binds/${cfg.keyboard.layout}.${mode}.conf"
  ];
}
