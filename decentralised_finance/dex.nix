{
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.finance.darkfi.enable {
      environment.systemPackages = with pkgs; [
        # Dex
        exodus
        # bisq-desktop
      ];
    }
