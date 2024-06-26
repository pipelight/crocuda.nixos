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
    mkIf cfg.llm.oatmeal.enable {
      nixpkgs.overlays = [
        # (
        #   final: prev: {
        #     ollamagpu = pkgs.ollama.override {
        #       llama-cpp = pkgs.llama-cpp.override {
        #         cudaSupport = true;
        #         # openblasSupport = false;
        #       };
        #     };
        #   }
        # )
      ];
      environment.systemPackages = with pkgs; [
        cachix
        # ollamagpu
        ollama
        #cudatoolkit
        #cudatoolkit_11
        freeglut
        # Python dependencies managment
        poetry
        config.nur.repos.dustinblackman.oatmeal
      ];

      users.users."llm" = {
        isNormalUser = true;
        home = "/home/llm";
      };

      systemd.services."ollama" = {
        enable = true;
        after = ["network.target"];
        description = "Ollama service";
        documentation = ["https://github.com/jmorganca/ollama"];
        serviceConfig = {
          User = "llm";
          Group = "users";
          WorkingDirectory = "~";
          ExecStart = ''
            ${pkgs.ollama}/bin/ollama serve
          '';
        };
        wantedBy = ["multi-user.target"];
      };
    }
