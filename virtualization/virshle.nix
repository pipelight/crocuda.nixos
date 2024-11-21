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
    mkIf cfg.virtualization.virshle.enable {
      systemd.tmpfiles.rules = [
        "d '/var/lib/virshle/vm' 774 root users - -"
        "Z '/var/lib/virshle/vm' 774 root users - -"

        "d '/var/lib/virshle/socket' 774 root users - -"
        "Z '/var/lib/virshle/socket' 774 root users - -"

        "d '/var/lib/virshle/net' 774 root users - -"
        "Z '/var/lib/virshle/net' 774 root users - -"

        "d '/var/lib/virshle/disk' 774 root users - -"
        "Z '/var/lib/virshle/disk' 774 root users - -"

        "d '/var/lib/virshle' 774 root users - -"
        "Z '/var/lib/virshle' 774 root users - -"
      ];

      boot.kernelModules = ["openvswitch"];
      environment.systemPackages = with pkgs; [
        # VMMs
        cloud-hypervisor

        # Build images based on flakes and local config
        nixos-generators
        disko
        cdrkit

        # Network
        pkgs-unstable.openvswitch
      ];
    }
