local M = {}

local function noremap(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

M.setup = function()
    noremap('n', '<C-p>', '<cmd>lua require"telescope-config".project_files()<CR>')
    noremap('n', '<space><C-p>', '<cmd>Telescope buffers<CR>')
    noremap('n', '<space>/', '<cmd>Telescope live_grep<CR>')
end

M.project_files = function()
  local opts = {}
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end

return M
