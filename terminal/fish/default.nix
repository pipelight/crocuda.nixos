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
    mkIf cfg.shell.fish.enable {
      programs.fish.enable = true;

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
        atuin
        zoxide
        ripgrep

        # find file
        # fzf
        skim
        fd

        ## Fish Shell dependencies
        starship
        fish

        grc # Recolorize commands
        eza # Ls replacement
        htop # Process management
        bat # Display file
      ];
    }
