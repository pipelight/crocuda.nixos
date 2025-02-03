local M = {}

M.options = {
  default_file_explorer = true,
  keymaps = {
    ["?"] = { "actions.show_help", mode = "n" },
    ["<CR>"] = "actions.select",
    ["s"] = { "actions.select", opts = { vertical = true } },
    ["l"] = { "actions.select", opts = { horizontal = true } },
    ["i"] = { "actions.select", opts = { tab = true } },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = { "actions.close", mode = "n" },
    ["<C-l>"] = "actions.refresh",
    ["m"] = { "actions.parent", mode = "n" },
    ["."] = { "actions.toggle_hidden", mode = "n" },
  },
}
