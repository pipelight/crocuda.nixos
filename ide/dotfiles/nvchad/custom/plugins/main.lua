local nvimtree = require("custom.plugins.nvimtree")
local overrides = require("custom.overrides")

local plugins = {
	{
		"nvim-tree/nvim-tree.lua",
		opts = nvimtree.opts(),
		lazy = false,
		priority = 50,
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},
	{
		"williamboman/mason.nvim",
		config = function()
			local mason = require("mason")
			mason.setup({
				PATH = "append",
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("custom.plugins.null-ls")
			end,
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.plugins.lspconfig")
		end,
	},
	{
		"isobit/vim-caddyfile",
		lazy = true,
	},
	{
		"psliwka/vim-smoothie",
		lazy = false,
	},
	{
		"echasnovski/mini.animate",
		lazy = false,
		config = function()
			local animate = require("mini.animate")
			require("mini.animate").setup({
				open = {
					enable = false,
				},
				close = {
					enable = false,
				},
				cursor = {
					enable = false,
				},
				scroll = {
					enable = false,
				},
				resize = {
					enable = true,
					timing = animate.gen_timing.quartic({ easing = "out", duration = 14, unit = "total" }),
					-- subresize = animate.gen_subresize.equal({ predicate = is_many_wins }),
				},
			})
		end,
	},
	{
		"vim-test/vim-test",
		config = function()
			vim.g["test#preserve_screen"] = 0
			vim.g["test#neovim#start_normal"] = 1
			vim.g["test#neovim#term_position"] = "vert"
			vim.g["test#strategy"] = "toggleterm"
			vim.g["test#rust#cargotest#test_options"] = "-- --test-threads 1 --nocapture"
			vim.g["test#javascript#deno#test_options"] = "--allow-all"
		end,
		lazy = false,
	},
	-- vim-test dependencie
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = function(term)
					return vim.o.columns * 0.32
				end,
				direction = "vertical",
				persist_size = true,
				hide_numbers = false,
				close_on_exit = false,
				shade_terminals = true,
				shading_factor = "-15",
				terminal_mappings = false,
				shell = "fish",
			})
		end,
		lazy = false,
	},
	-------------------------------
	-- Non optimal setup
	{
		-- config file at:
		-- https://github.com/NvChad/NvChad/issues/646
		"rmagatti/auto-session",
		cmd = { "SaveSession", "RestoreSession" },
		config = function()
			require("auto-session").setup({
				log_level = "warn",
				auto_session_enable_last_session = true,
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions",
				auto_session_enabled = true,
				auto_save_enabled = true,
				auto_restore_enabled = true,
				auto_session_suppress_dirs = nil,
				pre_save_cmds = { "tabdo NvimTreeClose" },
				post_restore_cmds = { "tabdo NvimTreeRefresh" },
			})
		end,
		lazy = false,
	},
	-- linter for yuck files (eww bar)
	{
		"elkowar/yuck.vim",
	},
	{
		"nvim-telescope/telescope.nvim",
		opts = overrides.telescope,
	},
	{
		"nvim-focus/focus.nvim",
		config = function()
			local ignore_filetypes = { "nvim-tree", "neo-tree", "NvimTree_*" }
			local ignore_buftypes = { "nofile", "prompt", "popup", "NvimTree_*" }

			local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

			vim.api.nvim_create_autocmd({ "WinEnter", "VimEnter" }, {
				group = augroup,
				callback = function(_)
					if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
						vim.w.focus_disable = true
					else
						vim.w.focus_disable = false
					end
				end,
				desc = "Disable focus autoresize for BufType",
			})
			vim.api.nvim_create_autocmd({ "FileType", "VimEnter" }, {
				group = augroup,
				callback = function(_)
					if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
						vim.b.focus_disable = true
					else
						vim.b.focus_disable = false
					end
				end,
				desc = "Disable focus autoresize for FileType",
			})
			require("focus").setup({
				ui = {
					number = false,
					signcolumn = false, -- Display signcolumn in the focussed window only
				},
				autoresize = {
					enable = true,
					width = 80,
					height = 50,
					height_quickfix = 10,
				},
			})
		end,
		priority = 60,
		lazy = true,
	},
	{
		"dustinblackman/oatmeal.nvim",
		cmd = { "Oatmeal" },
		keys = {
			{ "<leader>om", mode = "n", desc = "Start Oatmeal session" },
		},
		opts = {
			backend = "ollama",
			model = "starcoder:latest",
		},
	},
}

return plugins
