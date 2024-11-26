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
      virtualisation.vswitch = {
        package = pkgs-unstable.openvswitch-dpdk;
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        # Network
        pkgs-unstable.openvswitch-dpdk
      ];
    }
