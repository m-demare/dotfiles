local nvim_lsp = require 'lspconfig'
local saga = require 'lspsaga'

vim.g.coq_settings = {
    auto_start = 'shut-up',
    keymap = {
        pre_select = true
    },
    display = {
        icons = {
            mode = 'none'
        }
    }
}
local coq = require "coq"

local on_attach = function(client, bufnr)

    -- Highlighting
    require 'illuminate'.on_attach(client)

    local function noremap(mode, lhs, rhs, opts)
      local options = {noremap = true, silent = true}
      if opts then options = vim.tbl_extend('force', options, opts) end
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
    end

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    noremap('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>')
    noremap('n', 'gd', '<cmd>Lspsaga preview_definition<CR>')
    noremap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    noremap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    noremap('n', 'gf', '<cmd>Lspsaga lsp_finder<CR>')
    noremap('n', 'gs', '<cmd>Lspsaga signature_help<CR>')
    noremap("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>")
    noremap('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
    noremap('n', '<leader>rn', '<cmd>Lspsaga rename<CR>')
    noremap('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>')
    noremap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    noremap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    noremap('n', '<leader>ff', '<cmd>lua vim.lsp.buf.formatting()<CR>')

    print('Using ' .. client.name)
end

local servers = require('lsplangs').for_current_os()

vim.g.Illuminate_ftblacklist = { 'nerdtree' }

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp.name].setup (coq.lsp_ensure_capabilities {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities
  })
end

-- Autocompletion

vim.o.completeopt = 'menuone,noselect'

saga.init_lsp_saga{
    error_sign = 'E',
    warn_sign = 'W',
    hint_sign = 'H',
    infor_sign = 'I',
    code_action_icon = "»",
    finder_action_keys = {
        open = "<CR>",
        vsplit = "s",
        split = "i",
        quit = "q",
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
    }
}

-- local luasnip = require 'luasnip'
-- local cmp = require 'cmp'
-- cmp.setup {
--   snippet = {
--     expand = function(args)
--       -- require('luasnip').lsp_expand(args.body)
--     end,
--   },
--   mapping = {
--     ['<C-p>'] = cmp.mapping.select_prev_item(),
--     ['<C-n>'] = cmp.mapping.select_next_item(),
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.close(),
--     ['<CR>'] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     },
--     ['<Tab>'] = function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       -- elseif luasnip.expand_or_jumpable() then
--       --   vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
--       else
--         fallback()
--       end
--     end,
--     ['<S-Tab>'] = function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       -- elseif luasnip.jumpable(-1) then
--       --   vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
--       else
--         fallback()
--       end
--     end,
--   },
--   sources = {
--     { name = 'nvim_lsp' },
--     -- { name = 'luasnip' },
--   },
-- }

