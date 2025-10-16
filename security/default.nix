{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib; {
    ###################################
    # Adimin users
    # loosen security for fast sudoing
    security.sudo.extraRules = [
      {
        groups = ["wheel"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
    users.groups = {
      wheel.members = config.normal.users;
    };

    ###################################
    # Molly guard
    services.boulette = mkIf cfg.servers.security.enable {
      enable = true;
      enableFish = true;
      enableBash = true;
      sshOnly = false;
      enableSudoWrapper = true;
      challengeType = "hostname";
    };

    ###################################
    # Other

    services.dbus.implementation = "broker";

    security.polkit.enable = true;
  }
