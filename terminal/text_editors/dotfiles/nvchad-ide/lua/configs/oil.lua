local M = {}

vim.api.nvim_create_user_command("OilToggle", function()
  vim.cmd((vim.bo.filetype == "oil") and "b#" or "Oil")
end, { nargs = 0 })

M.options = {
  default_file_explorer = true,
  keymaps = {
    ["?"] = { "actions.show_help", mode = "n" },
    ["i"] = "actions.select",
    ["<CR>"] = "actions.select",

    -- Close
    ["q"] = { "actions.close", mode = "n" },
    ["<C-n>"] = { "actions.close", mode = "n" },

    ["s"] = { "actions.select", opts = { vertical = true } },
    ["l"] = { "actions.select", opts = { horizontal = true } },
    ["m"] = { "actions.parent", mode = "n" },

    ["<C-p>"] = "actions.preview",
    ["<C-l>"] = "actions.refresh",

    ["."] = { "actions.toggle_hidden", mode = "n" },
  },
  use_default_keymaps = false,
}

return M
