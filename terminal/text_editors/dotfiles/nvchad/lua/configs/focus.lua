local M = {}

M.options = {
  enable = true,
  ui = {
    number = true,
    signcolumn = true, -- Display signcolumn in the focussed window only
  },
  autoresize = {
    enable = false,
    width = 90,
    -- ugly but works
    minwidth = 60,
    minwidth = 30,

    height = 30,
    height_quickfix = 10,
  },
}

-- Fix warning
vim.opt.winwidth = 30

local ignore_filetypes = {
  "nvim-tree",
  "neo-tree",
  "NvimTree",
  "NvimTree_1",
  "toggleterm",
}
local ignore_buftypes = {
  "nofile",
  "prompt",
  "popup",
  "NvimTree",
  "NvimTree_1",
  -- "terminal",
}

local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FileType", "VimEnter" }, {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
      vim.o.winwidth = 40
      vim.w.focus_disable = true
    else
      vim.o.winwidth = 60
      vim.w.focus_disable = false
    end
  end,
  desc = "Disable focus autoresize for BufType",
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FileType", "VimEnter" }, {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      vim.o.winwidth = 40
      vim.b.focus_disable = true
    else
      vim.o.winwidth = 60
      vim.b.focus_disable = false
    end
  end,
  desc = "Disable focus autoresize for FileType",
})

-- vim.api.nvim_create_autocmd({ "VimResized" }, {
--   group = augroup,
--   callback = function(_)
--     if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
--       --
--     else
--       vim.cmd "FocusAutoresize"
--     end
--   end,
--   desc = "Resize panes/splits on window resize",
-- })

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
      --
    else
      vim.cmd "wincmd ="
    end
  end,
  desc = "Resize panes/splits on window resize",
})

return M
