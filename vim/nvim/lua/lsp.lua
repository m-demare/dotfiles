local nvim_lsp = require 'lspconfig'
local saga = require 'lspsaga'
local utils = require 'utils'
local map  = utils.map

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
    },
    clients = {
      buffers = { weight_adjust=.5 },
      tmux = { weight_adjust=.8 },
      tree_sitter = { weight_adjust=1.2 },
      lsp = { weight_adjust=2 }
    }
}
local coq = require 'coq'

map('i', '<Esc>', 'pumvisible() ? "\\<C-e><Esc>" : "\\<Esc>"', {expr=true})
map('i', '<C-c>', 'pumvisible() ? "\\<C-e><C-c>" : "\\<C-c>"', {expr=true})
map('i', '<BS>', 'pumvisible() ? "\\<C-e><BS>"  : "\\<BS>"', {expr=true})
map('i', '<Tab>', 'pumvisible() ? (complete_info().selected == -1 ? "\\<C-e><Tab>" : "\\<C-y>") : "\\<Tab>"', {expr=true})

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
map('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true })

MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return autopairs.esc('<c-e>') .. autopairs.autopairs_bs()
  else
    return autopairs.autopairs_bs()
  end
end
map('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true })

-- LSP settings

local on_attach = function(client, bufnr)
    -- Highlighting
    require 'illuminate'.on_attach(client)

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    map('n', 'gD', vim.lsp.buf.declaration, {buffer=bufnr})
    map('n', 'gd', vim.lsp.buf.definition, {buffer=bufnr})
    map('n', 'gi', vim.lsp.buf.implementation, {buffer=bufnr})
    map('n', 'gr', vim.lsp.buf.references, {buffer=bufnr})
    map('n', 'gf', '<cmd>Lspsaga lsp_finder<CR>', {buffer=bufnr})
    map('n', 'gs', '<cmd>Lspsaga signature_help<CR>', {buffer=bufnr})
    map("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>", {buffer=bufnr})
    map('n', 'K', '<cmd>Lspsaga hover_doc<CR>', {buffer=bufnr})
    -- map('n', '<leader>rn', '<cmd>Lspsaga rename<CR>', {buffer=bufnr})
    map('n', '<leader>rn', vim.lsp.buf.rename, {buffer=bufnr})
    -- map('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', {buffer=bufnr})
    map('n', '<leader>ca', vim.lsp.buf.code_action, {buffer=bufnr})
    map('n', '[g', vim.diagnostic.goto_prev, {buffer=bufnr})
    map('n', ']g', vim.diagnostic.goto_next, {buffer=bufnr})
    map('n', '<leader>ff', vim.lsp.buf.formatting, {buffer=bufnr})

    print('Using ' .. client.name)
end

local servers = require('lsplangs').for_current_os()

vim.g.Illuminate_ftwhitelist = utils.reduce(servers, function (acc, s)
    for _, ft in ipairs(s.fts) do table.insert(acc, ft) end
    return acc
end, {})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp.name].setup (coq.lsp_ensure_capabilities {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
    settings = lsp.settings
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

