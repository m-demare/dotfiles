local utils = require "config.snippets.utils"
local name = utils.name
local var = utils.var

local expr_query = [[
    [
        (ternary_expression)
        (call_expression)
        (member_expression)
        (identifier)
        (object)
        (parenthesized_expression)
        (subscript_expression)
        (binary_expression)
        (unary_expression)
    ] @prefix
]]

local stmt_query = [[
    [
        (if_statement)
        (expression_statement)
        (return_statement)
        (lexical_declaration)
        (variable_declaration)
    ] @prefix
]]

-- stylua: ignore
return function (ls, ft)
    ft = ft or "javascript"
    local query_lang = vim.treesitter.language.get_lang(ft)

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
            name(abrev, "console." .. func),
            fmt("console." .. func .. "({});", { i(1) })
        )
    end

    local function iter_func(func, cb_args, other_args)
        cb_args = cb_args or { "el" }
        other_args = other_args or {}
        local args_str = ("{}"):rep(#cb_args, ", ")
        local other_args_str = (", {}"):rep(#other_args)

        local snip_nodes = {}
        for idx, arg in ipairs(cb_args) do
            table.insert(snip_nodes, i(idx, arg))
        end

        table.insert(snip_nodes, i(#cb_args + #other_args + 1))

        for idx, arg in ipairs(other_args) do
            table.insert(snip_nodes, i(#cb_args + idx, arg))
        end

        return s(
            name("." .. func, func),
            fmt("." .. func .. "((" .. args_str .. ") => {}" .. other_args_str .. ")", snip_nodes)
        )
    end

    ls.add_snippets(ft, {
        console_func("cl", "log"),
        console_func("cd", "debug"),
        console_func("ci", "info"),
        console_func("cw", "warn"),
        console_func("ce", "error"),
        s(
            name("cv", "log variable"),
            fmta([[console.log("<var>:", <var_rep>);]], { var = i(1), var_rep = rep(1) })
        ),

        s(
            name("fun", "function"),
            fmta([[function <name>(<args>){<body>}]], { name = i(1), args = i(2), body = i(0) })
        ),
        s(
            name("afun", "async function"),
            fmta([[async function <name>(<args>){<body>}]], { name = i(1), args = i(2), body = i(0) })
        ),
        s(
            name("fan", "anonymous function"),
            fmta([[function (<args>){<body>}]], { args = i(1), body = i(0) })
        ),
        s(
            name("afan", "async anonymous function"),
            fmta([[async function (<args>){<body>}]], { args = i(1), body = i(0) })
        ),
        s(
            name("lam", "lambda"),
            fmta([[(<args>) =>> <body>]], { args = i(1), body = i(0) })
        ),
        s(
            name("alam", "lambda"),
            fmta([[async (<args>) =>> <body>]], { args = i(1), body = i(0) })
        ),

        s(
            name("for", "for(let i = 0; i < ...; i++)"),
            fmta("for (let <i> = 0; <i_rep> << <limit>; <i_rep>++){\n\t<body>\n}",
                { i = i(1, "i"), i_rep = rep(1), limit = i(2, "arr.length"), body = i(0) })
        ),
        s(
            name("fore", "for(const el of arr)"),
            fmta("for (const <el> of <arr>){\n\t<body>\n}",
                { el = i(1, "el"), arr = i(2, "arr"), body = i(0) })
        ),
        s(
            name("forin", "for(const i in arr)"),
            fmta("for (const <i> in <arr>){\n\tconst <el> = <arr_rep>[<i_rep>];\n\t<body>\n}",
                { i = i(1, "i"), i_rep = rep(1), arr = i(2, "arr"), arr_rep = rep(2), el = i(3, "el"), body = i(0) })
        ),

        s(
            name("int", "setInterval"),
            fmta("setInterval(() =>> {<body>}, <time>)",
                { body = i(2), time = i(1, "1000") })
        ),
        s(
            name("tim", "setTimeout"),
            fmta("setTimeout(() =>> {<body>}, <time>)",
                { body = i(2), time = i(1, "1000") })
        ),

        s(
            name("tc", "try/catch"),
            fmt("try {{\n\t{}\n}} catch (e) {{\n\t\n}}", { i(0) })
        ),
        treesitter_postfix({
            wordTrig = false,
            reparseBuffer = "live",
            trig = ".try",
            matchTSNode = {
                query = stmt_query,
                query_lang = query_lang,
            },
        },{
                d(1, function(_, parent)
                    local env = parent.snippet.env
                    if not env.LS_TSMATCH then return sn(nil, t('.try')) end
                    local node_content = table.concat(env.LS_TSMATCH, '\n')
                    local replaced_content = ("try {{\n\t%s\n}} catch (e) {{\n\t{}\n}}"):format(node_content)
                    return sn(nil, fmt(replaced_content, { i(1) }))
                end)
            }),

        treesitter_postfix({
            wordTrig = false,
            reparseBuffer = "live",
            trig = ".await",
            matchTSNode = {
                query = expr_query,
                query_lang = query_lang,
            },
        },{
                f(function(_, parent)
                    local env = parent.snippet.env
                    if not env.LS_TSMATCH then return sn(nil, t('.await')) end
                    local node_content = table.concat(env.LS_TSMATCH, '\n')
                    local replaced_content = ("await %s;"):format(node_content)
                    return vim.split(replaced_content, "\n", { trimempty = false })
                end)
            }),

        var(expr_query, query_lang, { 'let', 'const', 'var' }, '.var'),
        var(expr_query, query_lang, nil, '.put'),

        iter_func('map'),
        iter_func('filter'),
        iter_func('some'),
        iter_func('every'),
        iter_func('find'),
        iter_func('findIndex'),
        iter_func('forEach', {'el', 'i'}),
        iter_func('reduce', {'acc', 'curr', 'i'}, {'initial'}),
        iter_func('reduceRight', {'acc', 'curr', 'i'}, {'initial'}),
    })
end
