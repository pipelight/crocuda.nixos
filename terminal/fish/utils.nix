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

    # A terminal based chat application plugable with
    # ircd and darkirc
    weechat

    # Js utils
    jo
    jq
    yq-go

    ## Fish Shell dependencies
    starship
    fish

    # Recolorize commands
    grc
    bat

    # Nixos doc
    manix

    # Dotenv, environment autoload
    nix-direnv
    nix-index

    # base commands
    eza

    # Archive
    unzip

    # Process management
    # btop
    htop

    nushell
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
