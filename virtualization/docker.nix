{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf config.crocuda.virtualization.docker.enable {
    # Enable docker usage
    virtualisation.docker.enable = true;
    # Enable podman usage
    virtualisation.podman.enable = true;

    users.groups = let
      users = cfg.users;
    in {
      docker.members = users;
    };
  }
