{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  imports =
    [
      # This Nixos module options definition.
      ./options.nix

      ######################
      # Modules
      inputs.impermanence.nixosModules.impermanence
      # Nur
      inputs.nur.nixosModules.nur
      # Lix
      inputs.lix-module.nixosModules.default
      # Tidy
      inputs.nixos-tidy.nixosModules.home-merger
      inputs.nixos-tidy.nixosModules.allow-unfree
      # Network
      inputs.nnf.nixosModules.default

      inputs.jucenit.nixosModules.jucenit
    ]
    ++ inputs.nixos-tidy.umport {
      paths = [
        # Umport do not work for the root_dir("./.") yet.
        ./android_compatibility
        ./base
        ./network
        ./browsers
        ./databases
        ./decentralised_finance
        ./office_tools
        ./virtualization
        ./servers
        ./terminal
        ./window_managers
      ];
    };

  home-merger = {
    enable = false;
    extraSpecialArgs = {
      inherit inputs cfg pkgs-unstable;
    };
    users = cfg.users;
    modules =
      [
        inputs.nur.hmModules.nur
        inputs.arkenfox.hmModules.arkenfox
      ]
      ++ inputs.nixos-tidy.umport-home {
        paths = [
          # Umport do not work for the root_dir("./.") yet.
          ./android_compatibility
          ./base
          ./network
          ./browsers
          ./databases
          ./decentralised_finance
          ./office_tools
          ./virtualization
          ./servers
          ./terminal
          ./window_managers
        ];
      };
  };
}
