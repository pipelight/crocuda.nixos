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
  systemd.user.services.darkircd = {
    enable = false;
    Unit = {

      After = ["network.target"];
    };
    Service = {
      ExecStart = "${darkfi}/bin/darkirc";
    };
    Install = {
      WantedBy = ["multi-user.target"];
    };
  };
}
