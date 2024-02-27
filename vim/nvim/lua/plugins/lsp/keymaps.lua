local on_attach = function(client, bufnr)
    local utils = require 'utils'
    local map  = vim.keymap.set

    require 'illuminate'.on_attach(client)

    if client.server_capabilities.documentSymbolProvider then
        require 'nvim-navic'.attach(client, bufnr)
    end

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

return {
  on_attach = on_attach,
}

