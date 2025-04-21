vim.g.OpenLink = function(url)
    vim.cmd("silent ! firefox --private-window " .. url)
end

return {
    {
        "HakonHarnes/img-clip.nvim",
        opts = {
            default = {
                dir_path = function()
                    local options = { "assets", "images", "img", "static/img" }
                    return require("utils").tbl_find(options, function(d)
                        return vim.fn.isdirectory(d) == 1
                    end) or options[1]
                end,
            },
        },
        keys = {
            { "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
        },
    },
    {
        "epwalsh/obsidian.nvim",
        ft = { "markdown" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            workspaces = {
                {
                    name = "wiki",
                    path = "~/wiki",
                },
            },
            ui = {
                checkboxes = {
                    [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                    ["."] = { char = "󰡖", hl_group = "ObsidianTodo" },
                    ["x"] = { char = "", hl_group = "ObsidianDone" },
                },
            },
            follow_url_func = vim.g.OpenLink,
        },
        enabled = vim.fn.isdirectory ( vim.fn.expand '~/wiki' )
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.cmd [[Lazy load markdown-preview.nvim]]
            vim.fn["mkdp#util#install"]()
        end,
        config = function()
            vim.cmd [[
                function OpenMarkdownPreview(url)
                    call g:OpenLink(a:url)
                endfunction
                let g:mkdp_browserfunc = 'OpenMarkdownPreview'
            ]]
        end,
    },
}
