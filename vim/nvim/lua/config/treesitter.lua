local languages = {
    "c",
    "cpp",
    "java",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "rust",
    "svelte",
    "tsx",
    "typescript",
    "vue"
}

local function install_parsers()
    vim.cmd('TSInstall ' .. table.concat(languages, ' '))
end

local function total_size(bufnr)
    local lines, size  = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), 0
    for _, line in ipairs(lines) do
        size = size + string.len(line)
    end
    return size
end

local function setup()
    require'nvim-treesitter.configs'.setup {
        highlight = {
            enable = true,
            disable = function(lang, bufnr)
                return lang == "javascript" and total_size(bufnr) > 100000
            end,
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<Enter>",
                node_incremental = "<Enter>",
                scope_incremental = "<Space><Enter>",
                node_decremental = "<BS>",
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
