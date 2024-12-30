require "nvchad.options"

-- Use os clipboard
--
local o = vim.o
local api = vim.api

o.clipboard = "unnamed"
o.clipboard = "unnamedplus"
o.splitbelow = true
o.splitright = true

api.nvim_set_option("clipboard", "unnamed")
api.nvim_set_option("clipboard", "unnamedplus")

-- Autosession compat
-- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Detect dns bindzone file "*.zone"
--
vim.cmd "au BufNewFile,BufRead *.zone		setf bindzone"
vim.cmd "au BufNewFile,BufRead *.rcl		setf rcl"
-- vim.cmd "au BufNewFile,BufRead *.jjdescription		setf gitcommit"
-- vim.cmd "au FileType bindzone   setl cms=;%s"
-- vim.cmd "au FileType bindzone   setl commentstring=;%s"
