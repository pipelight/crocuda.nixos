{
  description = "crocuda.nixos - Some NixOS configuration modules for paranoids";

  inputs = {
    # Nixos pkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # NUR - Nix User Repository
    nur.url = "github:nix-community/NUR";

    # Utils
    flake-utils.url = "github:numtide/flake-utils";
    impermanence.url = "github:nix-community/impermanence";
    nixos-utils = {
      url = "github:pipelight/nixos-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flakes
    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    pipelight.url = "github:pipelight/pipelight";
    inputs.nixpkgs.follows = "nixpkgs";
    virshle.url = "github:pipelight/virshle";
    ollama.url = "github:havaker/ollama-nix";

    # Servers
    mail-server.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
  };

  outputs = {self, ...} @ inputs: {
    nixosModules = {
      # Default module
      default = ./default.nix;
    };
  };
}
