require "nvchad.options"

-- Use os clipboard
--
local o = vim.o
o.clipboard = "unnamed"
o.clipboard = "unnamedplus"
vim.api.nvim_set_option("clipboard", "unnamed")
vim.api.nvim_set_option("clipboard", "unnamedplus")
