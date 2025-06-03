return {
  {
    "sindrets/diffview.nvim",
    lazy = false,
  },
  {
    "julienvincent/hunk.nvim",
    cmd = { "DiffEditor" },
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("hunk").setup {
        keys = {
          global = {
            quit = { "q" },
            accept = { "<leader><Cr>" },
            focus_tree = { "<leader>e" },
          },

          tree = {
            expand_node = { "i", "<Right>" },
            collapse_node = { "m", "<Left>" },
            open_file = { "<Cr>" },
            toggle_file = { "a" },
          },

          diff = {
            toggle_line = { "a" },
            toggle_hunk = { "A" },
            prev_hunk = { "[h" },
            next_hunk = { "]h" },

            -- Jump between the left and right diff view
            toggle_focus = { "<Tab>" },
          },
        },

        ui = {
          tree = {
            -- Mode can either be `nested` or `flat`
            mode = "nested",
            width = 35,
          },
          --- Can be either `vertical` or `horizontal`
          layout = "vertical",
        },
      }
    end,
  },
}
