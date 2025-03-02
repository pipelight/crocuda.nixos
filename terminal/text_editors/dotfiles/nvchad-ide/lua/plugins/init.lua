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
    ---@type Flash.Config
    opts = {
      -- colemak-dh
      labels = "arstgoienmqwfpbyuljxcdvzhk",
      search = {
        forward = false,
        backward = false,
        multi_window = false,
        continue = false,
        jump_labels = true,
      },
      autojump = true,
      modes = {
        search = {
          enabled = true,
        },
        char = {
          enabled = false,
        },
      },
    },
    keys = {
      -- Disable defaults
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "o", "x" }, false },
      {
        "f",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump to pattern",
      },
    },
  },

  -- Tests
  --
  {
    "vim-test/vim-test",
    event = "VeryLazy",
    config = function()
      vim.g["test#preserve_screen"] = 0
      vim.g["test#neovim#start_normal"] = 1
      vim.g["test#neovim#reopen_window"] = 1
      vim.g["test#neovim#term_position"] = "vert"
      vim.g["test#strategy"] = "toggleterm"
      vim.g["test#rust#cargotest#test_options"] = "-- --test-threads 1 --nocapture"
      vim.g["test#javascript#denotest#options"] = "--allow-all"
      -- Set vitest priority when installed
      vim.g["test#javascript#runner"] = "vitest"
    end,
  },
  -- toggleterm vim-test dependency
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup {
        size = function(term)
          return vim.o.columns * 0.4
        end,
        direction = "vertical",
        persist_size = false,
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
