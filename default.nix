#####################################
## Umport
{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: let
  cfg = config.crocuda;
  umport_params = {
    exclude = [./flake.nix ./default.nix];
    paths = [
      ./.
    ];
  };
in {
  imports =
    [
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
    ]
    ++ inputs.nixos-tidy.umport umport_params;

  home-merger = {
    extraSpecialArgs = {
      inherit inputs cfg pkgs-unstable;
    };
    users = cfg.users;
    modules =
      [
        inputs.nur.hmModules.nur
        inputs.arkenfox.hmModules.arkenfox
      ]
      ++ inputs.nixos-tidy.umport-home umport_params;
  };
}
