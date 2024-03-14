{
  description = "crocuda.nixos - NixOS configuration for paranoids";

  inputs = {

    # Nixos profile
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # NUR - Nix User Repository
    nur.url = "github:nix-community/NUR";

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


    # Flakes
    pipelight.url = "github:pipelight/pipelight";
    virshle.url = "github:pipelight/virshle";
    ollama.url = "github:havaker/ollama-nix";

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
