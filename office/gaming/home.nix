##########################
## Gaming suite
# Emulators
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    lutris
    bottles
  ];
}
