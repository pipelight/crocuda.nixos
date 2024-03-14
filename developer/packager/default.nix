{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  homebrewModuleConf = {
    nix-homebrew = {
      # Install Homebrew under the default prefix
      enable = true;

      # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
      enableRosetta = true;

      # User owning the Homebrew prefix
      # user = config.services.developer.users;

      # Optional: Declarative tap management
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
        "pipelight/pipelight" = inputs.pipelight;
      };

      # Optional: Enable fully-declarative tap management
      # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
      mutableTaps = false;
    };
  };
in {
  ## Packaging
  # Packaging for MacOs
  # imports = [
  # inputs.nix-homebrew.darwinModules.nix-homebrew
  # homebrewModule
  # {inherit lib;}
  # ];
  # Packaging for Arch linux AUR
  environment.systemPackages = with pkgs; [
    # Packaging for Arch linux AUR
    pacman
  ];
  environment.etc."makepkg.conf".source = "${pkgs.pacman}/etc/makepkg.conf";
}
