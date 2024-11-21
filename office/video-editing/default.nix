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
    mkIf cfg.office.video-editing.enable {
      home-merger = {
        enable = true;
        extraSpecialArgs = {inherit inputs;};
        users = cfg.users;
        modules = [
          ./home.nix
        ];
      };
    }
