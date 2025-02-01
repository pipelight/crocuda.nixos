{
  description = "crocuda.nixos - NixOS configuration modules for paranoids and hypocondriacs";

  inputs = {
    ###################################
    # NixOs pkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-deprecated.url = "github:nixos/nixpkgs/nixos-24.05";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ###################################
    ## Crocuda dependencies

    nixos-cli.url = "github:water-sucks/nixos";

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
    impermanence.url = "github:nix-community/impermanence";

    # Flakes
    arkenfox = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pipelight = {
      url = "github:pipelight/pipelight?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    virshle = {
      url = "github:pipelight/virshle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ###################################
    # WM - Window manager
    # hyprland = {
    #   type = "git";
    #   url = "https://github.com/hyprwm/Hyprland";
    #   submodules = true;
    #   ref = "refs/tags/v0.47.0";
    # };
    # hyprscroller = {
    #   url = "github:dawsers/hyprscroller";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # hyprfocus = {
    #   url = "github:pyt0xic/hyprfocus";
    #   inputs.hyprland.follows = "hyprland";
    # };
    yofi = {
      url = "github:l4l/yofi";
      inputs.nixpkgs.follows = "nixpkgs";
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
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-unstable,
    nixpkgs-deprecated,
    ...
  } @ inputs: {
    nixosModules = let
      specialArgs = {
        inherit inputs;
        pkgs = import nixpkgs {
          overlays = [inputs.nur.overlay];
        };
        pkgs-stable = import nixpkgs-stable;
        pkgs-unstable = import nixpkgs-unstable;
        pkgs-deprecated = import nixpkgs-deprecated;
      };
    in {
      # Default module
      inherit specialArgs;
      default = ./default.nix;
    };
  };
}
