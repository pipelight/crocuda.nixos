{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf config.crocuda.shell.fish.enable {
    # {
    home.file = {
      # Prompt
      ".config/starship.toml".source = dotfiles/starship.toml;

      # Process management
      # ".config/htop/htoprc".source = dotfiles/htop/htoprc;

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
      fish = {
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
