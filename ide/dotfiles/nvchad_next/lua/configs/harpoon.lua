require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del
local lsp = vim.lsp

-- Config from:
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
--
local harpoon = require "harpoon"
harpoon:setup {}

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

-- Mappings
-- Harpoon

map("n", "<C-,>", function()
  toggle_telescope(harpoon:list())
end, { desc = "Telescope open harpoon list" })

map("n", "<leader>a", function()
  harpoon:list():add()
end, { desc = "Harpoon add file to list" })
map("n", "<leader>A", function()
  harpoon:list():remove()
end, { desc = "Harpoon add file to list" })

-- Toggle previous & next buffers stored within Harpoon list
map("n", "<Tab>", function()
  harpoon:list():prev { ui_nav_wrap = true }
end)
