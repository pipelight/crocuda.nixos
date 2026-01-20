{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf config.crocuda.shell.utils.enable {
    home.packages = with pkgs; [
      # File convertion
      # dasel

      # Get info on dir
      fastfetch
      onefetch

      # Js utils
      # jo
      jq
      # yq-go

      # Inspect fs and io

      duf # df replacement
      dysk

      pciutils
      lshw

      # Process management
      # btop
      lsof

      # Linux capabilities
      libcap

      # ssh
      ggh
    ];
  }
