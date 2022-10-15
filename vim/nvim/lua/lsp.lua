local nvim_lsp = require 'lspconfig'
local saga = require 'lspsaga'
local utils = require 'utils'
local map  = utils.map
local cmp_nvim_lsp = require 'cmp_nvim_lsp'

-- LSP settings

local on_attach = function(client, bufnr)
    -- Highlighting
    require 'illuminate'.on_attach(client)

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    map('n', 'gD', vim.lsp.buf.declaration, {buffer=bufnr})
    map('n', 'gd', vim.lsp.buf.definition, {buffer=bufnr})
    map('n', '<leader>gi', vim.lsp.buf.implementation, {buffer=bufnr})
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
    map('n', '<leader>fo', utils.bind(vim.lsp.buf.format, { async = true }), {buffer=bufnr})

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
  nvim_lsp[lsp.name].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities),
    cmd = lsp.cmd,
    settings = lsp.settings
  }
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

