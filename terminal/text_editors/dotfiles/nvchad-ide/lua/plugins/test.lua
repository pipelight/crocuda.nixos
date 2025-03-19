return {
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
      -- Nix
      -- vim.g["test#custom_runners#nix"] = "nix-unit"
      -- local nix_test = require "configs.test"
      -- vim.g["test#nix#nix-unit#test_file"] = nix_test.test_file
      -- vim.g["test#nix#nix-unit#build_position"] = nix_test.build_position
      -- vim.g["test#nix#nix-unit#build_args"] = nix_test.build_args
      -- vim.g["test#nix#nix-unit#build_args"] = nix_test.executable
    end,
  },
  -- toggleterm vim-test dependency
  {
    "akinsho/toggleterm.nvim",
    lazy = false,
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
  },
  {
    "nvim-neotest/neotest",
    lazy = false,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Lang
      "rouge8/neotest-rust",
      "markemmons/neotest-deno",
      "rcasia/neotest-bash",
      "marilari88/neotest-vitest",
    },
  },
}
