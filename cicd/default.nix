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
    mkIf cfg.cicd.enable {
      home-merger = {
        enable = true;
        extraSpecialArgs = {inherit inputs;};
        users = cfg.users;
        modules = [
          ./home.nix
        ];
      };
      environment.systemPackages = with pkgs; [
        # CICD
        just
        gnumake
        # Pipelight from flake
        inputs.pipelight.packages.${system}.default
      ];
    }
