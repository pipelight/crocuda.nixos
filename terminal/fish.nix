{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.file = {
    ".config/atuin".source = dotfiles/atuin;
    ".config/pacman/makepkg.conf".source = dotfiles/pacman/makepkg.conf;
    ".config/neofetch".source = dotfiles/neofetch;
    # Shell aliases
    ".aliases".source = dotfiles/fish/.aliases;
    # Nushell
    ".config/nushell/config.nu".source = dotfiles/nushell/config.nu;
    ".config/nushell/env.nu".source = dotfiles/nushell/env.nu;
    # Fish
    ".config/fish/colemak.fish".source = dotfiles/fish/colemak.fish;
    ".config/fish/extra_config.fish".source = dotfiles/fish/config.fish;
  };

  home.packages = with pkgs; [
    # Auto configure fish tide prompt
    (pkgs.writeShellScriptBin "fish_tide_auto" ''
      fish -c 'tide configure --auto \
        --style=Classic \
        --prompt_colors="True color" \
        --classic_prompt_color=Dark \
        --show_time=No \
        --classic_prompt_separators=Angled \
        --powerline_prompt_heads=Sharp \
        --powerline_prompt_tails=Round \
        --powerline_prompt_style="Two lines, character and frame" \
        --prompt_connection=Dotted \
        --powerline_right_prompt_frame=No \
        --prompt_connection_andor_frame_color=Darkest \
        --prompt_spacing=Compact \
        --icons="Few icons" \
        --transient=Yes'
    '')
  ];

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
            hash = "sha256-5cO5Ey7z7KMF3vqQhIbYip5JR6YiS2I9VPRd6BOmeC8=";
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
          name = "tide";
          src = tide.src;
        }
        {
          name = "git";
          src = plugin-git.src;
        }
      ];
      interactiveShellInit = ''
        source ~/.config/fish/colemak.fish
        source ~/.config/fish/extra_config.fish
      '';
    };
  };
}
