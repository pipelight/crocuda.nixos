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
    ./users.nix
  ];

  # User specific
  home-merger = {
    enable = true;
    extraSpecialArgs = {inherit pkgs inputs;};
    users = cfg.users;
    modules = [
      # Add single top level NUR for other modules
      inputs.nur.hmModules.nur
      ./home.nix
    ];
  };

  environment.systemPackages = with pkgs; [
    git
  ];
}
