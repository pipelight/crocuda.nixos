local M = {}

M.options = {
  ui = {
    number = true,
    signcolumn = false, -- Display signcolumn in the focussed window only
  },
  autoresize = {
    enable = true,
    width = 100,
    -- minwidth = 60,
    height = 30,
    height_quickfix = 10,
  },
}

M.config = function()
  local ignore_filetypes = {
    "nvim-tree",
    "neo-tree",
    "NvimTree_",
    -- "toggleterm"
  }
  local ignore_buftypes = {
    "nofile",
    "prompt",
    "popup",
    "NvimTree_",
    -- "terminal",
  }

  -- Fix warning
  -- vim.opt.winwidth = 60

  local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "VimEnter" }, {
    group = augroup,
    callback = function(_)
      if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
        vim.w.focus_disable = true
      else
        vim.w.focus_disable = false
      end
    end,
    desc = "Disable focus autoresize for BufType",
  })

  vim.api.nvim_create_autocmd({ "FileType", "VimEnter" }, {
    group = augroup,
    callback = function(_)
      if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
        vim.b.focus_disable = true
      else
        vim.b.focus_disable = false
      end
    end,
    desc = "Disable focus autoresize for FileType",
  })

  -- Not working yet
  --
  -- vim.api.nvim_create_autocmd({ "VimResized" }, {
  --   group = augroup,
  --   callback = function(_)
  --     if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
  --       --
  --     else
  --       vim.cmd "<C-w>="
  --     end
  --   end,
  --   desc = "Resize panes/splits on window resize",
  -- })
end

return M
