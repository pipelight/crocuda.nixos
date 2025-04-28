{
  config,
  pkgs,
  pkgs-unstable,
  pkgs-stable,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.virtualization.virshle.enable {
      systemd.tmpfiles.rules = [
        "d '/var/lib/virshle' 774 root users - -"
        # "Z '/var/lib/virshle' 774 root users - -"
      ];

      boot.kernelModules = ["openvswitch"];
      environment.systemPackages = with pkgs; [
        # Build images based on flakes and local config
        nixos-generators
        rqlite
        disko
        cdrkit
      ];
    }
