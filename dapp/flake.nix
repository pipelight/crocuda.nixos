{
  description = "NixOs flake decentralized must have apps";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";

    mail-server.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    arkenfox.url = "github:pipelight/arkenfox-nixos";
  };

  outputs = {
    nixpkgs,
    nur,
    mail-server,
    arkenfox,
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
          cfg = config.services.dapp;
        in {
          # Set the module options
          options.services.dapp = {
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
