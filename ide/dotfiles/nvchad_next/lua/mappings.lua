require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del
local lsp = vim.lsp

-- File
--
map("n", "<C-q>", "<cmd> qa <CR>", { desc = "File quit if saved" })

-- Motions
--

-- switch between windows
map("n", "<C-m>", "<C-w>h", { desc = "Move to window left" })
map("n", "<C-n>", "<C-w>j", { desc = "Move to window down" })
map("n", "<C-e>", "<C-w>k", { desc = "Move to window up" })
map("n", "<C-i>", "<C-w>l", { desc = "Move to window right" })
map("n", "<C-x>", "<C-w>x", { desc = "Swap with next window" })
nomap("n", "<C-h>")
nomap("n", "<C-j>")
nomap("n", "<C-k>")
nomap("n", "<C-l>")

-- terminal
nomap("n", "<leader>h")

-- fast file browsing
map("n", "<PageUp>", "<cmd>call smoothie#do('25<C-u>z.')<cr>", { desc = "Motions page down (smooth)" })
map("v", "<PageUp>", "<cmd>call smoothie#do('25<C-u>z.')<cr>", { desc = "Motions page down (smooth)" })
map("i", "<PageUp>", "<cmd>call smoothie#do('25<C-u>z.')<cr>", { desc = "Motions page down (smooth)" })

map("v", "<PageDown>", "<cmd>call smoothie#do('25<C-d>z.')<cr>", { desc = "Motions page down (smooth)" })
map("n", "<PageDown>", "<cmd>call smoothie#do('25<C-d>z.')<cr>", { desc = "Motions page down (smooth)" })
map("i", "<PageDown>", "<cmd>call smoothie#do('25<C-d>z.')<cr>", { desc = "Motions page down (smooth)" })

map("n", "m", "h", { desc = "rotions move left" })
map("v", "m", "h", { desc = "Motions move left" })

-- map("n", "n", "1<C-d>", { desc = "Motions move down" })
-- map("v", "n", "1<C-d>", { desc = "Motions move down" })
map("n", "n", "j", { desc = "Motions move down" })
map("v", "n", "j", { desc = "Motions move down" })

-- map("n", "e", "1<C-u>", { desc = "Motions move up" })
-- map("v", "e", "1<C-u>", { desc = "Motions move up" })
map("n", "e", "k", { desc = "Motions move up" })
map("v", "e", "k", { desc = "Motions move up" })

map("n", "i", "l", { desc = "Motions move right" })
map("v", "i", "l", { desc = "Motions move right" })

-- insert
map("n", "l", "i", { desc = "Motions insert under cursor" })
map("n", "L", "I", { desc = "Motions insert under cursor" })

-- select
map("n", "vi", "vl", { desc = "Motions select" })
map("n", "vn", "vj", { desc = "Motions select" })

-- find

map("n", "f", "n", { desc = "Motions go to next occurance" })
map("n", "F", "N", { desc = "Motions go to previous occurance" })
map("n", "ff", "N", { desc = "Motion find under cursor" })

-- Lsp
--
map("n", "gD", lsp.buf.declaration, { desc = "Lsp go to in file declaration" })
map("n", "gd", lsp.buf.definition, { desc = "Lsp go to definition" })
map("n", "gi", lsp.buf.implementation)
map("n", "<leader>D", lsp.buf.type_definition)
map("n", "gr", lsp.buf.references)
map("n", "<leader>ca", lsp.buf.code_action)
map("v", "<leader>ca", lsp.buf.code_action)

-- Comment
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Comment toggle" })
map(
  "v",
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Comment toggle" }
)

-- Toggle
--
map("n", "<C-h>", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree" })

-- Telescope
--
map("n", "<C-f>", "<cmd>Telescope live_grep<CR>", { desc = "Telescope live grep" })
map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Telescope find files" })
nomap("n", "<leader>e")

-- Test suite
--
map("n", "<leader>tt", ":<c-u>TestFile<cr>", { desc = "Test launch nearest test suite" })

-- Database
--
map("n", "<leader>db", function()
  require("dbee").toggle()
end, { desc = "Database open editor" })
