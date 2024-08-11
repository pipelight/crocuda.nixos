{
  description = "crocuda.nixos - NixOS configuration modules for paranoids and hypocondriacs";

  inputs = {
    # NixOs pkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    ###################################
    ## Crocuda dependencies
    # NixOs tidy and dependencies
    nixos-tidy = {
      url = "github:pipelight/nixos-tidy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      # url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NUR - Nix User Repository
    nur.url = "github:nix-community/NUR";
    # Utils
    flake-utils.url = "github:numtide/flake-utils";
    impermanence.url = "github:nix-community/impermanence";
    # Flakes
    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    pipelight.url = "github:pipelight/pipelight?ref=dev";
    jucenit.url = "github:pipelight/jucenit?ref=dev";
    virshle.url = "github:pipelight/virshle";
    # LLM
    # ollama.url = "github:havaker/ollama-nix";
    # Torrent
    rustmission.url = "github:intuis/rustmission";
    # Servers
    # Git Radicle
    radicle.url = "git+https://seed.radicle.garden/z3gqcJUoA1n9HaHKufZs5FCSGazv5";
    # radicle-interface.url = "git+https://seed.radicle.garden/z4V1sjrXqjvFdnCUbxPFqd5p4DtH5";
    # rust-overlay.url = "github:oxalica/rust-overlay";
    # WM - Window manager
    yofi.url = "github:l4l/yofi";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosModules = {
      # Default module
      default = ./default.nix;
    };
  };
}
