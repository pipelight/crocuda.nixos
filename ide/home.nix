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
    # NvChad
    # :Lazy sync on first boot
    ".config/nvchad-colemak-dh/lua".source = dotfiles/nvchad_next/lua;
    ".config/nvchad-colemak-dh/init.lua".source = dotfiles/nvchad_next/init.lua;

    # Deprecated
    # NvChad colemak-dh mod
    ".config/nvchad/lua/core".source = nvchad + "/lua/core";
    ".config/nvchad/lua/plugins".source = nvchad + "/lua/plugins";
    ".config/nvchad/init.lua".source = nvchad + "/init.lua";
    ".config/nvchad/lua/custom".source = dotfiles/nvchad/custom;
    # NvChad azerty mod
    ".config/nvchad-azerty/lua/core".source = nvchad + "/lua/core";
    ".config/nvchad-azerty/lua/plugins".source = nvchad + "/lua/plugins";
    ".config/nvchad-azerty/init.lua".source = nvchad + "/init.lua";
    ".config/nvchad-azerty/lua/custom".source = dotfiles/nvchad/custom;

    ".vimrc".source = dotfiles/.vimrc;
  };

  home.sessionVariables = {
    NVIM_APPNAME = with lib;
      mkMerge [
        (mkIf (cfg.keyboard.layout == "colemak-dh") "nvchad-colemak-dh")
        (mkIf (cfg.keyboard.layout == "azerty") "nvchad-azerty")
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
