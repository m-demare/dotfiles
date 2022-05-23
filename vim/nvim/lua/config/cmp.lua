local cmp = require 'cmp'
local luasnip = require('luasnip')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

require("luasnip.loaders.from_vscode").lazy_load()

local icons = {}

if vim.fn.has("unix") == 1 then
    icons = {
        Text = "   ",
        Method = "  ",
        Function = "  ",
        Constructor = "  ",
        Variable = "  ",
        Class = "  ",
        Interface = "  ",
        Struct = "  ",
        Module = "  ",
        Field = " ﰠ ",
        Property = " ﰠ ",
        Unit = "  ",
        Value = "  ",
        Keyword = "  ",
        Snippet = "  ",
        Color = "  ",
        File = "  ",
        Reference = "  ",
        Folder = "  ",
        Enum = "  ",
        EnumMember = "  ",
        Constant = " ﲀ ",
        Event = "  ",
        Operator = "  ",
        TypeParameter = "  ",
    }
end

local function format(_, vim_item)
    vim_item.kind = (icons[vim_item.kind] or '') .. vim_item.kind
    return vim_item
end

local function has_words_before ()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    completion = { completeopt = 'menu,menuone' },
    formatting = {
        format = format,
    },
    preselect = cmp.PreselectMode.Item,
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif cmp.visible() then
                cmp.confirm({ select = true })
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's', 'c' }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<CR>'] = function(fallback)
            fallback()
        end
    }),
    sources = cmp.config.sources({
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
    }, {
        { name = 'buffer' },
    })
})

cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'luasnip' },
        { name = 'buffer' },
    })
})

cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

