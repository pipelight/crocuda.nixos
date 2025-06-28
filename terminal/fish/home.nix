{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf cfg.terminal.shell.fish.enable {
    home.file = {
      # Prompt
      ".config/starship.toml".source = dotfiles/starship.toml;

      # Atuin
      ".config/atuin".source = dotfiles/atuin;

      # Shell aliases
      ".aliases".source = dotfiles/fish/.aliases;

      # Nushell
      ".config/nushell/config.nu".source = dotfiles/nushell/config.nu;
      ".config/nushell/env.nu".source = dotfiles/nushell/env.nu;

      # Fish
      ".config/fish/conf.d/colemak.fish".source = dotfiles/fish/colemak.fish;

      ".config/fish/conf.d/interactive.fish".source = dotfiles/fish/interactive.fish;

      ".config/fish/conf.d/title.fish".source = dotfiles/fish/title.fish;
      ".config/fish/conf.d/abbrev.fish".source = dotfiles/fish/abbrev.fish;
      # Completion
      ".config/fish/completions/ghr.fish".source = dotfiles/fish/completions/ghr.fish;
    };

    # Shell
    programs = {
      fish = rec {
        enable = true;
        interactiveShellInit = ''
          source ~/.aliases
          source ~/.config/fish/conf.d/*
        '';
        shellInit = ''
          source ~/.aliases
        '';
        plugins = with pkgs.fishPlugins; [
          {
            name = "grc";
            src = grc.src;
          }
          {
            name = "abbrev-tips";
            src = pkgs.fetchFromGitHub {
              owner = "gazorby";
              repo = "fish-abbreviation-tips";
              rev = "master";
              hash = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
            };
          }
        ];
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      atuin = {
        enable = true;
        enableFishIntegration = true;
      };
      skim = {
        enable = true;
        enableFishIntegration = true;
      };
      pay-respects = {
        enable = false;
      };
    };
  }
