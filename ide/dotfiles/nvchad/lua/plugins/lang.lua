return {
  {
    "elkowar/yuck.vim",
    lazy = true,
  },
  {
    "isobit/vim-caddyfile",
    lazy = true,
  },
  {
    "jvirtanen/vim-hcl",
    lazy = true,
  },
  {
    "nfnty/vim-nftables",
    lazy = false,
  },
  -- {
  --   "https://github.com/apple/pkl-neovim",
  --   lazy = true,
  --   event = {
  --     "BufReadPre *.pkl",
  --     "BufReadPre *.pcf",
  --     "BufReadPre PklProject",
  --   },
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   build = function()
  --     vim.cmd "TSInstall! pkl"
  --   end,
  -- },
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
    lazy = true,
  },
  -------------------------------
  -- Markdown viewer
  {
    "OXY2DEV/markview.nvim",
    lazy = true, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway
    dependencies = {
      -- You will not need this if you installed the
      -- parsers manually
      -- Or if the parsers are in your $RUNTIMEPATH
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
