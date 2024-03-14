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

    eww
    swww
    wev
    # notifications
    dunst
  ];
  home.file = {
    ".profile".source = dotfiles/.profile;

    ".config/hypr".source = dotfiles/hypr;
    ".config/eww".source = dotfiles/eww;
    ".config/yofi".source = dotfiles/yofi;
  };
}
