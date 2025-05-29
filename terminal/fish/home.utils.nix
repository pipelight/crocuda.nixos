{
  config,
  cfg,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf cfg.terminal.shell.utils.enable {
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

      #cloned repos manager (ghq)
      pkgs-unstable.siketyan-ghr

      # Inspect fs and io
      duf # df replacement
      pciutils
      lshw

      # Process management
      # btop
      lsof

      # Linux capabilities
      libcap
    ];
  }
