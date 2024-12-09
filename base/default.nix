{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  # Loosen Security for fast sudoing
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
  users.groups.wheel.members = cfg.users;

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    #doas

    # Versioning
    git
    util-linux

    # Builders
    gnumake
    cmake
    bintools
  ];
}
