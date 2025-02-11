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

  ------------------------------
  -- NvChad Ui / NvUi
  "nvim-lua/plenary.nvim",
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvchad/ui",
    config = function()
      require "nvchad"
    end,
  },
  {
    "nvchad/base46",
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
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

  -- Session manager
  -- https://github.com/NvChad/NvChad/issues/646
  {
    "rmagatti/auto-session",
    cmd = { "SaveSession", "RestoreSession" },
    config = function()
      -- Autosession compat
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      -- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winpos,localoptions"

      require("auto-session").setup {
        log_level = "warn",
        -- auto_session_enable_last_session = true,
        root_dir = vim.fn.stdpath "data" .. "/sessions",
        -- auto_session_enabled = true,
        -- auto_save_enabled = true,
        -- auto_restore_enabled = true,
        auto_session_suppress_dirs = nil,
        pre_save_cmds = { "tabdo NvimTreeClose" },
        post_restore_cmds = { "tabdo NvimTreeRefresh" },
      }
    end,
    lazy = false,
  },

  -- Smooth navigation experience
  --
  {
    "psliwka/vim-smoothie",
    lazy = false,
  },
  {
    "echasnovski/mini.animate",
    lazy = false,
    config = function()
      local animate = require "mini.animate"
      local is_many_wins = function(sizes_from, sizes_to)
        return vim.tbl_count(sizes_from) >= 2
      end
      require("mini.animate").setup {
        open = {
          enable = false,
        },
        close = {
          enable = false,
        },
        scroll = {
          enable = false,
        },
        cursor = {
          enable = false,
        },
        resize = {
          enable = true,
          timing = animate.gen_timing.linear { easing = "out", duration = 14, unit = "total" },
          subresize = animate.gen_subresize.equal { predicate = is_many_wins },
        },
      }
    end,
  },
  -- {
  --   "brenoprata10/nvim-highlight-colors",
  --   lazy = true,
  --   config = function()
  --     vim.opt.termguicolors = true
  --     require("nvim-highlight-colors").setup {
  --       ---Highlight hex colors, e.g. '#FFFFFF'
  --       enable_hex = true,
  --       ---Highlight short hex colors e.g. '#fff'
  --       enable_short_hex = true,
  --       ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
  --       enable_rgb = true,
  --       ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
  --       enable_hsl = true,
  --       ---Highlight CSS variables, e.g. 'var(--testing-color)'
  --       enable_var_usage = true,
  --       ---Highlight named colors, e.g. 'green'
  --       enable_named_colors = true,
  --       ---Highlight tailwind colors, e.g. 'bg-blue-500'
  --       enable_tailwind = false,
  --     }
  --   end,
  -- },

  -------------------------------
  -- Non optimal setup
  -- {
  -- "mrjones2015/smart-splits.nvim",
  -- lazy = false,
  -- },
  {
    "nvim-focus/focus.nvim",
    lazy = false,
    -- event = "VeryLazy",
    opts = require("configs.focus").options,
    config = function()
      return require("focus").setup(require("configs.focus").options)
    end,
  },
}
