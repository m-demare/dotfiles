local function spaces(n)
    return string.rep(' ', n)
end

local stringify

local function shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

local function stringify_table(t, depth, visited)
    visited = shallow_copy(visited)
    visited[t] = true

    local s = tostring(t) .. " {"
    for k, v in pairs(t) do
        s = s .. '\n' .. spaces(depth * 4) .. stringify(k, depth + 1, visited) .. ' = ' .. stringify(v, depth + 1, visited) .. ','
    end
    if #s>1 then s = s .. "\n" .. spaces((depth - 1) * 4) end
    s = s .. "}"
    return s
end

stringify = function (val, depth, visited)
    depth = depth or 1
    visited = visited or {}
    if visited[val] then return "<Circular " .. tostring(val) .. ">" end

    local t = type(val)
    if t == "string" then return '"' .. val .. '"' end
    if t == "nil" then return "nil" end
    if t == "table" then return stringify_table(val, depth, visited) end
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
