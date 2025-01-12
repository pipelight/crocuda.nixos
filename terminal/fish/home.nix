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
      ".config/atuin".source = dotfiles/atuin;
      # Shell aliases
      ".aliases".source = dotfiles/fish/.aliases;

      # Nushell
      ".config/nushell/config.nu".source = dotfiles/nushell/config.nu;
      ".config/nushell/env.nu".source = dotfiles/nushell/env.nu;

      # Fish
      ".config/fish/colemak.fish".source = dotfiles/fish/colemak.fish;
      ".config/fish/extra_config.fish".source = dotfiles/fish/config.fish;
      # Prompt
      ".config/starship.toml".source = dotfiles/starship.toml;
    };

    # Shell
    programs = {
      fish = {
        enable = true;
        plugins = with pkgs.fishPlugins; [
          {
            name = "fzf";
            src = pkgs.fetchFromGitHub {
              owner = "PatrickF1";
              repo = "fzf.fish";
              rev = "main";
              hash = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
              # hash = "sha256-5cO5Ey7z7KMF3vqQhIbYip5JR6YiS2I9VPRd6BOmeC8="; #old
            };
          }
          {
            name = "abrev-tips";
            src = pkgs.fetchFromGitHub {
              owner = "gazorby";
              repo = "fish-abbreviation-tips";
              rev = "master";
              hash = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
            };
          }
          {
            name = "grc";
            src = grc.src;
          }
          {
            name = "git";
            src = plugin-git.src;
          }
        ];
        interactiveShellInit = mkMerge [
          ''
            source ~/.config/fish/colemak.fish
            source ~/.config/fish/extra_config.fish
          ''
        ];
      };
    };
  }
