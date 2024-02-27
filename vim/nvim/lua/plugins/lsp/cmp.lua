local cmp = require 'cmp'
local luasnip = require('luasnip')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.filetype_extend("typescript", { "javascript" })
luasnip.config.setup {}

local icons = require('config.icons').cmp_icons
local function format(_, vim_item)
    vim_item.kind = (icons[vim_item.kind] or '') .. vim_item.kind
    return vim_item
end

local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function all_buffers()
    return vim.tbl_filter(vim.api.nvim_buf_is_loaded, vim.api.nvim_list_bufs())
end

cmp.setup({
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
            if cmp.visible() then
                cmp.confirm({select=true})
            elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' })
    }),
    sources = cmp.config.sources({
        {
            name = 'luasnip',
            entry_filter = function ()
                local ctx = require("cmp.config.context")
                return not luasnip.jumpable(1) and
                    not ctx.in_treesitter_capture("string") and not ctx.in_syntax_group("String") and
                    not ctx.in_treesitter_capture("comment") and not ctx.in_syntax_group("Comment")
            end
        },
        { name = 'nvim_lsp' },
    }, {
            {
                name = 'buffer',
                option = {
                    get_bufnrs = all_buffers,
                }
            },
    })
})


cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'luasnip' },
        {
            name = 'buffer',
            option = {
                get_bufnrs = all_buffers,
            }
        },
    })
})

-- cmp throws errors in dap buffers
local dap_fts = { 'dapui_watches', 'dap-repl' }
for _, ft in ipairs(dap_fts) do
    cmp.setup.filetype(ft, {
        enabled = function ()
            return false
        end,
        sources = {}
    })
end

cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))


local cmp_autocmds = vim.api.nvim_create_augroup('my_cmp_autocmds', { clear = true })

vim.api.nvim_create_autocmd("ModeChanged", {
    callback = function()
        -- Prevent snippet from expanding any further if I leave the region
        if luasnip.jumpable(1) and not luasnip.locally_jumpable(1) then
            luasnip.unlink_current()
        end
    end,
    group = cmp_autocmds,
})

