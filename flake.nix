{
  description = "crocuda.nixos - Some NixOS configuration modules for paranoids";

  inputs = {
    # Nixos pkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Nixos utils and dependencies
    nixos-utils = {
      url = "github:pipelight/nixos-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ###################################
    ## Crocuda dependencies
    # NUR - Nix User Repository
    nur.url = "github:nix-community/NUR";
    # Utils
    flake-utils.url = "github:numtide/flake-utils";
    impermanence.url = "github:nix-community/impermanence";
    # Flakes
    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    pipelight.url = "github:pipelight/pipelight";
    virshle.url = "github:pipelight/virshle";
    jucenit.url = "github:pipelight/jucenit";
    # ollama.url = "github:havaker/ollama-nix";
    # hyprland.url = "github:hyprwm/Hyprland";

    # Servers
    # Racicle
    radicle.url = "git+https://seed.radicle.garden/z3gqcJUoA1n9HaHKufZs5FCSGazv5";
    # radicle-interface.url = "git+https://seed.radicle.garden/z4V1sjrXqjvFdnCUbxPFqd5p4DtH5";
    # rust-overlay.url = "github:oxalica/rust-overlay";
    # mail-server.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    # WM
    yofi.url = "github:l4l/yofi";
    # wpaperd.url = "github:danyspin97/wpaperd";
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
