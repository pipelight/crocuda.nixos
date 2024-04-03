{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
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
    ".profile".source = dotfiles/.profile;

    ".config/wpaperd/wallpaper.toml".source = dotfiles/wpaperd/wallpaper.toml;
    ".config/hypr".source = dotfiles/hypr;
    ".config/eww".source = dotfiles/eww;
    ".config/yofi".source = dotfiles/yofi;
  };
}
