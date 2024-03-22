-- Colemak Dh Angle Keybindings
local M = {}

-- it simplifies remapping
local map = function(mode, lhs, rhs)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set(mode, lhs, rhs, bufopts)
end

local lsp = vim.lsp

M.general = {

	n = {
		-- save
		["<C-q>"] = { "<cmd> q <CR>", "Soft quit" },
		-- switch between windows
		["<C-m>"] = { "<C-w>h", "Window left" },
		["<C-n>"] = { "<C-w>j", "Window down" },
		["<C-e>"] = { "<C-w>k", "Window up" },
		["<C-i>"] = { "<C-w>l", "Window right" },
	},
}
M.disabled = {
	n = {
		-- ["<C-n>"] = "",
		["<C-h>"] = "",
		["<C-j>"] = "",
		["<C-k>"] = "",
		["<C-l>"] = "",
		-- telescope
		["<leader>e"] = "",
	},
}

M.nvimtree = {
	n = {
		-- toggle
		["<C-h>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
	},
}

M.load = function()
	-- directions
	map("n", "m", "h")
	map("v", "m", "h")

	map("n", "n", "j")
	map("v", "n", "j")

	map("n", "e", "k")
	map("v", "e", "k")

	map("n", "i", "l")
	map("v", "i", "l")

	-- insert
	map("n", "l", "i")
	map("n", "L", "I")

	-- select
	map("n", "vi", "vl")
	map("n", "vn", "vj")

	-- find
	map("n", "g", "n")

	-- lsp
	map("n", "gD", lsp.buf.declaration)
	map("n", "gd", lsp.buf.definition)
	map("n", "gi", lsp.buf.implementation)
	map("n", "<leader>D", lsp.buf.type_definition)
	map("n", "gr", lsp.buf.references)
	map("n", "<leader>ca", lsp.buf.code_action)
	map("v", "<leader>ca", lsp.buf.code_action)
end

return M
