{
  config,
  cfg,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
  mkIf cfg.terminal.git.conventional.enable {
    home.file = {
      ".config/git/conventional_commit_message".source = ./dotfiles/conventional_commit_message;
    };

    programs = {
      # Versionning

      git = {
        enable = true;
        extraConfig = {
          commit.template = "~/.config/git/conventional_commit_message";
          # Sign all commits using ssh key
          # commit.gpgsign = true;
          # gpg.format = "ssh";
        };
      };
      jujutsu = {
        enable = true;
        settings = {
          ui = {
            editor = "nvim -u ~/.config/nvchad/init.lua";
            # pager = "nvim -u ~/.config/nvim/init.lua";
            pager = "less";
          };
          templates = {
            draft_commit_descritption = let
              hint = builtins.replaceStrings ["#"] ["JJ:"] (builtins.readFile ./dotfiles/conventional_commit_message);
            in ''
              concat(
                description,
                surround(
                  "\nJJ: This commit contains the following changes:\n", "",
                  indent("JJ:     ", diff.stat(72)),
                ),
                surround(${hint})
              )
            '';
          };
        };
      };
    };
  }
