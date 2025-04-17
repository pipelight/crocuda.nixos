return {

  -- LSP
  --
  {
    "neovim/nvim-lspconfig",
    config = function()
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
  { "echasnovski/mini.ai", version = false, lazy = false },
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
