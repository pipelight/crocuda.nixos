-- Nix unit tests
-- Configure vim-test to use Lix-unit on .nix files
local M = {}
-- Returns true if the given file belongs to your test runner
-- test#mylanguage#myrunner#test_file(file)
M.test_file = function(file)
  -- local filetype = vim.filetype.match { filename = file }
  -- return filetype == "nix"
  return true
end

-- Returns test runner's arguments which will run the current file and/or line
-- test#mylanguage#myrunner#build_position(type, position)
M.build_position = function(type, position) end

-- Returns processed args (if you need to do any processing)
-- test#mylanguage#myrunner#build_args(args)
M.build_args = function(args) end

--Returns the executable of your test runner
-- test#mylanguage#myrunner#executable
M.executable = function()
  return "nix-unit"
end

return M
