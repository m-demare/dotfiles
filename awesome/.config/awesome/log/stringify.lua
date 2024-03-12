local function spaces(n)
    return string.rep(' ', n)
end

local stringify

local function stringify_table(table, depth)
    local s = "{"
    for k, v in pairs(table) do
        s = s .. '\n' .. spaces(depth * 4) .. stringify(k, depth + 1) .. ' = ' .. stringify(v, depth + 1) .. ','
    end
    if #s>1 then s = s .. "\n" .. spaces((depth - 1) * 4) end
    s = s .. "}"
    return s
end

stringify = function (val, depth)
    local t = type(val)
    depth = depth or 1
    if t == "string" then return '"' .. val .. '"' end
    if t == "nil" then return "nil" end
    if t == "table" then return stringify_table(val, depth) end
    return tostring(val)
end

local function stringify_all(...)
    local unpack = unpack or table.unpack
    local args = {...}
    for k, v in ipairs(args) do
        args[k] = stringify(v)
    end
    return unpack(args)
end

return {
    stringify = stringify,
    stringify_all = stringify_all,
}
