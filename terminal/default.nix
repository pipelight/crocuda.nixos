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
    modules = with lib; [
      (mkIf cfg.terminal.shell.fish.enable
        ./fish.nix)
      (mkIf cfg.terminal.emulators.enable
        ./kitty.nix)
      (mkIf cfg.terminal.shell.utils.enable
        ./utils.nix)
    ];
  };

  # Add essential developper packages
  environment.systemPackages = with pkgs; [
    # base commands
    eza

    # Usefull commands
    htop
    btop
    nushell

    # Archive
    unzip
  ];
}
