{
  description = "crocuda.nixos - NixOS configuration modules for servers (and paranoids and hypochondriacs)";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    ###################################
    # NixOs pkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-deprecated.url = "github:nixos/nixpkgs/nixos-24.11";

    ###################################
    ## Crocuda dependencies
    nix-std.url = "github:chessai/nix-std";
    # NixOs tidy and dependencies
    nixos-tidy = {
      url = "github:pipelight/nixos-tidy?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Flakes
    dns = {
      url = "github:kirelagin/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs"; # (optionally)
    };
    dora = {
      url = "github:pipelight/dora";
      # inputs.nixpkgs.follows = "nixpkgs";
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
    # Servers
    # Git Radicle
    radicle = {
      url = "git+https://seed.radicle.garden/z3gqcJUoA1n9HaHKufZs5FCSGazv5";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # SysAdmin
    boulette = {
      url = "github:pipelight/boulette?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-parts,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-unstable,
    nixpkgs-deprecated,
    ...
  } @ inputs: let
    slib = inputs.nixos-tidy.lib;
    specialArgs = {
      inherit slib;
      inherit inputs;
      pkgs = import nixpkgs;
      pkgs-stable = import nixpkgs-stable;
      pkgs-unstable = import nixpkgs-unstable;
      pkgs-deprecated = import nixpkgs-deprecated;
    };
    umport = {
      paths = [
        ./.
      ];
      exclude = [
        # Testing dir
        ./templates

        ./flake.nix
        ./default.nix

        # package derivations
        ./servers/dns/hickory.latest.nix
      ];
    };
  in {
    nixosModules = {
      inherit specialArgs;
      inherit slib;
      default = {
        config,
        pkgs,
        lib,
        ...
      }: {
        imports =
          [
            # Tidy
            inputs.nixos-tidy.nixosModules.allow-unfree
            # Virshle
            inputs.virshle.nixosModules.default
            # Boulette
            inputs.boulette.nixosModules.default
            # Dhcp: experimental dhcp server.
            inputs.dora.nixosModules.default
          ]
          ++ slib.getNixModules umport;
      };
    };
    homeModules = {
      inherit specialArgs;
      inherit slib;
      default = {
        config,
        pkgs,
        lib,
        ...
      }: {
        imports =
          [
            # Boulette
            inputs.boulette.hmModules.default
          ]
          ++ slib.getHomeModules umport;
      };
    };
  };
}
