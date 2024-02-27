local utils = require('utils')
local req = utils.req
local unix = utils.unix

return {
    {
        'neovim/nvim-lspconfig',
        dependencies =  'hrsh7th/cmp-nvim-lsp',
        config = function ()
            local nvim_lsp = require 'lspconfig'
            local cmp_nvim_lsp = require 'cmp_nvim_lsp'
            local servers = require('plugins.lsp.langs').for_current_os()

            local capabilities = cmp_nvim_lsp.default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            for _, lsp in ipairs(servers) do
                nvim_lsp[lsp.name].setup {
                    on_attach = function(client, bufnr)
                        require('plugins.lsp.keymaps').on_attach(client, bufnr)
                    end,
                    flags = {
                        debounce_text_changes = 150,
                    },
                    capabilities = capabilities,
                    cmd = lsp.cmd,
                    settings = lsp.settings,
                    filetypes = lsp.filetypes
                }
            end

        end },
    {
        'rafamadriz/friendly-snippets',
        dependencies = { 'L3MON4D3/LuaSnip', 'nvimdev/lspsaga.nvim' },
        event = 'InsertEnter *',
    },
    {
        'L3MON4D3/LuaSnip',
        dependencies = 'hrsh7th/nvim-cmp',
        lazy = true,
        build = unix
            and "make install_jsregexp"
            or nil,
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
        },
        config = req('plugins.lsp.cmp'),
        lazy = true,
    },
    {
        'RRethy/vim-illuminate',
        lazy = true,
        config = function()
            local servers = require('plugins.lsp.langs').for_current_os()

            vim.g.Illuminate_ftwhitelist = require('utils').reduce(servers, function (acc, s)
                for _, ft in ipairs(s.filetypes or {}) do
                    if not vim.tbl_contains(acc, ft) then table.insert(acc, ft) end
                end
                return acc
            end, {})
        end
    },
    {
        'nvimdev/lspsaga.nvim',
        opts = {
            ui = {
                devicon = false,
                code_action = "»",
                normal_bg = "NONE",
                title_bg = "NONE"
            },
            symbol_in_winbar = {
                enable = false,
            }
        },
    },
}
