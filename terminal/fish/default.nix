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
      programs.fish.enable = true;
      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };

      # Retrieve tools installed with cargo,go and bun.
      environment.sessionVariables = rec {
        # Go env
        GOPATH = "$HOME/.go";
        GOBIN = "${GOPATH}/bin";
        CGO_ENABLED = 1;
        PATH = [
          "$HOME/.cargo/bin"
          "$HOME/.bun/bin"
          "$HOME/.go/bin"
        ];
      };

      environment.systemPackages = with pkgs; [
        # Move fast in filesystem
        fzf
        fd
        atuin
        zoxide
        ripgrep
        eza

        ## Fish Shell dependencies
        starship
        fish

        # Recolorize commands
        grc

        eza

        # Process management
        htop

        # Display file
        bat
      ];
    }
