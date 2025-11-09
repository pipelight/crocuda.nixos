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

      ## Fish
      ".config/fish/conf.d/colemak.fish".source = dotfiles/fish/colemak.fish;

      ".config/fish/conf.d/interactive.fish".source = dotfiles/fish/interactive.fish;

      ".config/fish/conf.d/title.fish".source = dotfiles/fish/title.fish;
      ".config/fish/conf.d/abbrev.fish".source = dotfiles/fish/abbrev.fish;

      # siketyan/ghr plugin and completion
      ".config/fish/conf.d/ghr.fish".text = ''
        ghr shell fish | source
        ghr shell fish --completion | source

        function gcd;
          ghr cd $(ghr search "$argv" | head -n 1)
        end
        function gnv;
          ghr open $(ghr search "$argv" | head -n 1) nvid
        end
      '';
      ".ghr/ghr.toml".text = inputs.nix-std.lib.serde.toTOML {
        applications.nvid = {
          cmd = "${pkgs.neovide}/bin/neovide";
          args = ["%p"];
        };
      };
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
