{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  boot.kernelParams = ["nr_hugepages=102400"];
  imports = [
    ./docker.nix
    ./libvirt.nix
    ./init.nix
  ];
}
