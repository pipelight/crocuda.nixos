{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # Yofi and dependencies
    inputs.yofi.packages.${system}.default
    # libnotify
    # fontconfig

    # Wallpapers
    # inputs.wpaperd.packages.${system}.default
    swww

    eww
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
