local M = {}

M.opts = function()
	local default_conf = require("plugins.configs.nvimtree")

	-----------------------------------
	-- NvimTree Auto open
	-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
	local function open_nvim_tree(data)
		local api = require("nvim-tree.api")
		-- buffer is a directory
		local directory = vim.fn.isdirectory(data.file) == 1
		if not directory then
			return
		end
		-- open the tree
		api.tree.open()
	end
	vim.api.nvim_create_autocmd("VimEnter", { callback = open_nvim_tree })

	-- NvimTree Autoclose @marvinth01
	-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
	local function close_nvim_tree(data)
		local tree_wins = {}
		local floating_wins = {}
		local wins = vim.api.nvim_list_wins()
		for _, w in ipairs(wins) do
			local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
			if bufname:match("NvimTree_") ~= nil then
				table.insert(tree_wins, w)
			end
			if vim.api.nvim_win_get_config(w).relative ~= "" then
				table.insert(floating_wins, w)
			end
		end
		if 1 == #wins - #floating_wins - #tree_wins then
			-- Should quit, so we close all invalid windows.
			for _, w in ipairs(tree_wins) do
				vim.api.nvim_win_close(w, true)
			end
		end
	end
	vim.api.nvim_create_autocmd("QuitPre", { callback = close_nvim_tree })

	-----------------------------------
	-- NvimTree keybindings
	-- QWERTY
	local function on_attach_qwerty(bufnr)
		local api = require("nvim-tree.api")
		local function opts(desc)
			return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
		end
		-- default mappings
		api.config.mappings.default_on_attach(bufnr)
		-- custom mappings
		vim.keymap.set("n", "s", api.node.open.vertical, opts("Open in verical split pane"))
		vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open horizontal split pane"))
		vim.keymap.set("n", "l", api.node.open.edit, opts("Fold"))
		vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Open"))
		vim.keymap.set("n", ".", api.tree.toggle_hidden_filter, opts("Toggle hidden files"))
		vim.keymap.set("n", "?", api.tree.toggle_help, opts("Toggle help"))
	end
	-- COLEMAK-DH
	local function on_attach_colemak(bufnr)
		local api = require("nvim-tree.api")
		local function opts(desc)
			return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
		end
		-- default mappings
		api.config.mappings.default_on_attach(bufnr)
		-- custom mappings
		vim.keymap.set("n", "i", api.node.open.edit, opts("Edit"))
		vim.keymap.set("n", "s", api.node.open.vertical, opts("Open in verical split pane"))
		vim.keymap.set("n", "l", api.node.open.horizontal, opts("Open horizontal split pane"))

		vim.keymap.set("n", "m", api.node.navigate.parent_close, opts("Close parent node"))

		vim.keymap.set("n", ".", api.tree.toggle_hidden_filter, opts("Toggle hidden files"))
		vim.keymap.set("n", "?", api.tree.toggle_help, opts("Toggle help"))
		-- directions
		vim.keymap.set("n", "n", "j", opts("Next"))
		vim.keymap.set("n", "e", "k", opts("Prev"))
    -- deprecated
		vim.keymap.set("n", "o", "", opts("Open"))
	end

	-- override default opts
	default_conf.on_attach = on_attach_colemak
	default_conf.renderer.group_empty = true

	return default_conf
end

return M
