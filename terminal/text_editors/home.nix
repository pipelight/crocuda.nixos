{
  config,
  cfg,
  pkgs,
  pkgs-unstable,
  lib,
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

  ##########################
  ## Multi keyboad layout support for neovim and vim
  ## Not working for now because I don't have much time to maintain it.

  # home.sessionVariables = {
  #   NVIM_APPNAME = with lib;
  #     mkMerge [
  #       (mkIf (cfg.keyboard.layout == "colemak-dh") "nvim")
  #       (mkIf (cfg.keyboard.layout == "colemak-dh") "nvchad-colemak-dh")
  #       (mkIf (cfg.keyboard.layout == "azerty") "nvchad-azerty")
  #       (mkIf (cfg.keyboard.layout == "qwerty") "nvchad-qwerty")
  #     ];
  # };

  home.sessionVariables = with lib; {
    NVIM_APPNAME = mkMerge [
      (mkIf (cfg.terminal.editors.nvchad-ide.enable) "nvchad-ide")
      (mkIf (cfg.terminal.editors.nvchad.enable) "nvchad")
      (mkIf (cfg.terminal.editors.neovim.enable) "nvim")
      (mkDefault "nvim")
    ];
    EDITOR = mkForce "nvim";
    MANPAGER = mkForce "nvim +Man!";
  };

  home.file = {
    # Terminal multiplexer
    ".config/zellij".source = dotfiles/zellij;

    # Vim colemak conf
    ".vimrc".source = dotfiles/.vimrc;

    # NvChadIde
    ".config/nvchad-ide/lua".source = dotfiles/nvchad-ide/lua;
    ".config/nvchad-ide/init.lua".source = dotfiles/nvchad-ide/init.lua;
    # NvChad
    ".config/nvchad/lua".source = dotfiles/nvchad/lua;
    ".config/nvchad/init.lua".source = dotfiles/nvchad/init.lua;
    # Neovim
    ".config/nvim/lua".source = dotfiles/nvim/lua;
    ".config/nvim/init.lua".source = dotfiles/nvim/init.lua;

    # Lock plugin versions
    # :Lazy sync on first boot
    # ".config/nvim/lazy-lock.json".source = dotfiles/nvchad/lazy-lock.json;
  };

  home.packages = with pkgs;
  with lib;
    mkMerge [
      #############################
      ## Terminal multiplexers
      # tmux
      # zellij
      (mkIf (cfg.terminal.editors.neovim.enable) [pkgs-unstable.neovim])

      (mkIf (cfg.terminal.editors.nvchad.enable)
        [
          pkgs-unstable.neovim

          ## Lsp lint/formatting tools
          tree-sitter
        ])
      (
        mkIf (cfg.terminal.editors.nvchad-ide.enable)
        [
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
        ]
      )
    ];
}
