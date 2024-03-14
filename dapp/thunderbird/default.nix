{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.services.dapp;
in {
  # Enable arkenfox
  home-merger = {
    enable = true;
    extraSpecialArgs = {
      inherit pkgs;
    };
    users = cfg.users;
    modules = [
      inputs.nur.hmModules.nur
    ];
  };
}

