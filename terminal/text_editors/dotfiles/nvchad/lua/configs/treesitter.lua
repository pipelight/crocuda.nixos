local M = {}
-- Enable tree-sitter when entering a buffer

-- nvim-dbee fix
M.enable_tree_sitter = function(data)
  vim.cmd "TSEnable highlight"
end
-- vim.api.nvim_create_autocmd("BufNewFile", { callback = M.enable_tree_sitter })
-- vim.api.nvim_create_autocmd("BufReadPre", { callback = M.enable_tree_sitter })
-- vim.api.nvim_create_autocmd("FileReadPre", { callback = M.enable_tree_sitter })
-- vim.api.nvim_create_autocmd("FilterReadPre", { callback = M.enable_tree_sitter })

M.options = {
  ensure_installed = {

    -- usual
    "vim",
    "vimdoc",
    "bash",
    "lua",
    "nix",

    --database
    "sql",

    -- markup
    "toml",
    "yaml",
    "jq",
    "xml",
    "kdl",
  },
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
}

require("nvim-treesitter.configs").setup(M.options)

return M
