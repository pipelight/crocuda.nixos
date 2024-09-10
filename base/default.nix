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
    ./yubikey.nix
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
    # doas
    # Versioning
    git
    util-linux
    sqlite
    usql
    # Query
    curl
    wget
    # Builders
    gnumake
    cmake
    bintools

    # Js utils
    jo
    jq
    yq-go
  ];
}
