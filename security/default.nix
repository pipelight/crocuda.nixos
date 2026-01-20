{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  ###################################
  # Admin users
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
    wheel.members = config.crocuda.users;
  };

  ###################################
  # Molly guard
  services.boulette = mkIf config.crocuda.servers.security.enable {
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
