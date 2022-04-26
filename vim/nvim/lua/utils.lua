local M = {}

function M.map(mode, l, r, opts)
    opts = opts or {}
    opts = vim.tbl_extend('force', { silent=true }, opts)
    vim.keymap.set(mode, l, r, opts)
end

function M.bind(fn, ...)
    local args = {...}
    return function(...)
        fn(unpack(args), ...)
    end
end

function M.strict_bind(fn, ...)
    local args = {...}
    return function()
        fn(unpack(args))
    end
end

function M.reduce(list, fn, init)
    local acc = init
    for _, v in ipairs(list) do
        acc = fn(acc, v)
    end
    return acc
end

return M

