local M = {}

function M.map(mode, l, r, opts)
    opts = opts or {}
    opts = vim.tbl_extend('force', { silent=true }, opts)
    vim.keymap.set(mode, l, r, opts)
end

function M.bind(fn, ...)
    local args = {...}
    return function(...)
        return fn(unpack(args), ...)
    end
end

function M.strict_bind(fn, ...)
    local args = {...}
    return function()
        return fn(unpack(args))
    end
end

function M.call_bind(fn, prop, ...)
    local args = {...}
    return function ()
        return fn()[prop](unpack(args))
    end
end

function M.reduce(list, fn, init)
    local acc = init
    for _, v in ipairs(list) do
        acc = fn(acc, v)
    end
    return acc
end

function M.tbl_join(tbl, join_str)
    local retval = ''
    for i, v in ipairs(tbl) do
        if i>1 then
            retval = retval .. join_str
        end
        retval = retval .. v
    end
    return retval
end

return M

