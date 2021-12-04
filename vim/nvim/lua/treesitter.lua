local languages = {
    "javascript",
    "typescript",
    "c",
    "cpp",
    "lua",
    "vue",
    "latex",
    "python",
    "svelte"
}

function install_languages()
    for i, l in ipairs(languages) do
        vim.cmd('TSInstall! ' .. l)
    end
end

function setup()
    require'nvim-treesitter.configs'.setup {
        highlight = {
            enable = true,
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },
    }
end

return {
    install_languages = install_languages,
    setup = setup
}
