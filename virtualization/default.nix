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
        kernelParams = ["nr_hugepages=10240"];
        kernel.sysctl = {
          "vm.nr_hugepages" = 10240;
        };
      };
    }
