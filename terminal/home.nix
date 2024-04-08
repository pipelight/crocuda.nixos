{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in with lib;{
  imports = [
    (mkIf cfg.terminal.shell.fish.enable ./fish.nix)
    (mkIf cfg.terminal.emulator.enable ./kitty.nix)
  ];
}
