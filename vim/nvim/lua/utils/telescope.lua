local utils = require "utils"
local telescope_builtin = utils.bind(require, "telescope.builtin")

local M = {}

function M.picker(name, ...)
    return utils.call_bind(telescope_builtin, name, ...)
end

function M.extension_picker(ext, picker)
    return function()
        require("telescope").extensions[ext][picker]()
    end
end

function M.project_files()
    local ok = pcall(require("telescope.builtin").git_files, { recurse_submodules = true })
    if not ok then require("telescope.builtin").find_files {} end
end

function M.grep_string()
    local mode = string.lower(vim.api.nvim_get_mode().mode)
    local query
    if mode == "v" then
        query = require("utils").visual_selection()
    else
        query = vim.fn.input "Pattern: "
    end
    require("telescope.builtin").grep_string {
        search = query ~= "" and query or nil,
        use_regex = mode ~= "v",
        file_ignore_patterns = { ".git" },
        additional_args = { "--hidden" },
    }
end

return M
