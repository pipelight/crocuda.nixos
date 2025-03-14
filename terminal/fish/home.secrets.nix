{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.terminal.shell.utils.enable {
      home.packages = with pkgs; [
        sops
        age
        ssh-to-age # ed25519 to age
      ];
    }
