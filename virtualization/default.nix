{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  boot.kernelParams = ["nr_hugepages=102400"];
  environment.systemPackages = with pkgs; [
    # Build images based on flakes and local config
    nixos-generators
    cdrkit
  ];
}
