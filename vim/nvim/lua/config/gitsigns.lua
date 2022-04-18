local map  = require('utils').map
local bind  = require('utils').bind

require('gitsigns').setup({
    on_attach = function (bufnr)
        local gs = package.loaded.gitsigns
        map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true}, bufnr)
        map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true}, bufnr)
        map('n', '<leader>hs', gs.stage_hunk, {}, bufnr)
        map('n', '<leader>hr', gs.reset_hunk, {}, bufnr)
        map('n', '<leader>hS', gs.stage_buffer, {}, bufnr)
        map('n', '<leader>hu', gs.undo_stage_hunk, {}, bufnr)
        map('n', '<leader>hR', gs.reset_buffer, {}, bufnr)
        map('n', '<leader>hp', gs.preview_hunk, {}, bufnr)
        map('n', '<leader>hb', bind(gs.blame_line, {full=true}), {}, bufnr)
        map('n', '<leader>tb', gs.toggle_current_line_blame, {}, bufnr)
        map('n', '<leader>hd', gs.diffthis, {}, bufnr)
        map('n', '<leader>hD', bind(gs.diffthis, '~'), {}, bufnr)
        map('n', '<leader>td', gs.toggle_deleted, {}, bufnr)
    end
})

