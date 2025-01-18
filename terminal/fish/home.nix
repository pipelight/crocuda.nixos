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
      ".config/fish/interactive.fish".source = dotfiles/fish/interactive.fish;
      ".config/fish/title.fish".source = dotfiles/fish/title.fish;
      # Prompt
      ".config/starship.toml".source = dotfiles/starship.toml;
    };

    # Shell
    programs = {
      fish = rec {
        enable = true;
        plugins = with pkgs.fishPlugins; [
          {
            name = "fzf";
            src = pkgs.fetchFromGitHub {
              owner = "PatrickF1";
              repo = "fzf.fish";
              rev = "main";
              hash = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
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
        interactiveShellInit = ''
          source ~/.aliases
          source ~/.config/fish/colemak.fish
          source ~/.config/fish/interactive.fish
          source ~/.config/fish/title.fish
        '';
        shellInit = ''
          source ~/.aliases
        '';
      };
    };
  }
