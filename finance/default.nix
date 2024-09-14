{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./monero.nix
    ./wownero.nix
    ./darkfi.nix
  ];
}
