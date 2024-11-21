{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  # Automatic user creation
  imports = [
    # Add single top level NUR for other modules
    # inputs.nur.nixosModules.nur
    ./users.nix
  ];

  # User specific
  home-merger = {
    enable = true;
    users = cfg.users;
    modules = [
      # Add single top level NUR for other modules
      # inputs.nur.hmModules.nur
      ./home.nix
    ];
  };

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

    # Query
    curl
    wget

    #File management
    rsync

    # Builders
    gnumake
    cmake
    bintools
  ];
}
