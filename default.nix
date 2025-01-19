#####################################
## Umport
{
  config,
  lib,
  pkgs,
  pkgs-stable,
  pkgs-unstable,
  pkgs-deprecated,
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
      inputs.nur.modules.nixos.default
      # Tidy
      inputs.nixos-tidy.nixosModules.home-merger
      inputs.nixos-tidy.nixosModules.allow-unfree

      # Boulette
      inputs.boulette.nixosModules.default
    ]
    ++ inputs.nixos-tidy.umport umport_params;

  home-merger = {
    extraSpecialArgs = {
      inherit inputs cfg pkgs-stable pkgs-unstable pkgs-deprecated;
    };
    users = cfg.users;
    modules =
      [
        inputs.nur.modules.homeManager.default
        inputs.arkenfox.hmModules.arkenfox

        # Boulette
        inputs.boulette.hmModules.default
      ]
      ++ inputs.nixos-tidy.umport-home umport_params;
  };
}
