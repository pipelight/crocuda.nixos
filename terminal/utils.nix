{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # Fast find
    fzf
    fd
    atuin
    zoxide
    ripgrep
    tldr
    cheat

    # Dev utils
    neofetch
    onefetch

    # CICD
    just
    gnumake

    ## Fish Shell dependencies
    fish

    # Recolorize commands
    grc
    bat

    # Dotenv, environment autoload
    nix-direnv
    nix-index
  ];
}
