{
  description = "crocuda.nixos - Some NixOS configuration modules for paranoids";

  inputs = {
    # Nixos pkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
    ollama.url = "github:havaker/ollama-nix";
    # Servers
    mail-server.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    # WM
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
