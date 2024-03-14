{
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}: let
  darkfi = inputs.darkfi.packages.${system}.default;
in {
  home.packages = with pkgs; [
    # Darkfi suit
    # darkfi

    # Wallet
    # exodus
  ];

  ## Darkirc messaging background service
  systemd.user.services."darkirc" = {
    enable = false;
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${darkfi}/bin/darkirc";
    };
    wantedBy = ["multi-user.target"];
  };
}
