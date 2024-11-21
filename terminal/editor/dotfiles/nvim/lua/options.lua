-- Use os clipboard
--
local o = vim.o
local api = vim.api

o.clipboard = "unnamed"
o.clipboard = "unnamedplus"

api.nvim_set_option("clipboard", "unnamed")
api.nvim_set_option("clipboard", "unnamedplus")
