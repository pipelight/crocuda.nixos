require "nvchad.options"

-- Use os clipboard
--
local o = vim.o
o.clipboard = "unnamed"
o.clipboard = "unnamedplus"
vim.api.nvim_set_option("clipboard", "unnamed")
vim.api.nvim_set_option("clipboard", "unnamedplus")

-- Detect dns bindzone file "*.zone"
--
vim.cmd "au BufNewFile,BufRead *.zone		setf bindzone"
-- vim.cmd "au FileType bindzone   setl cms=;%s"
-- vim.cmd "au FileType bindzone   setl commentstring=;%s"
