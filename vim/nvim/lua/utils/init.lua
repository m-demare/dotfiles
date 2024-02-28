local M = {}

function M.bind(fn, ...)
    local args = { ... }
    return function(...)
        return fn(unpack(args), ...)
    end
end

function M.strict_bind(fn, ...)
    local args = { ... }
    return function()
        return fn(unpack(args))
    end
end

function M.call_bind(fn, prop, ...)
    local args = { ... }
    return function()
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
    local retval = ""
    for i, v in ipairs(tbl) do
        if i > 1 then retval = retval .. join_str end
        retval = retval .. v
    end
    return retval
end

function M.req(file, fn)
    return function()
        local mod = require(file)
        if fn then mod[fn] {} end
    end
end

function M.visual_selection()
    local saved_reg = vim.fn.getreg "v"
    vim.cmd [[noautocmd sil norm "vy]]
    local sel = vim.fn.getreg "v"
    vim.fn.setreg("v", saved_reg)
    return sel
end

M.unix = vim.fn.has "unix" == 1

return M
