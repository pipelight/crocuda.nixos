{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.services.developer;
in {
  # Import home files
  home-merger = {
    enable = true;
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };

    # Set default editor
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
  programs.nano.enable = false;

  # Add essential developer packages
  environment.systemPackages = with pkgs; [
    # Toolchains/Lang
    rustup
    gcc
    clang
    zig
    go
    python3

    # Text editor (IDE)
    vim
    neovim
    # Charm.sh
    glow
    mods
  ];
}
