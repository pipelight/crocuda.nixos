local M = {}

M.nvimtree = {
	update_focused_file = {
		enable = true,
		update_root = true,
	},
	-- tree git support
	git = {
		enable = true,
	},
	renderer = {
		highlight_opened_files = "none",
		-- disable icons
		icons = {
			show = {
				git = true,
				file = false,
				folder = false,
			},
		},
	},
}

M.mason = {
	ensure_installed = {
		-- lua optional
		"stylua",
		-- web
		"html-lsp",
		"prettierd",
		"deno",
		"vue-language-server",
	},
}

M.treesitter = {
	ensure_installed = {
		"vim",
		"vimdoc",
		"bash",
		"rust",
		"toml",
		"jq",
		"yaml",
		"vue",
		"javascript",
		"typescript",
		"css",
		"scss",
		"yuck",
		"pug",
		"html",
	},
}

return M
