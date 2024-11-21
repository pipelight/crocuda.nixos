{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.terminal.shell.fish.enable {
      home-merger = {
        enable = true;
        users = cfg.users;
        modules = [
          ./home.nix
          (mkIf cfg terminal.shell.utlis ./utils.nix)
        ];
      };
    }
