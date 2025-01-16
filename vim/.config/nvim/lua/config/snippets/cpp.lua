local ft = "cpp"
local utils = require "config.snippets.utils"
local name = utils.name
local var = utils.var

local expr_query = [[
    [
        (call_expression)
        (identifier)
        (template_function)
        (subscript_expression)
        (field_expression)
        (user_defined_literal)
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
            fmt(("std::%s << {} << std::endl;"):format(func), { i(1) })
        )
    end

    ls.add_snippets(ft, {
        console_func("cl", "cout"),
        console_func("ce", "cerr"),
        s(
            name("cv", "log variable"),
            fmta([[std::cout <<<< "<var>: " <<<< <var_rep> <<<< std::endl;]], { var = i(1), var_rep = rep(1) })
        ),

        s(
            name("for", "for(int i = 0; i < ...; i++)"),
            fmta("for (int <i> = 0; <i_rep> << <limit>; <i_rep>++){\n\t<body>\n}",
                { i = i(1, "i"), i_rep = rep(1), limit = i(2, "v.size()"), body = i(0) })
        ),
        s(
            name("fore", "for(el : v)"),
            fmta("for (<signature> <el> : <arr>){\n\t<body>\n}",
                { signature = c(1, { t("auto"), t("auto const&") }), el = i(2, "el"), arr = i(3, "v"), body = i(0) })
        ),

        s(
            name("tc", "try/catch"),
            fmt("try {{\n\t{}\n}} catch (const std::exception &e) {{\n\t\n}}", { i(0) })
        ),

        var(expr_query, ft, 'auto', '.var'),
        var(expr_query, ft, nil, '.put'),

        treesitter_postfix({
            wordTrig = false,
            reparseBuffer = "live",
            trig = ".mv",
            matchTSNode = {
                query = expr_query,
                query_lang = ft
            },
        },{
                f(function(_, parent)
                    local env = parent.snippet.env
                    if not env.LS_TSMATCH then return sn(nil, t('.mv')) end
                    local node_content = table.concat(env.LS_TSMATCH, '\n')
                    local replaced_content = ("std::move(%s)"):format(node_content)
                    return vim.split(replaced_content, "\n", { trimempty = false })
                end)
            })

    })
end
