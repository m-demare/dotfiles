local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    autocmd BufWritePost plugins.lua source <afile> | PackerInstall
  augroup end
]])

local packer = require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- General
    use { 'jiangmiao/auto-pairs' }
    use { 'nvim-lualine/lualine.nvim' }
    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }
    use { 'norcalli/nvim-colorizer.lua' }
    use { 'tpope/vim-endwise' }
    use { 'chentau/marks.nvim' }

    -- Navigation
    use { 'preservim/nerdtree',
        opt=true,
        cmd={'NERDTreeToggle', 'NERDTreeVCS', 'NERDTreeFind'}
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use { 'glepnir/dashboard-nvim' }
    use { 'andymass/vim-matchup' }

    -- Git
    use { 'tpope/vim-fugitive' }
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }

    -- Theme
    use { 'tomasr/molokai' }

    -- asm
    use { 'shirk/vim-gas', ft={'asm', 's'} }

    -- tex
    use { 'lervag/vimtex', ft={'tex'} }

    -- JS
    use { 'pangloss/vim-javascript', ft={'js', 'jsx'} }
    use { 'leafgarland/typescript-vim', ft={'ts', 'tsx'} }
    use { 'MaxMEllon/vim-jsx-pretty', ft={'jsx', 'tsx'} }

    -- LSP
    use { 'neovim/nvim-lspconfig' }
    -- use { 'hrsh7th/nvim-cmp' }
    -- use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'ms-jpq/coq_nvim', requires={ 'ms-jpq/coq.artifacts' }}
    -- use {
    --     'saadparwaiz1/cmp_luasnip',
    --     requires = { 'L3MON4D3/LuaSnip', 'rafamadriz/friendly-snippets' }
    -- }
    use { 'RRethy/vim-illuminate' }
    use { 'glepnir/lspsaga.nvim' }

    if packer_bootstrap then
        require('packer').sync()
    end
end)


-- Settings

-- require("luasnip/loaders/from_vscode").load()

-- marks
require('marks').setup{}

-- Git signs
require('gitsigns').setup()

-- Colors
vim.cmd 'colorscheme molokai'
if vim.fn.has('termguicolors') == 1 then
    vim.o.termguicolors = true
    require 'colorizer'.setup()
end

-- tex
vim.g.vimtex_view_method = 'zathura'

-- lualine
vim.o.showmode = false
require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'onedark',
        section_separators = '',
        component_separators = ''
    }
}

-- Dashboard
require('dashboard')

-- NERDTree
require('nerdtree')

-- Telescope
local function noremap(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

noremap('n', '<C-p>', '<cmd>Telescope git_files<CR>')
noremap('n', '<space>/', '<cmd>Telescope live_grep<CR>')

return packer
