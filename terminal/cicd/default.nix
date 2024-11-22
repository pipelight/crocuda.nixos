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
      environment.systemPackages = with pkgs; [
        # CICD
        just
        gnumake
        # Pipelight from flake
        inputs.pipelight.packages.${system}.default
        # Secret managment
        novops
      ];
      environment.sessionVariables = {
        # Cpu friendly cargo build jobs
        CARGO_BUILD_JOBS = "10";
      };
    }
