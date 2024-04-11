{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.file = {
    ".config/pacman/makepkg.conf".source = dotfiles/pacman/makepkg.conf;
    ".config/kitty/ssh.conf".source = dotfiles/kitty/ssh.conf;
  };

  home.packages = let
    # A script to derefer nix store symlink.
    # The resulting config directory can be safely copied by kitty ssh kitten.
    kitty_ssh_deref = pkgs.writeShellScriptBin "kitty_ssh_deref" ''
      #!/usr/bin/env sh
      set -x

      OUTDIR="$HOME/.config.deref/"
      CONFIG_PATHS=".config/fish .config/nvim .aliases"

      # Ensure output path
      mkdir -p $OUTDIR

      for DIR in $CONFIG_PATHS
      do
        cp --recursive --dereference \
        $HOME/$DIR \
        $OUTDIR
      done
    '';
  in
    with pkgs; [
      zellij
      kitty_ssh_deref
      # Packaging for AUR
      pacman
    ];

  # Shell
  programs = {
    # Terminal
    kitty = {
      enable = true;
      extraConfig = builtins.readFile dotfiles/kitty/kitty.conf;
      theme = "GitHub Dark Dimmed";
    };
  };
}
