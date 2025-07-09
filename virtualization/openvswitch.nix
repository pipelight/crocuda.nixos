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
      virtualisation.vswitch = mkDefault {
        enable = true;
      };

      systemd.services.ovsdb.serviceConfig.Group = "users";
      systemd.services.ovsdb.serviceConfig.ExecStartPost = [
        "-${pkgs.coreutils}/bin/chown -R root:users /var/run/openvswitch"
        "-${pkgs.coreutils}/bin/chmod -R 774 /var/run/openvswitch"
      ];
      systemd.services.ovs-vswitchd.serviceConfig.Group = "users";
      systemd.services.ovs-vswitchd.serviceConfig.ExecStartPost = [
        "-${pkgs.coreutils}/bin/chown -R root:users /var/run/openvswitch"
        "-${pkgs.coreutils}/bin/chmod -R 774 /var/run/openvswitch"
      ];
    }
