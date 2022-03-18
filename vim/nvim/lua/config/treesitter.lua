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
            enable = true,
            disable = function(lang, bufnr)
                -- Disable for minified js. Not perfect, single line minified files
                -- still destroy performance
                return lang == "javascript" and vim.api.nvim_buf_line_count(bufnr) > 4000
            end
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
    }
end

return {
    install_parsers = install_parsers,
    setup = setup
}
