local lspconfig = require "nvchad.configs.lspconfig"
local on_attach = lspconfig.on_attach
local on_init = lspconfig.on_init
local capabilities = lspconfig.capabilities

local lspconfig = require "lspconfig"

local servers = {
  -- Lua
  "lua_ls",

  -- Nix
  "nil_ls",

  -- Markup
  "taplo",
  "yamlls",
  "marksman",

  -- Go
  "gopls",

  -- Python
  "pylsp",

  --- Moved down below
  -- Rust
  -- "rust_analyzer",

  -- Zig
  "zls",

  --sql
  "sqls",

  -- Web / Vue
  "html",
  "cssls",
  "tailwindcss",

  "ts_ls",

  -- Deno
  "denols",
}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- support for vue
lspconfig.eslint.setup {
  cmd = { "eslint" },
}
lspconfig.volar.setup {
  cmd = { "vue-language-server", "--stdio" },
  -- takeover mode
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "json",
  },
}

lspconfig.ts_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  init_options = {
    plugins = { -- I think this was my breakthrough that made it work
      -- {
      --   -- Before, install in bun global dir:
      --   -- bun install -g @vue/typescript-plugin && bun update -g
      --   name = "@vue/typescript-plugin",
      --   location = "$HOME/.bun/global/node_modules/@vue/typescript-plugin",
      --   languages = { "vue", "typescript", "javascript" },
      -- },
      {
        -- Before, install in bun global dir:
        -- bun install -g @vue/typescript-plugin && bun update -g
        name = "@vue/typescript-plugin",
        -- location = "$HOME/.bun/global/node_modules/@vue/typescript-plugin",
        location = "/usr/bin/env vue-language-server",
        -- location = "", -- preffer dynamic location for nix compat
        -- languages = { "vue", "typescript", "javascript" },
        languages = { "vue" },
      },
    },
  },
  filetypes = {
    "typescript",
    "javascript",
    -- "vue",
    "javascriptreact",
    "typescriptreact",
  },
}

-- support for rust
lspconfig.rust_analyzer.setup {
  settings = {
    -- Autoreload cargo at start for better completion -> avoid typing ":CargoReload" every time
    -- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
    ["rust-analyzer.rust-analyzer.workspace.discoverConfig"] = {
      ["command"] = {
        "rust-project",
        "develop-json",
      },
      ["progressLabel"] = "rust-analyzer",
      ["filesToWatch"] = {
        "BUCK",
      },
    },
  },
}

-- Diagnostic styling
--
-- Enable diagnostic floating window on insert mode
local function diagnostic_floating_window()
  vim.diagnostic.open_float(nil, { focus = false })
end
vim.api.nvim_create_autocmd("CursorHoldI", { callback = diagnostic_floating_window })

-- Toggle diagnostic virtual text
vim.diagnostic.config {
  virtual_text = false,
}
