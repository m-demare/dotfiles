local M = {}

function M.map(mode, l, r, opts, bufnr)
    opts = opts or {}
    opts.buffer = bufnr
    opts = vim.tbl_extend('force', {noremap=true, silent=true}, opts)
    vim.keymap.set(mode, l, r, opts)
end

function M.bind(fn, ...)
    local args = {...}
    return function(...)
        fn(unpack(args), ...)
    end
end

return M

