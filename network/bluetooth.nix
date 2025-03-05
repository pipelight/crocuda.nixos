{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.network.bluetooth.enable {
      ##########################
      ## Bluetooth

      hardware.bluetooth = mkIf cfg.network.bluetooth.enable {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
            ControllerMode = "bredr";
            # ControllerMode = "dual";
            FastConnectable = true;
            Experimental = true;
            KernelExperimental = false;
          };
          Policy = {
            AutoEnable = true;
          };
        };
        input = {
          General = {
            ClassicBondedOnly = false;
            UserspaceHID = true;
          };
        };
        network = {
          General = {
            DisableSecuriy = true;
          };
        };
      };
      services.blueman = mkIf cfg.network.bluetooth.enable {
        enable = true;
      };

      users.groups = let
        users = cfg.users;
      in {
        bluetooth.members = users;
      };

      # systemd.tmpfiles.rules = [
      #   "d /var/lib/bluetooth 700 root root - -"
      # ];
    }
