local M = {}

local colemak = require("custom.layouts.colemak")

M.nvimtree = colemak.nvimtree
M.disabled = colemak.disabled

M.general = colemak.general

M.oatmeal = {
	n = {
		["<leader>oo"] = {
			":<c-u>Oatmeal<cr>",
			"Start Oatmeal session",
		},
	},
}

M.telescope = {
	n = {
		["<C-f>"] = { "<cmd>Telescope live_grep<CR>", "Live grep" },
		["<leader>ff"] = { "<cmd>Telescope find_files hidden=true<CR>", "Find files" },
	},
}

M.motions = {
	v = {
		["<PageUp>"] = { "<cmd>call smoothie#do('<C-u>')<cr>" },
		["<PageDown>"] = { "<cmd>call smoothie#do('<C-d>')<cr>" },
	},
	n = {
		["<PageUp>"] = { "<cmd>call smoothie#do('<C-u>')<cr>" },
		["<PageDown>"] = { "<cmd>call smoothie#do('<C-d>')<cr>" },
	},
}

M.tests = {
	n = {
		["<leader>tt"] = {
			":<c-u>TestFile<cr>",
			"Launch nearest test suite",
		},
	},
}

return M
