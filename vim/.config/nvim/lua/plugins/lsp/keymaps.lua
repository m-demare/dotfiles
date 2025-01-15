local on_attach = function(client, bufnr)
    local map = vim.keymap.set

    require("illuminate").on_attach(client)
    local ts_picker = require("utils.telescope").picker

    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
    end

    local function toggle_hints()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end

    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", {
        buf = bufnr,
    })

    map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
    map("n", "gd", ts_picker "lsp_definitions", { buffer = bufnr })
    map("n", "<leader>gi", ts_picker "lsp_implementations", { buffer = bufnr })
    map("n", "gf", ts_picker "lsp_references", { buffer = bufnr })

    map("n", "gs", vim.lsp.buf.signature_help, { buffer = bufnr })
    map("i", "<c-s>", vim.lsp.buf.signature_help, { buffer = bufnr })
    map("n", "K", vim.lsp.buf.hover, { buffer = bufnr })

    map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })

    map("n", "go", vim.diagnostic.open_float, { buffer = bufnr })
    map("n", "[g", vim.diagnostic.goto_prev, { buffer = bufnr })
    map("n", "]g", vim.diagnostic.goto_next, { buffer = bufnr })
    map({ "n", "v" }, "<leader>fo", vim.lsp.buf.format, { buffer = bufnr })

    map("n", "<leader>th", toggle_hints, { buffer = bufnr })

    local rounded = { border = "rounded" }
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, rounded)
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, rounded)
    vim.diagnostic.config { float = rounded }
end

return {
    on_attach = on_attach,
}
