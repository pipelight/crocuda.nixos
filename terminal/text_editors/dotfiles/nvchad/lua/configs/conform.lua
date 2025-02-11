local options = {

  -- Add formatters that are not handled by conform.nvim
  formatters = {
    hclfmt = {
      command = "hclfmt",
    },
  },

  formatters_by_ft = {
    lua = { "stylua" },

    markdown = { "prettier" },

    css = { "prettier" },
    pug = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },

    typescriptreact = { "prettier" },
    svelte = { "prettier" },
    graphql = { "prettier" },

    toml = { "taplo" },
    yaml = { "prettier" },
    json = { "prettier" },

    python = { "black" },

    -- rust = { "rust-fmt" },
    go = { "prettier" },
    nix = { "alejandra" },
    zig = { "zigfmt" },
    hcl = { "hclfmt" },
    sql = { "sqlfluff" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)
