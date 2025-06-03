local M = {}

M.options = {
  enable = true,
  ui = {
    -- Things to display in the focussed window only
    number = false,
    signcolumn = true,
  },
  autoresize = {
    enable = false,
    width = 90,
    height = 30,
    -- ugli but works
    -- minwidth = 60,
    -- minwidth = 35,
    height_quickfix = 10,
  },
}

-- Fix warning
-- vim.opt.winwidth = 35

local ignore_filetypes = {
  "NvimTree",
  "NvimTree_1",
  "",
  -- "toggleterm",
}
local ignore_buftypes = {
  "popup",
  "nofile",
  -- "prompt",
  -- "terminal",
}

local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FileType", "VimEnter" }, {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
      vim.o.winwidth = 35
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
      vim.o.winwidth = 35
      vim.b.focus_disable = true
    else
      vim.o.winwidth = 60
      vim.b.focus_disable = false
    end
  end,
  desc = "Disable focus autoresize for FileType",
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
      --
    else
      vim.cmd "wincmd ="
    end
  end,
  desc = "Resize panes/splits on window resize for BufType",
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      --
    else
      vim.cmd "wincmd ="
    end
  end,
  desc = "Resize panes/splits on window resize for FileType",
})

return M
