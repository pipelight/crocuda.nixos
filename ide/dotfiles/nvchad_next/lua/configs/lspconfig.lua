local nv_lspconfig = require("nvchad.configs.lspconfig")
local on_attach = nv_lspconfig.on_attach
local on_init = nv_lspconfig.on_init
local capabilities = nv_lspconfig.capabilities

local lspconfig = require "lspconfig"

local servers = {

  -- Lua
	"lua_ls",

	-- Web
	"html",
	"cssls",

	-- "tailwindcss",
  "tsserver",

	-- Nix
	"nil_ls",

	-- Markup
	"taplo",
  "yamlls",
  "markdown_oxide",

	-- Go
	"gopls",

  -- Deno
  "denols",

	-- Python
	"pylsp",

  -- Rust
  "rust_analyzer",

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

-- Diagnostic styling
--
-- Enable diagnostic floating window
local function diagnostic_floating_window()
	vim.diagnostic.open_float(nil, { focus = false })
end
vim.api.nvim_create_autocmd("CursorHoldI", { callback = diagnostic_floating_window })

-- Toggle diagnostic virtual text
vim.diagnostic.config({
	virtual_text = false,
})
