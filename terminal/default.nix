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
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };
  # Loosen Security for fast sudoing
  security.sudo.extraRules = [
    {
      groups = ["wheel"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
  users.groups.wheel.members = config.services.developer.users;

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

    # web
    curl
    whois
    wget
    tshark
    # Usefull commands
    htop
    nushell
    # Archive
    unzip
    # Networking
    # VPN
    wireguard-tools
    iftop
    # utils
    cheat
    vhs
  ];
}
