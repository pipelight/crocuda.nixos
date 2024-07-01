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
    # Torrent cli
    inputs.rustmission.packages.${system}.default

    # File manager
    yazi
  ];

  home.file = {
    "config/rustmission/config.toml".source = dotfiles/rustmission/config.toml;
  };
}
