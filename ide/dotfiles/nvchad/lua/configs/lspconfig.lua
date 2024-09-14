local lspconfig = require "nvchad.configs.lspconfig"
local on_attach = lspconfig.on_attach
local on_init = lspconfig.on_init
local capabilities = lspconfig.capabilities

local lspconfig = require "lspconfig"

local servers = {
  -- Lua
  "lua_ls",

  -- Web
  "html",
  "cssls",

  -- "tailwindcss",
  -- "tsserver",

  -- Nix
  "nil_ls",

  -- Markup
  "taplo",
  "yamlls",
  "marksman",

  -- Go
  "gopls",

  -- Deno
  "denols",

  -- Python
  "pylsp",

  --- Moved down below
  -- Rust
  -- "rust_analyzer",

  -- Zig
  "zls",

  --sql
  "sqls",

  -- Vuels
  "vuels",
}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

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
