return {
    {
        "tpope/vim-fugitive",
        lazy = false,
        keys = {
            { "<leader>gg", "<cmd>G<CR>" },
            { "<leader>gh", "<cmd>diffget //2<CR>" },
            { "<leader>gl", "<cmd>diffget //3<CR>" },
            { "<leader>gB", "<cmd>GBrowse<CR>" },
        },
    },
    { "tpope/vim-rhubarb" },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        opts = {
            update_debounce = 300,
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local bind = require("utils").bind
                local map = vim.keymap.set
                local nmap = bind(map, "n")

                nmap("]c", function()
                    if vim.wo.diff then return "]c" end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, buffer = bufnr })
                nmap("[c", function()
                    if vim.wo.diff then return "[c" end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, buffer = bufnr })

                nmap("<leader>hs", gs.stage_hunk, { buffer = bufnr })
                nmap("<leader>hr", gs.reset_hunk, { buffer = bufnr })
                nmap("<leader>hS", gs.stage_buffer, { buffer = bufnr })
                nmap("<leader>hu", gs.undo_stage_hunk, { buffer = bufnr })
                nmap("<leader>hR", gs.reset_buffer, { buffer = bufnr })
                nmap("<leader>hp", gs.preview_hunk, { buffer = bufnr })
                nmap("<leader>hb", bind(gs.blame_line, { full = true }), { buffer = bufnr })
                nmap("<leader>tb", gs.toggle_current_line_blame, { buffer = bufnr })
                nmap("<leader>hd", gs.diffthis, { buffer = bufnr })
                nmap("<leader>hD", bind(gs.diffthis, "~"), { buffer = bufnr })
                nmap("<leader>td", gs.preview_hunk_inline, { buffer = bufnr })

                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr })
                map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr })
            end,
        },
    },
}
