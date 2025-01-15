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
          core = {
            editor = "nvim -u ~/.config/nvchad/init.lua";
          };
          # Sign all commits using ssh key
          # commit.gpgsign = true;
          # gpg.format = "ssh";
        };
      };
      jujutsu = {
        enable = true;
        settings = {
          git = {
            auto-local-bookmark = true;
          };
          ui = {
            editor = "nvim -u ~/.config/nvchad/init.lua";
            # pager = "nvim -u ~/.config/nvim/init.lua";
            paginate = "never";
            pager = "less";
          };
          aliases = {
            l = ["log" "--revisions" "root()..@" "--limit" "6"];
            ll = ["log" "--revisions" "root()..@" "--limit" "12"];
            push = ["git" "push"];
            fetch = ["git" "fetch"];
          };
          # signing = {
          #   sign-all = true;
          #   bakend = "ssh";
          #   key = "~/.ssh/id_ed25519_signing";
          #   backends.ssh.allowed-signers = "~/.ssh/allowed-signers";
          # };
          templates = {
            draft_commit_description = let
              hint = builtins.replaceStrings ["#"] ["JJ:"] (builtins.readFile ./dotfiles/conventional_commit_message);
            in ''
              concat(
                description,
                "${hint}",
                surround(
                  "\nJJ: This commit contains the following changes:\n", "",
                  indent("JJ:     ", diff.stat(72))
                ),
                surround(
                  "\nJJ: This commit contains the following changes:\n", "",
                  indent("JJ:     ", diff.summary())
                ),
              )
            '';
          };
        };
      };
    };
  }