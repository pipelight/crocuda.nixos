{
  inputs,
  config,
  cfg,
  pkgs,
  lib,
  ...
}:
with lib;
  mkIf cfg.terminal.shell.utils.enable {
    home.packages = with pkgs; [
      sops
      age
      ssh-to-age # ed25519 to age
    ];
  }
