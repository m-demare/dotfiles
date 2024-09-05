local utils = require "utils"
local unix = utils.unix
local icons = require "config.icons"

return {
    {
        "sainnhe/sonokai",
        config = function()
            vim.g.sonokai_style = "shusia"
            vim.g.sonokai_transparent_background = unix and 2 or 0
            vim.g.sonokai_current_word = "underline"
            vim.g.sonokai_better_performance = 1
            local augroup = vim.api.nvim_create_augroup("SonokaiCustom", { clear = true })
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = function()
                    vim.api.nvim_set_hl(0, "TSVariableBuiltin", { link = "OrangeItalic" })
                    vim.api.nvim_set_hl(0, "TSProperty", { link = "Fg" })
                    vim.api.nvim_set_hl(0, "TSField", { link = "Green" })
                    vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "Grey" })
                    if unix then
                        local transparent_groups =
                            { "CursorLine", "TabLine", "FloatBorder", "NormalFloat" }
                        for _, group in ipairs(transparent_groups) do
                            vim.cmd("highlight " .. group .. " ctermbg=none guibg=none")
                        end
                    end
                    vim.cmd "highlight! Visual guibg=#666666"
                end,
                group = augroup,
            })
            vim.cmd.colorscheme "sonokai"
        end,
    },
    {
        "m-demare/hlargs.nvim",
        event = "VeryLazy",
        dev = true,
        opts = {
            hl_priority = 126,
            highlight = {
                fg = "#ef9062",
                italic = true,
                cterm = { italic = true },
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = "SmiteshP/nvim-navic",
        config = function(_, opts)
            vim.o.showmode = false
            local navic = require "nvim-navic"
            table.insert(opts.sections.lualine_c, {
                function()
                    return navic.get_location()
                end,
                cond = navic.is_available,
            })
            require("lualine").setup(opts)
        end,
        opts = {
            options = {
                icons_enabled = unix,
                theme = "sonokai",
                section_separators = icons.lualine_separators,
                component_separators = icons.lualine_separators,
                globalstatus = true,
            },
            sections = {
                lualine_c = { "filename" },
            },
        },
    },
    {
        "SmiteshP/nvim-navic",
        dependencies = "neovim/nvim-lspconfig",
        lazy = true,
        opts = {
            icons = icons.navic_icons,
            depth_limit = 2,
        },
    },
}
