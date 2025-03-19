#####################################
## Umport
{
  inputs,
  config,
  pkgs,
pkgs-stable,
pkgs-unstable,
pkgs-deprecated,
  ...
}: let
  cfg = config.crocuda;
  umport = {
      paths = [
        ./.
      ];
      exclude = [
        ./flake.nix
        ./default.nix
        ./lib
      ];
    };
in {
  imports = let
    slib = inputs.nixos-tidy.lib;
  in
    [
      ######################
      ## Modules
      # Secrets
      # inputs.sops-nix.nixosModules.default

      # inputs.impermanence.nixosModules.impermanence
      # Nur
      inputs.nur.modules.nixos.default
      # Tidy
      inputs.nixos-tidy.nixosModules.home-merger
      # inputs.home-manager.nixosModules.default
      inputs.nixos-tidy.nixosModules.allow-unfree
      # inputs.nixos-tidy.nixosModules.networking-privacy

      # Boulette
      inputs.boulette.nixosModules.default
    ]
    ++ slib.umportNixModules umport
  ++ slib.umportHomeModules umport
  # Function's second argument (home manager options)
  {
    users = cfg.users;
    extraSpecialArgs = {
      inherit inputs cfg pkgs-stable pkgs-unstable pkgs-deprecated;
    };
    imports = [
      ######################
      ## Modules
      # Secrets
      inputs.sops-nix.homeManagerModules.default
      # # Nur
      inputs.nur.modules.homeManager.default
      # Firefox
      inputs.arkenfox.hmModules.arkenfox
      # Boulette
      inputs.boulette.hmModules.default
    ];
  };
}
