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
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {

        -- usual
        "vim",
        "vimdoc",
        "bash",
        "rust",
        "go",
        "lua",
        "nix",

        -- markup
        "toml",
        "yaml",
        "jq",

        -- web
        "vue",
        "javascript",
        "typescript",
        "css",
        "scss",
        "pug",
        "html",

        "yuck",
      },
    },
  },

  -- Tests
  --
  {
    "pipelight/vim-test",
    config = function()
      vim.g["test#preserve_screen"] = 0
      vim.g["test#neovim#start_normal"] = 1
      vim.g["test#neovim#term_position"] = "vert"
      vim.g["test#strategy"] = "toggleterm"
      vim.g["test#rust#cargotest#test_options"] = "-- --test-threads 1 --nocapture"
      vim.g["test#javascript#denotest#test_options"] = "--allow-all"
    end,
    lazy = false,
  },
  -- vim-test dependencie
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
        hide_numbers = false,
        close_on_exit = false,
        shade_terminals = true,
        shading_factor = "-15",
        terminal_mappings = false,
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
