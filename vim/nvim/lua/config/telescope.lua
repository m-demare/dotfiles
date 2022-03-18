local M = {}
local actions = require "telescope.actions"

local function noremap(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

M.setup = function()
    noremap('n', '<C-p>', '<cmd>lua require"config.telescope".project_files()<CR>')
    noremap('n', '<leader><C-p>', '<cmd>Telescope buffers<CR>')
    noremap('n', '<leader>/', '<cmd>Telescope live_grep<CR>')
    noremap('n', '<leader>gb', '<cmd>Telescope git_branches<CR>')
    local telescope = require 'telescope'
    telescope.setup{
        defaults = {
            mappings = {
                i = {
                    ["<C-h>"] = "which_key",
                    ["<C-k>"] = actions.cycle_history_next,
                    ["<C-j>"] = actions.cycle_history_prev,
                }
            },
            history = {
                path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
                limit = 500,
            }
        }
    }
    if vim.fn.has('unix') == 1 then
        telescope.load_extension('smart_history')
    end
end

M.project_files = function()
  local opts = {}
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end

return M
