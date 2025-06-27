{
  config,
  cfg,
  pkgs,
  pkgs-unstable,
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
        # iniContent.gpg.format = lib.mkDefault "ssh";
        iniContent.gpg.format = lib.mkForce "ssh";
        extraConfig = {
          commit.template = "~/.config/git/conventional_commit_message";
          core = {
            editor = "nvim -u ~/.config/nvchad/init.lua";
          };
          # gpg.format = lib.mkDefault "ssh";
          # Sign all commits using ssh key
          # commit.gpgsign = true;
          # gpg.format = "ssh";
        };
      };
      jujutsu = {
        enable = true;
        package = pkgs-unstable.jujutsu;
        settings = {
          git = {
            auto-local-bookmark = true;
          };
          ui = {
            editor = "nvim -u ~/.config/nvchad/init.lua";
            diff-editor = ["nvim" "-u" "~/.config/nvchad/init.lua" "-c" "DiffEditor $left $right $output"];
            # pager = ["nvim" "-u" "~/.config/nvchad/init.lua" "-c" "DiffEditor $left $right $output"];
            pager = "less";
            paginate = "never";
          };
          aliases = {
            # Short history
            l = ["log" "--revisions" "root()..@" "--limit" "6"];
            ll = ["log" "--limit" "12"];
            diffshow = ["nvim" "-u" "~/.config/nvchad/init.lua" "-c" "DiffViewOpen"];

            # Git wrapped commands
            push = ["git" "push"];
            fetch = ["git" "fetch"];
            pull = ["git" "pull"];
          };
          # signing = {
          #   sign-all = true;
          #   bakend = "ssh";
          #   key = "~/.ssh/id_ed25519_signing";
          #   backends.ssh.allowed-signers = "~/.ssh/allowed-signers";
          # };
          templates = {
            draft_commit_description = let
              hint = builtins.readFile ./dotfiles/conventional_change_message;
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
