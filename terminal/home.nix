{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib; {
    imports = [
      ./fish.nix
      ./kitty.nix
    ];
  }
