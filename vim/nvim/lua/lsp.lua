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
    map('n', 'gf', '<cmd>Lspsaga finder ref<CR>', {buffer=bufnr})
    map('n', 'gs', vim.lsp.buf.signature_help, {buffer=bufnr})
    map("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>", {buffer=bufnr})
    map('n', 'K', '<cmd>Lspsaga hover_doc<CR>', {buffer=bufnr})
    map('n', '<leader>rn', vim.lsp.buf.rename, {buffer=bufnr})
    map({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {buffer=bufnr})
    map('n', '[g', vim.diagnostic.goto_prev, {buffer=bufnr})
    map('n', ']g', vim.diagnostic.goto_next, {buffer=bufnr})
    map({'n', 'v'}, '<leader>fo', utils.bind(vim.lsp.buf.format, { async = true }), {buffer=bufnr})

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
    })

    print('Using ' .. client.name)
end

local servers = require('lsplangs').for_current_os()

vim.g.Illuminate_ftwhitelist = utils.reduce(servers, function (acc, s)
    for _, ft in ipairs(s.filetypes or {}) do
        if not vim.tbl_contains(acc, ft) then table.insert(acc, ft) end
    end
    return acc
end, {})

local capabilities = cmp_nvim_lsp.default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp.name].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
    cmd = lsp.cmd,
    settings = lsp.settings,
    filetypes = lsp.filetypes
  }
end

saga.setup({
    ui = {
        devicon = false,
        code_action = "»",
        normal_bg = "NONE",
        title_bg = "NONE"
    },
    symbol_in_winbar = {
        enable = false,
    }
})

