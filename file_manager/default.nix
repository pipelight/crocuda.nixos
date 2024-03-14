{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  # Import home files
  home-merger = {
    enable = true;
    users = cfg.users;
    modules = [
      ./home.nix
    ];
  };
}
