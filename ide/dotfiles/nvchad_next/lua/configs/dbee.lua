local map = vim.keymap.set
local nomap = vim.keymap.del
local lsp = vim.lsp

local dbee = require "dbee"
dbee.setup {
  drawer = {

    mappings = {
      -- manually refresh drawer
      { key = "<C,r>", mode = "n", action = "refresh" },
      -- actions perform different stuff depending on the node:
      -- action_1 opens a note or executes a helper
      { key = "<CR>", mode = "n", action = "action_1" },
      -- action_2 renames a note or sets the connection as active manually
      { key = "r", mode = "n", action = "action_2" },
      -- action_3 deletes a note or connection (removes connection from the file if you configured it like so)
      { key = "dd", mode = "n", action = "action_3" },
      -- these are self-explanatory:
      { key = "m", mode = "n", action = "collapse" },
      { key = "i", mode = "n", action = "expand" },
      { key = "o", mode = "n", action = "toggle" },

      -- mappings for menu popups:
      { key = "<CR>", mode = "n", action = "menu_confirm" },
      { key = "y", mode = "n", action = "menu_yank" },
      { key = "<Esc>", mode = "n", action = "menu_close" },
      { key = "q", mode = "n", action = "menu_close" },
    },
  },
  editor = {
    -- mappings for the buffer
    mappings = {
      -- run what's currently selected on the active connection
      { key = "<leader>tt", mode = "v", action = "run_selection" },
      -- run the whole file on the active connection
      { key = "<leader>tt", mode = "n", action = "run_file" },
    },
  },
}
