{
  description = "NixOS configuration for developers";

  # This flake/file is the main file that gather every nix configuration in this directory
  # This flake doesn't build any binaries and isn't meant to be used as is.
  # It exports a nixosModule to be used from inside another flake.

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Flakes
    pipelight.url = "github:pipelight/pipelight";
    virshle.url = "github:pipelight/virshle";
    ollama.url = "github:havaker/ollama-nix";

    # Utils
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    home-merger = {
      url = "github:pipelight/home-merger";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Optional: Declarative tap management
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    # home-manager,
    home-merger,
    impermanence,
    pipelight,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs;
    homeMergerModule = home-merger.nixosModules.home-merger;
    # homeManagerModule = home-manager.nixosModules.home-manager;
    impermanenceModule = impermanence.nixosModules.impermanence;
  in {
    nixosModules = {
      # Default module
      default = {
        config,
        pkgs,
        lib,
        utils,
        ...
      }:
        with inputs;
        with lib; {
          # Set the module options
          options.services.developer = {
            enable = mkEnableOption ''
              Toggle the module
            '';
            users = mkOption {
              type = with types; listOf str;
              description = ''
                The name of the user for whome to add this module.
              '';
              default = ["anon"];
            };
            llm = {
              enable = mkEnableOption ''
                Toggle the module
              '';
            };
          };

          imports = [
            ./terminal/default.nix
            ./git/default.nix
            ./ide/default.nix

            ./virtualization/default.nix

            ./packager/default.nix

            ./llm/default.nix
          ];
        };
    };
  };
}
