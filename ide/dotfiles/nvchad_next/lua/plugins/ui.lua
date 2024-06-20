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
    "lewis6991/gitsigns.nvim",
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
      require("auto-session").setup {
        log_level = "warn",
        -- auto_session_enable_last_session = true,
        auto_session_root_dir = vim.fn.stdpath "data" .. "/sessions",
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
      require("mini.animate").setup {
        open = {
          enable = false,
        },
        close = {
          enable = false,
        },
        cursor = {
          enable = false,
        },
        scroll = {
          enable = false,
        },
        resize = {
          enable = true,
          timing = animate.gen_timing.quartic { easing = "out", duration = 14, unit = "total" },
          -- subresize = animate.gen_subresize.equal({ predicate = is_many_wins }),
        },
      }
    end,
  },
  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      local dbee = require "dbee"
      dbee.install()
    end,
    config = function()
      require "configs.dbee"
    end,
  },
  -------------------------------
  -- Non optimal setup
  {
    "nvim-focus/focus.nvim",
    config = function()
      local ignore_filetypes = { "nvim-tree", "neo-tree", "NvimTree_" }
      local ignore_buftypes = { "nofile", "prompt", "popup", "NvimTree_", "fish;#toggleterm#" }

      local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "VimEnter" }, {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
            vim.w.focus_disable = true
          else
            vim.w.focus_disable = false
          end
        end,
        desc = "Disable focus autoresize for BufType",
      })
      vim.api.nvim_create_autocmd({ "FileType", "VimEnter" }, {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
          else
            vim.b.focus_disable = false
          end
        end,
        desc = "Disable focus autoresize for FileType",
      })

      require("focus").setup {
        ui = {
          number = true,
          signcolumn = false, -- Display signcolumn in the focussed window only
        },
        autoresize = {
          enable = true,
          width = 100,
          height = 30,
          height_quickfix = 10,
        },
      }
    end,
    lazy = true,
  },
}
