local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    autocmd BufWritePost plugins.lua source <afile> | PackerInstall
  augroup end
]])

local unix = require('utils').unix

local packer = require('packer').startup(function(use)
    use 'lewis6991/impatient.nvim'
    use 'wbthomason/packer.nvim'

    local req = function (file, fn)
        local str = 'require("' .. file .. '")'
        if fn then str = str .. '.' .. fn .. '({})' end
        return str
        -- Sadly: https://github.com/wbthomason/packer.nvim/issues/655
        --        https://github.com/wbthomason/packer.nvim/pull/402
    end

    -- General
    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }
    use { 'tpope/vim-repeat' }
    use { 'chentoast/marks.nvim', config = req('marks', 'setup') }
    use { 'tpope/vim-sleuth' }
    use { 'romainl/vim-qf' }
    use {
        'norcalli/nvim-colorizer.lua',
        ft = {'css', 'scss'},
        config = req('colorizer', 'setup'),
        disable=true
    }
    use {
        '~/localwork/attempt.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = req 'config.attempt'
    }
    use {
        'ggandor/leap.nvim',
        config = req('leap', 'add_default_mappings')
    }
    use {
        'windwp/nvim-autopairs',
        config = function ()
            require('nvim-autopairs').setup {
                disable_filetype = { "TelescopePrompt" , "vim" },
                enable_check_bracket_line = true,
            }
        end
    }

    -- Status line
    use { 'nvim-lualine/lualine.nvim', config = req 'config.statusline' }
    use {
        'SmiteshP/nvim-navic',
        requires = 'neovim/nvim-lspconfig'
    }

    -- Navigation
    use {
        'kyazdani42/nvim-tree.lua',
        requires = unix and 'kyazdani42/nvim-web-devicons' or nil,
        module = 'nvim-tree',
        setup = req 'config.nvimtree_setup',
        config = req 'config.nvimtree'
    }
    use {
        {
            'nvim-telescope/telescope.nvim',
            requires = {
                'nvim-lua/plenary.nvim',
                'nvim-telescope/telescope-smart-history.nvim',
                'nvim-telescope/telescope-ui-select.nvim',
                'nvim-telescope/telescope-fzf-native.nvim'
            },
            wants = {
                'plenary.nvim',
                'telescope-smart-history.nvim',
                'telescope-ui-select.nvim',
                'telescope-fzf-native.nvim'
            },
            module = 'telescope',
            cmd = 'Telescope',
            setup = req('config.telescope_setup', 'setup'),
            config = req 'config.telescope',
        },
        {
            'nvim-telescope/telescope-smart-history.nvim',
            requires = { "tami5/sqlite.lua" },
            after = 'telescope.nvim'
        },
        {
            'nvim-telescope/telescope-ui-select.nvim',
            after = 'telescope.nvim'
        },
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            run = unix and 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' or nil,
            after = 'telescope.nvim'
        }
    }
    use {
        'folke/persistence.nvim',
        event = "BufReadPre", -- start saving session when an actual file was opened
        module = "persistence",
        config = req("persistence", 'setup'),
        setup = req("config.persistence"),
    }
    use {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
        setup = [[vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', {silent = true})]]
    }
    use {
        'Canop/nvim-bacon',
        ft='rust',
        config = function ()
            require("bacon").setup {
                quickfix  = {
                    enabled = true,
                    event_trigger = true,
                }
            }
        end
    }

    -- Git
    use { 'tpope/vim-fugitive' }
    use { 'tpope/vim-rhubarb' }
    use {
        'lewis6991/gitsigns.nvim',
        config = req 'config.gitsigns'
    }

    -- Theme
    use {
        'sainnhe/sonokai',
        requires = '~/localwork/hlargs.nvim',
        config = req('config.theme') }
    use { 'eandrju/cellular-automaton.nvim',
        cmd = 'CellularAutomaton',
        commit = '679943b8e1e5ef79aaeeaf4b00782c52eb4e928f',
        setup = [[vim.keymap.set('n', '<leader>fml', '<cmd>CellularAutomaton make_it_rain<CR>', {silent = true})]]
    }

    -- tex
    use { 'lervag/vimtex', ft={'tex'}, config=[[vim.g.vimtex_view_method = 'zathura']] }

    -- LSP
    use { 'neovim/nvim-lspconfig', config = req 'lsp'}
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            { 'L3MON4D3/LuaSnip',               before = 'nvim-cmp' },
            { 'rafamadriz/friendly-snippets',   before = 'LuaSnip' },
            { 'hrsh7th/cmp-buffer',             after = 'nvim-cmp' },
            { 'hrsh7th/cmp-path',               after = 'nvim-cmp' },
            { 'saadparwaiz1/cmp_luasnip',       after = 'nvim-cmp' },
        },
        config = req('config.cmp'),
        event = 'InsertEnter *',
    }
    use { 'RRethy/vim-illuminate', module='illuminate' }
    use { 'nvimdev/lspsaga.nvim' }
    use { 'vxpm/ferris.nvim', ft='rust', config = req('ferris', 'setup'), }

    -- Debugging
    use {
        {
            'mfussenegger/nvim-dap',
            setup = req 'config.dap_setup',
            config = req 'config.dap',
            requires = 'jbyuki/one-small-step-for-vimkind',
            wants = 'one-small-step-for-vimkind',
            module = 'dap'
        },
        {
            'rcarriga/nvim-dap-ui',
            requires = 'nvim-dap',
            after = 'nvim-dap',
            config = req 'config.dapui',
            module = 'dapui'
        }
    }

    use {
        "rest-nvim/rest.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = [[vim.keymap.set('n', '<leader>sr', '<Plug>RestNvim', {silent = true})]],
        keys = '<leader>sr',
    }

    -- Treesitter
    use {
        {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
            config = req('config.treesitter', 'setup')
        },
        {
            'nvim-treesitter/nvim-treesitter-textobjects',
            requires = 'nvim-treesitter/nvim-treesitter'
        }
    }
    use { 'nvim-treesitter/playground', cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' } }

    if packer_bootstrap then
        require('packer').sync()
    end
end)


-- Installs
vim.api.nvim_create_user_command('InstallTSParsers', require'config.treesitter'.install_parsers, {force=true})
vim.api.nvim_create_user_command('InstallLsps', require'installLsps', {force=true})

return packer
