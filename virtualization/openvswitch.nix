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
        kernelParams = ["nr_hugepages=1000"];
        kernel.sysctl = {
          "vm.nr_hugepages" = mkDefault 1000;
        };
      };
      virtualisation.vswitch = {
        package = pkgs.openvswitch-dpdk;
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        # Network
        pkgs.openvswitch-dpdk
      ];
    }
