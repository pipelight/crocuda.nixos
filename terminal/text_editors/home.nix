{
  config,
  cfg,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
with lib;
  mkIf (cfg.terminal.editors.neovim.enable
    || cfg.terminal.editors.nvchad.enable
    || cfg.terminal.editors.nvchad-ide.enable)
  {
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
      EDITOR = mkMerge [
        (mkIf (cfg.terminal.editors.nvchad-ide.enable) "nvim -u ~/.config/nvchad/init.lua")
        (mkIf (cfg.terminal.editors.nvchad.enable) "nvim -u ~/.config/nvchad/init.lua")
        (mkDefault "nvim")
      ];
      MANPAGER = mkMerge [
        (mkIf (cfg.terminal.editors.nvchad-ide.enable) "nvim -u ~/.config/nvchad/init.lua -c 'Man!' -o -")
        (mkIf (cfg.terminal.editors.nvchad.enable) "nvim -u ~/.config/nvchad/init.lua -c 'Man!' -o -")
        (mkDefault "nvim +Man!")
      ];
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
      # Less
      ".lesskey".source = dotfiles/.lesskey;

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
        (mkIf (cfg.terminal.editors.neovim.enable) [neovim])
        (mkIf (cfg.terminal.editors.nvchad.enable)
          [
            neovim
            ## Lsp lint/formatting tools
            tree-sitter
          ])
        (
          mkIf (cfg.terminal.editors.nvchad-ide.enable)
          [
            treefmt2
            git-cliff

            neovim

            ## Lsp lint/formatting tools
            tree-sitter

            # Grammar
            ltex-ls
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
            # Kdl
            kdlfmt
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

            ##############################
            # Web
            prettierd
            # nodePackages.prettier
            # nodePackages.typescript
            typescript
            # nodePackages.typescript-language-server
            typescript-language-server

            # nodePackages.eslint
            eslint
            nodePackages.jsonlint

            vue-language-server
          ]
        )
      ];
  }
