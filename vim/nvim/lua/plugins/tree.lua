local utils = require('utils')
local unix = utils.unix
local icons = require('config.icons')

return {
    'kyazdani42/nvim-tree.lua',
    dependencies = unix and 'kyazdani42/nvim-web-devicons' or nil,
    keys = {
        {
            '<leader>tt',
            function()
                require('nvim-tree.api').tree.toggle()
            end
        },
        {
            '\\t',
            function()
                local repo = vim.fn.FugitiveWorkTree()
                if repo == '' then repo = nil end
                -- open it at the repo root, focused in current file
                require('nvim-tree.api').tree.toggle { path = repo, find_file = true }
            end
        },

    },
    opts = {
        hijack_netrw = false,
        on_attach = function(bufnr)
            local api = require('nvim-tree.api')

            local function opts(desc)
                return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, nowait = true }
            end

            -- :h nvim-tree-mappings-default
            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
        end,
        actions = {
            use_system_clipboard = true,
            open_file = {
                quit_on_open = true
            }
        },
        renderer = {
            icons = icons.nvim_tree_icons,
        },
    },
}
