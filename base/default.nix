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
    # Nixos easy cli
    inputs.nixos-cli.packages.${system}.default

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
