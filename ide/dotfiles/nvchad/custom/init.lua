-- Layout
local colemak = require("custom.layouts.colemak")
colemak.load()
-- Use os clipboard
vim.opt.clipboard = "unnamed"
vim.opt.clipboard = "unnamedplus"
vim.api.nvim_set_option("clipboard", "unnamed")
vim.api.nvim_set_option("clipboard", "unnamedplus")

