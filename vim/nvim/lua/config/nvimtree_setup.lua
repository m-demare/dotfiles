local map  = require('utils').map

map('n', '<leader>tt', function ()
    require('nvim-tree').toggle(false, false)
end)
map('n', '\\t', function ()
    local repo = vim.fn.FugitiveWorkTree()
    if repo == '' then repo = nil end
    -- open it at the repo root, focused in current file
    require('nvim-tree').toggle(true, false, repo)
end)

