{
  config,
  pkgs,
  lib,
  inputs,
  system,
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
    extraSpecialArgs = {inherit pkgs system;};
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

  environment.systemPackages = with pkgs; [
    # doas
    # Versioning
    git
    # Query
    curl
    wget
    # Builders
    gnumake
    cmake
  ];
}
