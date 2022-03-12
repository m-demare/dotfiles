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

local function install_languages()
    for _, l in ipairs(languages) do
        vim.cmd('TSInstall ' .. l)
    end
end

local function setup()
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
                scope_incremental = "grs",
                node_decremental = "grm",
            },
        },
    }
end

return {
    install_languages = install_languages,
    setup = setup
}
