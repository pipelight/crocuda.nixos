local configs = require("nvchad.configs.lspconfig")
local on_attach = configs.on_attach
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")

-- Enable diagnostic floating window
local function diagnostic_floating_window()
	vim.diagnostic.open_float(nil, { focus = false })
end
vim.api.nvim_create_autocmd("CursorHoldI", { callback = diagnostic_floating_window })

-- Toggle diagnostic virtual text
vim.diagnostic.config({
	virtual_text = false,
})

local on_attach_custom = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = true
	client.server_capabilities.documentRangeFormattingProvider = false

	utils.load_mappings("lspconfig", { buffer = bufnr })

	if client.server_capabilities.signatureHelpProvider then
		require("nvchad.signature").setup(client)
	end

	if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

local on_attach_fast = function()
	vim.api.nvim_create_autocmd("BufWritePost", {
		callback = function()
			vim.lsp.buf.format()
		end,
	})
end

local servers = {
	"lua_ls",
	-- Web
	"html",
	"cssls",
	-- "tailwindcss",
	-- Nix
	"nil_ls",
	-- Toml
	"taplo",
	-- Go
	-- "gopls",
	-- Pyhton
	"pylsp",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		init_options = {
			lint = true,
		},
	})
end

-- Tsserver
-- lspconfig.tsserver.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   root_dir = lspconfig.util.root_pattern "package.json",
--   single_file_support = false,
-- }

-- Rust
lspconfig.rust_analyzer.setup({
	on_attach = on_attach_custom,
	capabilities = capabilities,
	init_options = {
		lint = true,
	},
})

-- Go
lspconfig.gopls.setup({
	on_attach = on_attach_custom,
	capabilities = capabilities,
})

-- Deno
lspconfig.denols.setup({
	on_attach = on_attach_fast,
	capabilities = capabilities,
	root_dir = lspconfig.util.root_pattern("deno.json"),
	init_options = {
		lint = true,
	},
})

-- Vue
lspconfig.vuels.setup({
	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
	on_attach = on_attach_fast,
	capabilities = capabilities,
})
