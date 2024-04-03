{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  # Import home files
  home-merger = {
    enable = true;
    extraSpecialArgs = {inherit inputs;};
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };

  # Fonts
  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = ["JetBrainsMonoNL Nerd Font"];
        sansSerif = ["JetBrainsMonoNL Nerd Font"];
        serif = ["JetBrainsMonoNL Nerd Font"];
      };
    };
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "JetBrainsMono"
          "DroidSansMono"
        ];
      })
    ];
  };

  # Add essential developper packages
  environment.systemPackages = with pkgs; [
    # base commands
    eza
    lazygit

    # Usefull commands
    htop
    nushell

    # Archive
    unzip

    # utils
    cheat
    vhs
  ];
}
