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

  -- Zig
  "zls",

  --sql
  "sqls",

  -- Web / Vue
  "pug",
  "html",
  "cssls",
  "tailwindcss",
}

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- lspconfig.eslint.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
--   cmd = { "eslint" },
-- }

-- support for vue
lspconfig.volar.setup {
  cmd = { "bun", "run", "vue-language-server", "--stdio" },
  init_options = {
    vue = {
      hybridMode = true,
    },
  },
  root_dir = lspconfig.util.root_pattern("vite.config.ts", "vitest.config.ts"),
}

lspconfig.ts_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "bun", "run", "typescript-language-server", "--stdio" },
  init_options = {
    plugins = {
      {
        -- Before, install in bun global dir:
        -- bun install -g @vue/typescript-plugin && bun update -g
        name = "@vue/typescript-plugin",
        location = "",
        -- location = "$HOME/.bun/install/global/vue-language-server",
        languages = { "vue" },
      },
      {
        -- Before, install in bun global dir:
        -- bun install -g @vue/language-plugin-pug && bun update -g
        name = "@vue/language-plugin-pug",
        location = "",
        -- location = "$HOME/.bun/install/global/vue-language-server",
        languages = { "vue" },
      },
    },
  },
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
  },
}

lspconfig.denols.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("deno.lock", "mod.ts"),
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
