{
  config,
  pkgs,
  lib,
  utils,
  inputs,
  ...
}: let
  cfg = config.crocuda;
in
  with lib;
    mkIf cfg.terminal.llm.ollama.enable {
      allow-unfree = [
        # AI
        "lib.*"
        "cuda.*"
        # Nvidia
        "nvidia.*"
      ];

      # openblasSupport = false;
      environment.systemPackages = with pkgs; [
        cachix
        # pkgs-unstable.ollama
        cudatoolkit
        freeglut
        # Python dependencies managment
        poetry
      ];

      services.ollama = {
        package = pkgs.ollama;
        enable = true;
        acceleration = "cuda";
        # loadModels = ["mistral"];
        environmentVariables = {
          # OLLAMA_LLM_LIBRARY = "cuda_v12";
        };
      };

      environment.sessionVariables = {
        OLLAMA_API_KEY = "";
      };
      environment.variables = {
        # OLLAMA_LLM_LIBRARY = "cuda_v12";
      };
    }
