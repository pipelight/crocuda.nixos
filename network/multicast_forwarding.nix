{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.network.multicast-forwarding.enable {
      # Compile kernel with multicast forwarding.
      boot.kernelPackages = with pkgs;
        linuxPackagesFor
        (
          pkgs.linux.override {
            structuredExtraConfig = with lib.kernel; {
              MROUTE = yes;
              # Options from: https://github.com/troglobit/smcroute
              IP_MROUTE = yes;
              IP_PIMSM_V1 = yes;
              IP_PIMSM_V2 = yes;
              IP_MROUTE_MULTIPLE_TABLES = yes;
              IPV6_MROUTE_MULTIPLE_TABLES = yes;
            };
            ignoreConfigErrors = true;
          }
        );
      # Add multicast forwarding daemon.
      environment.systemPackages = with pkgs; [
        smcroute
      ];
      # Run the daemon in the background.
      systemd.services.smcroute = {
        enable = true;
        description = "smcroute - static multicast routing for linux.";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = with pkgs; let
          package = smcroute;
        in {
          Type = "oneshot";
          User = "root";
          Group = "users";
          ExecStart = ''
            ${package}/bin/smcrouted -n -s
          '';
          StandardInput = "null";
          StandardOutput = "journal+console";
          StandardError = "journal+console";
        };
      };
    }
