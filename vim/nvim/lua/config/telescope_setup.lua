local M = {}

local map  = require('utils').map

function M.picker(name)
    return function()
        require'telescope.builtin'[name]()
    end
end

function M.project_files()
  local opts = {}
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end

function M.setup()
    map('n', '<C-p>', M.project_files)
    map('n', '<leader><C-p>', M.picker 'buffers')
    map('n', '<leader>/', M.picker 'live_grep')
    map('n', '<leader>gb', M.picker 'git_branches')
end

return M

