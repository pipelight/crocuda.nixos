local M = {}

M.ui = {
	------------------------------- base46 -------------------------------------
	theme = "doomchad", -- default theme
	theme_toggle = nil,

	-- lazyload it when there are 1+ buffers
	tabufline = {
		-- disable theme button only
		overriden_modules = function(modules)
			table.remove(modules, 4)
			-- remove bufline
			table.remove(modules, 3)
			-- remove toggle
			table.remove(modules, 2)
			table.remove(modules, 1)

			table.insert(
				modules,
				1,
				-- Add filepath to bufline
				(function()
					local cwd = vim.loop.cwd()
					local path = vim.api.nvim_buf_get_name(0)
					local subpath = string.gsub(path, cwd, "")
					return "%#TbLineBufOff#" .. subpath
				end)()
			)
		end,
		lazyload = true,

		-- disable tabufline
		-- overriden_modules = nil,
	},

	-- Add filepath to statusline
	-- statusline = {
	-- 	overriden_modules = function(modules)
	-- 			(function()
	-- 				local path = vim.api.nvim_buf_get_name(0)
	-- 				local subpath = path.find()
	-- 				return "%#St_LspStatus#" .. path
	-- 			end)()
	-- 	end,
	-- },

	-- cmp themeing
	cmp = {
		icons = false,
	},
}

M.mappings = require("custom.mappings")
M.plugins = "custom.plugins.main"

return M
