local ft = "rust"
local utils = require "config.snippets.utils"
local name = utils.name
local var = utils.var

local expr_query = [[
    [
        (identifier)
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
            fmt(('%s!("{}");'):format(func), { i(1) })
        )
    end

    local function iter_func(func, cb_args, other_args)
        cb_args = cb_args or { "el" }
        other_args = other_args or {}
        local args_str = ("{}"):rep(#cb_args, ", ")
        local other_args_str = ("{}, "):rep(#other_args)

        local snip_nodes = {}
        for idx, arg in ipairs(other_args) do
            table.insert(snip_nodes, i(idx, arg))
        end

        for idx, arg in ipairs(cb_args) do
            table.insert(snip_nodes, i(#other_args + idx, arg))
        end

        table.insert(snip_nodes, i(#cb_args + #other_args + 1))

        return s(
            name("." .. func, func),
            fmt("." .. func .. "(" .. other_args_str .. "|" .. args_str .. "| {}" .. ")", snip_nodes)
        )
    end
    ls.add_snippets(ft, {
        console_func("cl", "println"),
        console_func("ce", "eprintln"),
        s(
            name("cv", "log variable"),
            fmta([[dbg!(<var>)]], { var = i(1) })
        ),

        s(
            name("fun", "function"),
            fmta("fn <name>(<args>){\n\t<body>\n}", { name = i(1), args = i(2), body = i(0) })
        ),
        s(
            name("lam", "lambda"),
            fmta([[|<args>| <body>]], { args = i(1), body = i(0) })
        ),

        s(
            name("for", "for i in 0 .. v.len()"),
            fmta("for <i> in 0 .. <limit> {\n\t<body>\n}",
                { i = i(1, "i"), limit = i(2, "v.len()"), body = i(0) })
        ),
        s(
            name("for", "for i in v"),
            fmta("for <i> in <iter> {\n\t<body>\n}",
                { i = i(1, "i"), iter = i(2, "v"), body = i(0) })
        ),

        var(expr_query, ft, { 'let', 'let mut'}, '.var'),
        var(expr_query, ft, nil, '.put'),

        iter_func('map'),
        iter_func('filter'),
        iter_func('any'),
        iter_func('all'),
        iter_func('find'),
        iter_func('position'),
        iter_func('for_each', {'el', 'i'}),
        iter_func('reduce', {'acc', 'curr' } ),
        iter_func('fold', {'acc', 'curr' }, { 'initial' }),
    })
end
