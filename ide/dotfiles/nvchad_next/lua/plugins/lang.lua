return {
  {
    "elkowar/yuck.vim",
    lazy = false,
  },
  {
    "isobit/vim-caddyfile",
    lazy = true,
  },
  {
    "jvirtanen/vim-hcl",
    lazy = false,
  },
  {
    "https://github.com/apple/pkl-neovim",
    lazy = true,
    event = {
      "BufReadPre *.pkl",
      "BufReadPre *.pcf",
      "BufReadPre PklProject",
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    build = function()
      vim.cmd "TSInstall! pkl"
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
}
