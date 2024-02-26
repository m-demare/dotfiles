local utils = require('utils')
local req = utils.req
local unix = utils.unix

return {
    { 'neovim/nvim-lspconfig', config = req 'lsp' },
    {
        'rafamadriz/friendly-snippets',
        dependencies = { 'L3MON4D3/LuaSnip', 'nvimdev/lspsaga.nvim'},
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
        config = req('config.cmp'),
        lazy = true,
    },
    { 'RRethy/vim-illuminate', lazy = true, },
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
