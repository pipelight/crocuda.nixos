{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.file = {
    ".config/yazi/keymap.toml".source = dotfiles/yazi/keymap.toml;
  };

  home.packages = with pkgs; [
    # File manager
    # ranger
    yazi
    ];

}
