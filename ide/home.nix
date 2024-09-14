{
  config,
  cfg,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}: {
  # LSP support
  # Override Nxpkgs nodejs version from lts to latest
  nixpkgs.overlays = [
    (
      final: prev: {
        nodejs = prev.nodejs_latest;
      }
    )
  ];

  # Force default editor to neovim
  home.sessionVariables.EDITOR = lib.mkForce "nvim";

  home.file = {
    # Notifications
    ".config/dunst/dunstrc".source = dotfiles/dunstrc;

    # Terminal multiplexer
    ".config/zellij".source = dotfiles/zellij;

    # NvChad
    ".config/nvim/lua".source = dotfiles/nvchad/lua;
    ".config/nvim/init.lua".source = dotfiles/nvchad/init.lua;

    # Lock plugin versions
    # :Lazy sync on first boot
    # ".config/nvim/lazy-lock.json".source = dotfiles/nvchad/lazy-lock.json;

    # Vim colemak conf
    ".vimrc".source = dotfiles/.vimrc;
  };

  home.sessionVariables = {
    NVIM_APPNAME = with lib;
      mkMerge [
        (mkIf (cfg.keyboard.layout == "colemak-dh") "nvim")
        # (mkIf (cfg.keyboard.layout == "colemak-dh") "nvchad-colemak-dh")
        (mkIf (cfg.keyboard.layout == "azerty") "nvchad-azerty")
        (mkIf (cfg.keyboard.layout == "qwerty") "nvchad-qwerty")
      ];
  };

  home.packages = with pkgs; [
    pkgs-unstable.neovim
    ## Lsp lint/formatting tools
    tree-sitter
    # Node LSP servers
    prettierd
    tailwindcss
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.typescript-language-server
    # nodePackages.eslint
    nodePackages.jsonlint
    nodePackages.vue-language-server
    # nodePackages.vscode-css-languageserver-bin
    nodePackages.vscode-langservers-extracted
    nodePackages."@tailwindcss/language-server"
    # Lua
    lua-language-server
    stylua
    # Nix
    nil
    statix
    alejandra
    # Toml and friends
    taplo
    # Yaml
    yaml-language-server
    yamllint
    stylelint
    # Hcl
    hclfmt
    # Markdown
    marksman
    # Go
    gopls
    golangci-lint
    # Python
    python3Packages.python-lsp-server
    ruff
    black
    # Zig
    zls
    # Sql
    sqls
  ];
}
