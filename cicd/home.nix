{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # Pipelight from flake
    inputs.pipelight.packages.${system}.default
  ];
}
