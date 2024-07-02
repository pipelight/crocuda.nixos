{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # Torrenting
    inputs.rustmission.packages.${system}.default
  ];
  home.file = {
    "config/rustmission/config.toml".source = dotfiles/rustmission/config.toml;
  };
}
