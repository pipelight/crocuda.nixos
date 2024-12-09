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
        kernelParams = ["nr_hugepages=10240"];
        kernel.sysctl = {
          "vm.nr_hugepages" = mkDefault 10240;
        };
      };
      virtualisation.vswitch = {
        package = pkgs-unstable.openvswitch-dpdk;
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        # Network
        pkgs-unstable.openvswitch-dpdk
      ];
    }
