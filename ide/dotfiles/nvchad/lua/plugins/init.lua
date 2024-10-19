return {

  -- LSP
  --
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
    lazy = false,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      dofile(vim.g.base46_cache .. "treesitter")
      require "configs.treesitter"
    end,
    lazy = false,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require "configs.comment"
    end,
    lazy = false,
  },
  { "echasnovski/mini.ai", version = false },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
  },

  -- Tests
  --
  {
    "vim-test/vim-test",
    config = function()
      vim.g["test#preserve_screen"] = 0
      vim.g["test#neovim#start_normal"] = 1
      vim.g["test#neovim#term_position"] = "vert"
      vim.g["test#strategy"] = "toggleterm"
      vim.g["test#rust#cargotest#test_options"] = "-- --test-threads 1 --nocapture"
      vim.g["test#javascript#denotest#options"] = "--allow-all"
    end,
    lazy = false,
  },
  -- toggleterm vim-test dependency
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup {
        size = function(term)
          return vim.o.columns * 0.32
        end,
        direction = "vertical",
        persist_size = true,
        hide_numbers = true,
        close_on_exit = false,
        shade_terminals = true,
        shading_factor = 75,
        terminal_mappings = true,
        shell = "fish",
      }
    end,
    lazy = false,
  },
  -- {
  -- 	"williamboman/mason.nvim",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"lua-language-server", "stylua",
  -- 			"html-lsp", "css-lsp" , "prettier"
  -- 		},
  -- 	},
  -- },
  --
}
