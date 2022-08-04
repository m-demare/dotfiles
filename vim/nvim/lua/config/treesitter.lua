local languages = {
    "c",
    "cpp",
    "java",
    "javascript",
    "latex",
    "lua",
    "python",
    "svelte",
    "tsx",
    "typescript",
    "vue"
}

local function install_parsers()
    vim.cmd('TSInstall ' .. table.concat(languages, ' '))
end

local function setup()
    require'nvim-treesitter.configs'.setup {
        highlight = {
            enable = true
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grs",
                node_decremental = "grm",
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@call.outer",
                    ["ic"] = "@call.inner",
                },
            },
        },
        playground = {
            enable = true,
        }
    }
end

return {
    install_parsers = install_parsers,
    setup = setup
}
