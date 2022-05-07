local M = {}

local utils  = require('utils')
local map  = utils.map

local telescope_builtin = utils.bind(require, 'telescope.builtin')
function M.picker(name)
    return utils.call_bind(telescope_builtin, name)
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
    vim.ui.select = function (...)
        vim.cmd[[PackerLoad telescope.nvim]]
        vim.ui.select(...)
    end
end

return M

