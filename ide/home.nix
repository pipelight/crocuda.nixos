{
  config,
  cfg,
  pkgs,
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

  home.file = {
    # Notifications
    ".config/dunst/dunstrc".source = dotfiles/dunstrc;

    # Terminal multiplexer
    ".config/zellij".source = dotfiles/zellij;

    # NvChad
    # :Lazy sync on first boot
    ".config/nvim/lua".source = dotfiles/nvchad_next/lua;
    ".config/nvim/init.lua".source = dotfiles/nvchad_next/init.lua;

    # Vim colemak conf
    ".vimrc".source = dotfiles/.vimrc;
  };

  home.sessionVariables = {
    NVIM_APPNAME = with lib;
      mkMerge [
        (mkIf (cfg.keyboard.layout == "colemak-dh") "nvim")
        # (mkIf (cfg.keyboard.layout == "colemak-dh") "nvchad-colemak-dh")
        # (mkIf (cfg.keyboard.layout == "azerty") "nvchad-azerty")
        # (mkIf (cfg.keyboard.layout == "azerty") "nvchad-qwerty")
      ];
  };

  home.packages = with pkgs; [
    ## Lsp lint/formatting tools
    # Node LSP servers
    prettierd
    tailwindcss
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.eslint
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
    # Toml
    taplo
    yamllint
    stylelint
    # Markdown
    marksman
    # Go
    gopls
    golangci-lint
    #Python
    python3Packages.python-lsp-server
    ruff
    black
  ];
}
