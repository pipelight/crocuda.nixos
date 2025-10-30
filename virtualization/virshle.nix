{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
  mkIf config.crocuda.virtualization.utils.enable {
    environment.systemPackages = with pkgs; [
      # Build images based on flakes and local config
      nixos-generators
      rqlite
      disko
      cdrkit
    ];
  }
