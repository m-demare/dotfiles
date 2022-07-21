local M = {}

local utils  = require('utils')
local map  = utils.map

local telescope = utils.bind(require, 'telescope')
local telescope_builtin = utils.bind(require, 'telescope.builtin')
function M.picker(name, ...)
    return utils.call_bind(telescope_builtin, name, ...)
end

function M.extension_picker(ext, picker)
    return function ()
        telescope().extensions[ext][picker]()
    end
end

function M.project_files()
  local opts = {}
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end

function M.grep_string()
    require('telescope.builtin').grep_string {
        search = vim.fn.input('Pattern: '),
        use_regex=true
    }
end

function M.setup()
    map('n', '<C-p>', M.picker 'find_files')
    map('n', '<leader>ff', M.picker('find_files', {no_ignore=true, no_ignore_parent=true}))
    map('n', '<leader><C-p>', M.picker 'buffers')
    map('n', '<leader>/', M.picker 'live_grep')
    map('n', '<leader>?', M.grep_string)
    map('n', '<leader>gb', M.picker 'git_branches')
    vim.ui.select = function (...)
        vim.cmd[[PackerLoad telescope.nvim]]
        vim.ui.select(...)
    end
end

return M

