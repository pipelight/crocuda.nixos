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
  imports = [
    # Hypervisors
    ./cloud-hypervisor.nix
    ./virshle.nix
    ./libvirt.nix # deprecated usage over virshle
    # Containers
    ./docker.nix
    # Cloud-init
    ./init.nix
  ];

  environment.systemPackages = with pkgs; [
    # Build images based on flakes and local config
    nixos-generators
    cdrkit
  ];

  home-merger = {
    enable = true;
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };
}
