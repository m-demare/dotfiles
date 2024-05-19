local unix = require("utils").unix

local function total_size(bufnr)
    local lines, size = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), 0
    for _, line in ipairs(lines) do
        size = size + string.len(line)
    end
    return size
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
        opts = {
            ensure_installed = unix and {
                "c",
                "cpp",
                "java",
                "javascript",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "rust",
                "svelte",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "vue",
            } or {},
            highlight = {
                enable = true,
                disable = function(lang, bufnr)
                    return lang == "javascript" and total_size(bufnr) > 100000
                end,
            },
            indent = { enable = true },
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
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
