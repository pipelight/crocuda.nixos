{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.virtualization.cloud-hypervisor.enable {
      boot = {
        # kernelParams = ["nr_hugepages=4194304"];
        # kernel.sysctl = {
        #   "vm.nr_hugepages" = 4194304; # 4_200_000kb = 4Mb
        # };
      };

      environment.systemPackages = with pkgs; [
        # Build images based on flakes and local config
        nixos-generators
        cdrkit
      ];
    }
