{
  description = "NixOS configuration for fancy minimal window managers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    impermanence.url = "github:nix-community/impermanence";

    # Custom home merger
    nixos-utils.url = "github:pipelight/nixos-utils";
  };

  outputs = {
    nixpkgs,
    nixos-utils,
    home-manager,
    impermanence,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs;
    homeManagerModule = home-manager.nixosModules.home-manager;
    impermanenceModule = impermanence.nixosModules.impermanence;
  in {
    nixosModules = {
      default = {
        config,
        pkgs,
        lib,
        inputs,
        ...
      }:
        with inputs;
        with lib; let
          # Shorter name to access final settings
          cfg = config.services.wm;
        in {
          # Set the module options
          options.services.wm = {
            enable = mkOption {
              type = with types; bool;
              description = "Enable services";
              default = true;
            };
            users = mkOption {
              type = with types; listOf str;
              description = ''
                The name of the users for whome to add this module.
              '';
              default = ["anon"];
            };
          };
          imports = [
            ./gnome/default.nix

            # Hyprland and Bspwm cannot be used simultaneously
            # because they overwrite the same ressources.
            ./hyprland/default.nix
            # ./bspwm/default.nix
          ];
        };
    };
  };
}
