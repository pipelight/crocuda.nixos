{
  description = "NixOs flake decentralized finance apps";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    darkfi.url = "github:pipelight/darkfi.nix";
  };

  outputs = {
    nixpkgs,
    darkfi,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs;
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
          # Allow shity apps
          cfg = config.services.defi;
        in {
          # Set the module options
          options.services.defi = {
            enable = mkOption {
              type = with types; bool;
              description = "Enable services";
              default = true;
            };
            users = mkOption {
              type = with types; listOf str;
              description = ''
                The name of the user for whome to add this module.
              '';
              default = ["anon"];
            };
          };
          imports = [
            ./default.nix
          ];
        };
    };
  };
}
