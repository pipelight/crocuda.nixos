################################
## Databases simple engines and cli
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in {
  environment.systemPackages = with pkgs; [
    # Database
    sqlite
    usql
  ];
}
