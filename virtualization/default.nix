{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./docker.nix
    ./libvirt.nix
  ];
}
