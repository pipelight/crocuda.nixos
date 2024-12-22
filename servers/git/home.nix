{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.file = {
    ".config/git/conventional_commit_message".source = ./dotfiles/conventional_commit_message;
    # ".config/git/conventional_commit_message".source = ./dotfiles/.gitmessage;
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
        template = {
          draft_commit_descritption =
            builtins.readFile ./dotfiles/conventional_commit_message
            # builtins.readFile ./dotfiles/.gitmessage
            + ''
              concat(
                description,
                surround(
                  "\nJJ: This commit contains the following changes:\n", "",
                  indent("JJ:     ", diff.stat(72)),
                ),
              )
            '';
        };
      };
    };
  };
}
