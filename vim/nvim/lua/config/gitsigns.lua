require('gitsigns').setup({
    on_attach = function (bufnr)
        local gs = package.loaded.gitsigns
        local function buf_noremap(mode, lhs, rhs, opts)
            local options = {noremap = true, silent = true}
            if opts then options = vim.tbl_extend('force', options, opts) end
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
        end
        buf_noremap('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
        buf_noremap('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})
        buf_noremap('n', '<leader>hs', "<cmd>lua package.loaded.gitsigns.stage_hunk()<CR>")
        buf_noremap('n', '<leader>hr', "<cmd>lua package.loaded.gitsigns.reset_hunk()<CR>")
        buf_noremap('n', '<leader>hS', "<cmd>lua package.loaded.gitsigns.stage_buffer()<CR>")
        buf_noremap('n', '<leader>hu', "<cmd>lua package.loaded.gitsigns.undo_stage_hunk()<CR>")
        buf_noremap('n', '<leader>hR', "<cmd>lua package.loaded.gitsigns.reset_buffer()<CR>")
        buf_noremap('n', '<leader>hp', "<cmd>lua package.loaded.gitsigns.preview_hunk()<CR>")
        buf_noremap('n', '<leader>hb', "<cmd>lua package.loaded.gitsigns.blame_line{full=true}<CR>")
        buf_noremap('n', '<leader>tb', "<cmd>lua package.loaded.gitsigns.toggle_current_line_blame()<CR>")
        buf_noremap('n', '<leader>hd', "<cmd>lua package.loaded.gitsigns.diffthis()<CR>")
        buf_noremap('n', '<leader>hD', "<cmd>lua package.loaded.gitsigns.diffthis('~')<CR>")
        buf_noremap('n', '<leader>td', "<cmd>lua package.loaded.gitsigns.toggle_deleted()<CR>")
    end
})

