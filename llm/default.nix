{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  utils,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.llm.ollama.enable {
      # openblasSupport = false;
      environment.systemPackages = with pkgs; [
        cachix
        # pkgs-unstable.ollama
        cudatoolkit
        freeglut
        # Python dependencies managment
        poetry
      ];

      environment.variables = {
        OLLAMA_LLM_LIBRARY = "cuda_v12";
      };
      services.ollama = {
        package = pkgs.ollama;
        enable = true;
        acceleration = "cuda";
        # loadModels = ["mistral"];
        environmentVariables = {
          OLLAMA_LLM_LIBRARY = "cuda_v12";
        };
      };

      environment.sessionVariables = {
        OLLAMA_API_KEY = "";
      };
    }
