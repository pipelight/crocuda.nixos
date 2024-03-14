{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Import home file
  home-merger = {
    enable = true;
    users = config.services.developer.users;
    modules = [
      ./home.nix
    ];
  };
}
