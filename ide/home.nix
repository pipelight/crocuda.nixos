{
  config,
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

  home.file = let
    # Fetch NvChad files for later symlink.
    nvchad = pkgs.fetchFromGitHub {
      owner = "NvChad";
      repo = "NvChad";
      rev = "refs/heads/v2.0";
      hash = "sha256-SG3pJIkFu/AhNqh07F+Ab0VgOBF2VxdkrxZwk7lepyg=";
    };
  in {
    # Terminal multiplexer
    ".config/zellij".source = dotfiles/zellij;

    # NvChad minimal files
    ".config/nvim/lua/core".source = nvchad + "/lua/core";
    ".config/nvim/lua/plugins".source = nvchad + "/lua/plugins";
    ".config/nvim/init.lua".source = nvchad + "/init.lua";
    ".config/nvim/lua/custom".source = dotfiles/nvchad/custom;

    ".vimrc".source = dotfiles/.vimrc;
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
