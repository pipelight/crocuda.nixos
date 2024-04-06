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
    util-linux
    sqlite
    # Query
    curl
    wget
    # Builders
    gnumake
    cmake

    # Language engines
    deno
    bun
    nodejs_latest
    jo
    jq
    yq-go

    # CICD
    just
    gnumake
    # Pipelight from flake
    inputs.pipelight.packages.${system}.default
  ];
}
