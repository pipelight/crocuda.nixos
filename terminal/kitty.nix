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
      CONFIG_PATHS=".config/fish .config/atuin .aliases"

      # Ensure output path
      sudo rm -rf $OUTDIR
      mkdir -p $OUTDIR

      for DIR in $CONFIG_PATHS
      do
        cp --recursive --dereference \
        $HOME/$DIR \
        $OUTDIR
      done

      fish_clean_config
    '';
    # A script to remove fish nix store files sourcing.
    fish_clean_config = pkgs.writeShellScriptBin "fish_clean_config" ''
      #!/usr/bin/env sh
      set -x

      CONFIG_DIR="$HOME/.config.deref"

      sed -i '/\/nix\/store/d' $CONFIG_DIR/fish/config.fish
    '';
  in
    with pkgs; [
      zellij

      kitty_ssh_deref
      fish_clean_config
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
