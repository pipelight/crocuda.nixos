{
  description = "A flake that uses crocuda.nixos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    normal.url = "github:pipelight/normal.nixos?ref=dev";

    ###################################
    ### crocuda.nixos dependencies
    nixos-tidy = {
      url = "github:pipelight/nixos-tidy?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ###################################
    ## Servers
    # Git
    radicle = {
      url = "git+https://seed.radicle.garden/z3gqcJUoA1n9HaHKufZs5FCSGazv5";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Dns
    dns = {
      url = "github:kirelagin/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs"; # (optionally)
    };
    dora = {
      url = "github:pipelight/dora";
    };
    # CI/CD
    pipelight = {
      url = "github:pipelight/pipelight?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Virtualization
    virshle = {
      url = "github:pipelight/virshle?ref=dev";
    };
    # Admin safeguard
    boulette = {
      url = "github:pipelight/boulette?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs;
  in rec {
    nixosConfigurations = {
      # Default module
      default = pkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ../commons/configuration.nix
          ../commons/hardware-configuration.nix

          inputs.crocuda.nixosModules.default

          ###################################
          # You may move this module into its own file.
          ({
            lib,
            inpus,
            config,
            ...
          }: {
            crocuda = {
              users = ["anon"];
              font = {
                enable = true;
                size = 11;
              };
              terminal = {
                torrent = {
                  enable = true;
                };
              };
              wm = {
                niri.enable = true;
                gnome.enable = true;
              };
            };
          })
          ###################################
        ];
      };
    };
    packages."${system}" = {
      default = nixosConfigurations.default.config.system.build.toplevel;
    };
  };
}
