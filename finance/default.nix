{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./monero.nix
    ./darkfi.nix
  ];
}
