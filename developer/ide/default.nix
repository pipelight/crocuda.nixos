{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let

    cfg= config.services.developer;
in {
  # Import home files
  home-merger = {
    enable = true;
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };

  programs.nano.enable = false;
  # Add essential developer packages
  environment.systemPackages = with pkgs; [
    # Toolchains/Lang
    rustup
    gcc
    clang
    zig
    git
    go
    python3
    # text editor (IDE)
    vim
    neovim
    glow
    mods
  ];
}
