local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local sources = {
	-- Proto
	lint.buf.with({ args = { "lint" } }),
	-- formatting.buf,

	-- Json Toml and Yaml
	lint.yamllint,
	lint.jsonlint,

	-- toml
	formatting.taplo,

	-- Js
	formatting.deno_fmt,
	-- lint.deno_lint,

	-- Vue
	lint.eslint.with({ filetypes = { "vue" } }),
	-- formatting.prettierd.with({ filetypes = { "vue" } }),

	-- Nix
	lint.statix,
	formatting.alejandra,

	-- makefile/justfile
	lint.checkmake,

  --Go
  formatting.gofmt,
  lint.golangci_lint,

  --Python
  lint.ruff,
  formatting.black,

	-- formatting.pg_format,
	-- formatting.sqlfluff.with { extra_args = { "--dialect", "postgres" } },

	-- Rust
	-- Use rust analyzer in lspconfig.lua (rustfmt deprecated)
	-- formatting.rustfmt,

	-- Css
	-- formatting.prettierd.with({
	-- 	filetypes = { "css, scss" },
	-- }),
	lint.stylelint,
	formatting.stylelint,

	-- Lua
	formatting.stylua,

	-- Shell
	formatting.shfmt,
	-- lint.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
	lint.shellcheck,

	-- Git
	null_ls.builtins.code_actions.gitsigns,
}

null_ls.setup({
	debug = true,
	sources = sources,
	on_attach = function()
		vim.api.nvim_create_autocmd("BufWritePost", {
			callback = function()
				vim.lsp.buf.format()
			end,
		})
	end,
})
