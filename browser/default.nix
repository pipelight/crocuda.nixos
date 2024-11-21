{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./extra/firefox
  ];
}
