{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  imports = [
    ./editor/default.nix
    ./kitty/default.nix
    ./llm/default.nix
  ];
}
