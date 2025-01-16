local ft = "lua"
local utils = require "config.snippets.utils"
local name = utils.name
local var = utils.var

local expr_query = [[
    [
        (identifier)
        (function_call)
        (dot_index_expression)
        (bracket_index_expression)
        (table_constructor)
        (parenthesized_expression)
        (binary_expression)
        (unary_expression)
        (string)
    ] @prefix
]]

-- stylua: ignore
return function (ls)
    require("luasnip.session.snippet_collection").clear_snippets(ft)

    local s = ls.snippet
    local sn = ls.snippet_node
    local isn = ls.indent_snippet_node
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node
    local d = ls.dynamic_node
    local r = ls.restore_node
    local events = require("luasnip.util.events")
    local ai = require("luasnip.nodes.absolute_indexer")
    local extras = require("luasnip.extras")
    local l = extras.lambda
    local rep = extras.rep
    local p = extras.partial
    local m = extras.match
    local n = extras.nonempty
    local dl = extras.dynamic_lambda
    local fmt = require("luasnip.extras.fmt").fmt
    local fmta = require("luasnip.extras.fmt").fmta
    local conds = require("luasnip.extras.expand_conditions")
    local postfix = require("luasnip.extras.postfix").postfix
    local matches = require("luasnip.extras.postfix").matches
    local treesitter_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix
    local types = require("luasnip.util.types")
    local parse = require("luasnip.util.parser").parse_snippet
    local ms = ls.multi_snippet
    local k = require("luasnip.nodes.key_indexer").new_key

    local function console_func(abrev, func)
        return s(
            name(abrev, func),
            fmt(("%s({})"):format(func), { i(1) })
        )
    end

    ls.add_snippets(ft, {
        console_func("cl", "print"),
        s(
            name("cv", "log variable"),
            fmta([[print("<var>:", <var_rep>)]], { var = i(1), var_rep = rep(1) })
        ),

        s(
            name("fun", "function"),
            fmta("function <name>(<args>)\n\t<body>\nend", { name = i(1), args = i(2), body = i(0) })
        ),
        s(
            name("lfun", "local function"),
            fmta("local function <name>(<args>)\n\t<body>\nend", { name = i(1), args = i(2), body = i(0) })
        ),

        -- loop snippets are provided by lsp

        var(expr_query, ft, 'local', '.var'),
        var(expr_query, ft, nil, '.put'),
    })
end
