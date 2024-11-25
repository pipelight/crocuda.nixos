{
  config,
  pkgs,
  lib,
  inputs,
  cfg,
  ...
}:
with lib;
  mkIf cfg.office.write.enable {
    home.packages = with pkgs; [
      libreoffice
    ];
  }
