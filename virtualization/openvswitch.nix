{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.virtualization.openvswitch.enable {
      boot = {
        kernelParams = mkDefault ["nr_hugepages=1024"];
        kernel.sysctl = {
          "vm.nr_hugepages" = mkDefault 1024;
        };
      };
      virtualisation.vswitch = {
        package = pkgs.openvswitch-dpdk;
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        # Network manager
        openvswitch-dpdk
      ];
    }
