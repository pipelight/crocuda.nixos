{
  config,
  pkgs,
  lib,
  utils,
  inputs,
  ...
}: let
  user = ["anon"];
in {
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
    (
      final: prev: {
        # Add browsh latest vim-mode
        browsh-vim = pkgs.browsh.overrideAttrs (oldAttrs: rec {
          src = prev.fetchFromGitHub {
            owner = "browsh-org";
            repo = "browsh";
            rev = "refs/heads/vim-mode-exprimental";
            hash = "sha256-KbBVcNuERBL94LuRx872zpjQTzR6c5GalsBoNR52SuQ=";
          };
        });
      }
    )
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

  systemd.services."ollama" = {
    enable = true;
    after = ["network.target"];
    description = "Ollama service";
    documentation = ["https://github.com/jmorganca/ollama"];
    serviceConfig = {
      User = user;
      Group = "wheel";
      WorkingDirectory = "~";
      ExecStart = ''
        ${pkgs.ollama}/bin/ollama serve
      '';
    };
    wantedBy = ["multi-user.target"];
  };
}
