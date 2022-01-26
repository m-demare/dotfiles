local nvim_lsp = require 'lspconfig'
local saga = require 'lspsaga'

-- COQ settings
vim.g.coq_settings = {
    auto_start = 'shut-up',
    keymap = {
        jump_to_mark = '<c-q>',
        pre_select = true,
        recommended = false
    },
    display = {
        icons = {
            mode = 'none'
        }
    }
}
local coq = require "coq"

local function noremap(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
noremap('i', '<Esc>', 'pumvisible() ? "\\<C-e><Esc>" : "\\<Esc>"', {expr=true})
noremap('i', '<C-c>', 'pumvisible() ? "\\<C-e><C-c>" : "\\<C-c>"', {expr=true})
noremap('i', '<BS>', 'pumvisible() ? "\\<C-e><BS>"  : "\\<BS>"', {expr=true})
noremap('i', '<Tab>', 'pumvisible() ? (complete_info().selected == -1 ? "\\<C-e><Tab>" : "\\<C-y>") : "\\<Tab>"', {expr=true})

_G.MUtils= {}
local autopairs = require('nvim-autopairs')

MUtils.CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return autopairs.esc('<c-y>')
    else
      return autopairs.esc('<c-e>') .. autopairs.autopairs_cr()
    end
  else
    return autopairs.autopairs_cr()
  end
end
noremap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true })

MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return autopairs.esc('<c-e>') .. autopairs.autopairs_bs()
  else
    return autopairs.autopairs_bs()
  end
end
noremap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true })

-- LSP settings

local on_attach = function(client, bufnr)

    -- Highlighting
    require 'illuminate'.on_attach(client)

    local function buf_noremap(mode, lhs, rhs, opts)
      local options = {noremap = true, silent = true}
      if opts then options = vim.tbl_extend('force', options, opts) end
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
    end

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    buf_noremap('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>')
    buf_noremap('n', 'gd', '<cmd>Lspsaga preview_definition<CR>')
    buf_noremap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    buf_noremap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    buf_noremap('n', 'gf', '<cmd>Lspsaga lsp_finder<CR>')
    buf_noremap('n', 'gs', '<cmd>Lspsaga signature_help<CR>')
    buf_noremap("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>")
    buf_noremap('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
    buf_noremap('n', '<leader>rn', '<cmd>Lspsaga rename<CR>')
    buf_noremap('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>')
    buf_noremap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    buf_noremap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    buf_noremap('n', '<leader>ff', '<cmd>lua vim.lsp.buf.formatting()<CR>')

    print('Using ' .. client.name)
end

local servers = require('lsplangs').for_current_os()

vim.g.Illuminate_ftblacklist = { 'nerdtree', 'TelescopePrompt' }

local capabilities = vim.lsp.protocol.make_client_capabilities()
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

saga.init_lsp_saga{
    error_sign = 'E',
    warn_sign = 'W',
    hint_sign = 'H',
    infor_sign = 'I',
    code_action_icon = "»",
    finder_action_keys = {
        open = "<CR>",
        vsplit = "v",
        split = "s",
        quit = "q",
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
    }
}

