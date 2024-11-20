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

    # Mini man pages
    cheat
    tealdeer

    expect

    # File convertion
    dasel

    # Dev utils
    fastfetch
    onefetch

    # CICD
    just
    gnumake

    ## Fish Shell dependencies
    starship
    fish

    # Recolorize commands
    grc
    bat

    # Dotenv, environment autoload
    nix-direnv
    nix-index
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
