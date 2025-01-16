local M = {}

local treesitter_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix

local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt

function M.name(shortcut, description)
    return { trig = shortcut, desc = description }
end

local function escape(str, chars)
    for _, ch in ipairs(chars) do
        str = str:gsub(ch, ch .. ch)
    end
    return str
end

function M.var(expr_query, query_lang, keywords, trig)
    trig = trig or ".var"
    return treesitter_postfix({
        reparseBuffer = "live",
        trig = trig,
        matchTSNode = {
            query = expr_query,
            query_lang = query_lang,
        },
    }, {
        d(1, function(_, parent)
            local env = parent.snippet.env
            if not env.LS_TSMATCH then return sn(nil, t(trig)) end

            local nodes = { i(1, "foo"), i(2) }
            -- If there are multiple keywords, add a choice node for them
            if type(keywords) == "table" then
                nodes = { i(2, "foo"), i(3) }
                local kw_nodes = vim.tbl_map(function (kw)
                    return t(kw .. " ")
                end, keywords)
                table.insert(nodes, 1, c(1, kw_nodes))
            end

            local node_content = escape(table.concat(env.LS_TSMATCH, "\n"), { "{", "}" })
            return sn(
                nil,
                fmt(
                    ("%s{} = %s;\n{}"):format(
                        type(keywords) == "nil" and '' or
                        (type(keywords) == "string" and (keywords .. ' ') or "{}"),
                        node_content
                    ),
                    nodes
                )
            )
        end),
    })
end

setmetatable(M, {
    __call = function() end,
})

return M
