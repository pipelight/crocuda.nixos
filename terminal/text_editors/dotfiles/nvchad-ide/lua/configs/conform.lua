local options = {

  -- Add formatters that are not handled by conform.nvim
  formatters = {
    hclfmt = {
      command = "hclfmt",
    },
  },

  -- Prettier recommandations:
  -- Install latest prettier outside of nix
  -- with: bun install -g prettier
  -- then add sepecfic lang support:
  --  - bun add -g @prettier/plugin-pug

  formatters_by_ft = {
    lua = { "stylua" },

    markdown = { "prettier", "prettierd" },

    css = { "prettier", "prettierd" },
    pug = { "prettier", "prettierd" },
    html = { "prettier", "prettierd" },
    javascript = { "prettier", "prettierd" },
    typescript = { "prettier", "prettierd" },

    typescriptreact = { "prettier", "prettierd" },
    svelte = { "prettier", "prettierd" },
    graphql = { "prettier", "prettierd" },

    toml = { "taplo" },
    yaml = { "prettier", "prettierd" },
    json = { "prettier", "prettierd" },

    python = { "black" },

    -- rust = { "rust-fmt" },
    go = { "prettier", "prettierd" },
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
