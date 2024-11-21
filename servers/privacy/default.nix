{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./i2p.nix
    ./tor.nix
  ];
}
