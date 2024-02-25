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
  local ok = pcall(require"telescope.builtin".git_files, {recurse_submodules=true})
  if not ok then require"telescope.builtin".find_files{} end
end

local function visual_selection_range()
  local _, to_row, to_col, _ = unpack(vim.fn.getpos("'<"))
  local _, from_row, from_col, _ = unpack(vim.fn.getpos("'>"))
  if to_row < from_row or (to_row == from_row and to_col <= from_col) then
    return to_row - 1, to_col - 1, from_row - 1, from_col
  else
    return from_row - 1, from_col - 1, to_row - 1, to_col
  end
end

function M.grep_string()
    local mode = string.lower(vim.api.nvim_get_mode().mode)
    local get_query
    if mode == 'v' then
        -- Need to leave visual mode so that '> '< are saved
        -- Also, the vim.schedule below is necessary for that
        local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
        vim.api.nvim_feedkeys(esc, 'nt', false)
        get_query = function ()
            local from_row, from_col, to_row, to_col = visual_selection_range()
            return utils.tbl_join(vim.api.nvim_buf_get_text(0, from_row, from_col, to_row, to_col, {}), '\n')
        end
    else
        get_query = function ()
            return vim.fn.input('Pattern: ')
        end
    end
    vim.schedule(function ()
        local query = get_query()
        require('telescope.builtin').grep_string {
            search = query~='' and query or nil,
            use_regex = mode ~= 'v',
            file_ignore_patterns = { '.git' },
            additional_args={'--hidden'},
        }
    end)
end

function M.setup()
    map('n', '<C-p>', M.project_files)
    map('n', '<leader>ff', M.picker('find_files', {no_ignore=true, no_ignore_parent=true}))
    map('n', '<leader><C-p>', M.picker 'buffers')
    map('n', '<leader>/', M.picker('live_grep', { file_ignore_patterns = { '.git' }, additional_args={'--hidden'} }))
    map({ 'n', 'v' }, '<leader>?', M.grep_string)
    map('n', '<leader>gb', M.picker 'git_branches')
    vim.ui.select = function (...)
        vim.cmd[[PackerLoad telescope.nvim]]
        vim.ui.select(...)
    end
end

return M

