{
  description = "crocuda.nixos - NixOS configuration modules for servers (and paranoids and hypochondriacs)";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

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

    # nixos-cli.url = "github:water-sucks/nixos";

    # sops-nix.url = "github:Mic92/sops-nix";

    # NixOs tidy and dependencies
    nixos-tidy = {
      url = "github:pipelight/nixos-tidy?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      # url = "github:nix-community/home-manager?ref=release-24.05";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NUR - Nix User Repository
    nur.url = "github:nix-community/NUR";

    # Utils
    # impermanence.url = "github:nix-community/impermanence";

    # Flakes
    dns = {
      url = "github:kirelagin/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs"; # (optionally)
    };
    dora = {
      url = "github:pipelight/dora";
      # url = "/home/anon/.ghr/github.com/pipelight/dora";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    pipelight = {
      url = "github:pipelight/pipelight?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    virshle = {
      url = "github:pipelight/virshle?ref=dev";
    };
    ###################################
    # LLM
    # ollama.url = "github:havaker/ollama-nix";
    # Torrent
    rustmission = {
      url = "github:intuis/rustmission";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Servers
    # Git Radicle
    radicle = {
      url = "git+https://seed.radicle.garden/z3gqcJUoA1n9HaHKufZs5FCSGazv5";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # radicle-interface.url = "git+https://seed.radicle.garden/z4V1sjrXqjvFdnCUbxPFqd5p4DtH5";
    # rust-overlay.url = "github:oxalica/rust-overlay";

    ###################################
    ## Else
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
    lib = nixpkgs.lib;
    specialArgs = rec {
      inherit inputs;
      pkgs = import nixpkgs;
      pkgs-stable = import nixpkgs-stable;
      pkgs-unstable = import nixpkgs-unstable;
      pkgs-deprecated = import nixpkgs-deprecated;
    };
  in rec {
    # For internal usage
    slib = lib;
    lib = import ./lib {
      inherit inputs;
      inherit lib;
    };
    nixosModules = {
      default = ./default.nix;
      inherit specialArgs;
      inherit slib;
    };
  };
}
