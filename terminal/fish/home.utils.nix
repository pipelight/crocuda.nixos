{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # Move fast in filesystem
    fzf
    fd
    atuin
    zoxide
    ripgrep
    eza

    # Mini man pages
    cheat
    tealdeer

    expect

    # File convertion
    dasel

    # Get info on dir
    fastfetch
    onefetch

    # A terminal based chat application plugable with
    # ircd and darkirc
    weechat

    # Js utils
    jo
    jq
    yq-go

    # Recolorize commands
    grc
    bat

    # Nixos doc
    manix

    # Dotenv, environment autoload
    nix-direnv
    nix-index

    # Inspect fs and io
    pciutils
    lshw

    bintools
    pkg-config

    # Process management
    # btop
    htop
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
