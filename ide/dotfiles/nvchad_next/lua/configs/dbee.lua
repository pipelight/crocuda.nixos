require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del
local lsp = vim.lsp

local dbee = require "dbee"
dbee.setup {}

-- Mappings
-- Dbee

map("n", "<leader>db", function()
  dbee.open()
end, { desc = "Database open editor" })
