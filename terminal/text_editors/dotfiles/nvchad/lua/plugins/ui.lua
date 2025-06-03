-- Checkout https://github.com/NvChad/NvChad for up to date plugin settings

return {
  -- File managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeRefresh" },
    opts = function()
      return require("configs.nvimtree").options
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
    end,
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    ---@module 'oil'
    -- ---@type oil.SetupOpts
    config = function()
      return require("oil").setup(require("configs.oil").options)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
  },
  {
    "avm99963/vim-jjdescription",
    lazy = false,
  },
  {
    "windwp/nvim-autopairs",
    lazy = false,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = false,
  },

  -- Smooth navigation experience
  --
  {
    "psliwka/vim-smoothie",
    lazy = false,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    lazy = true,
    config = function()
      vim.opt.termguicolors = true
      require("nvim-highlight-colors").setup {
        ---Highlight hex colors, e.g. '#FFFFFF'
        enable_hex = true,
        ---Highlight short hex colors e.g. '#fff'
        enable_short_hex = true,
        ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
        enable_rgb = true,
        ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
        enable_hsl = true,
        ---Highlight CSS variables, e.g. 'var(--testing-color)'
        enable_var_usage = true,
        ---Highlight named colors, e.g. 'green'
        enable_named_colors = true,
        ---Highlight tailwind colors, e.g. 'bg-blue-500'
        enable_tailwind = false,
      }
    end,
  },
  {
    "nvim-focus/focus.nvim",
    lazy = false,
    opts = require("configs.focus").options,
    config = function()
      return require("focus").setup(require("configs.focus").options)
    end,
  },
}
