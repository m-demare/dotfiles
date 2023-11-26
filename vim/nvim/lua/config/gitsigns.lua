local map  = require('utils').map
local bind = require('utils').bind

require('gitsigns').setup({
    update_debounce = 300,
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, { expr = true, buffer = bufnr })
        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, { expr = true, buffer = bufnr })

        map('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr })
        map('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr })
        map('n', '<leader>hS', gs.stage_buffer, { buffer = bufnr })
        map('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr })
        map('n', '<leader>hR', gs.reset_buffer, { buffer = bufnr })
        map('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr })
        map('n', '<leader>hb', bind(gs.blame_line, { full = true }), { buffer = bufnr })
        map('n', '<leader>tb', gs.toggle_current_line_blame, { buffer = bufnr })
        map('n', '<leader>hd', gs.diffthis, { buffer = bufnr })
        map('n', '<leader>hD', bind(gs.diffthis, '~'), { buffer = bufnr })
        map('n', '<leader>td', gs.toggle_deleted, { buffer = bufnr })

        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr })
        map({'o', 'x'}, 'ah', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr })
    end
})
