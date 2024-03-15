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
    ./users.nix
  ];

  # User specific
  home-merger = {
    enable = true;
    extraSpecialArgs = {inherit pkgs inputs system;};
    users = cfg.users;
    modules = [
      # Add single top level NUR for other modules
      inputs.nur.hmModules.nur
      ./home.nix
    ];
  };

  environment.systemPackages = with pkgs; [
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
