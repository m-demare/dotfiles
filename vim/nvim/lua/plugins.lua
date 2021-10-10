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
    use { 'ctrlpvim/ctrlp.vim' }
    use { 'preservim/nerdtree', opt=true, cmd={'NERDTreeToggle', 'NERDTreeVCS', 'NERDTreeFind'} }
    use { 'nvim-lualine/lualine.nvim' }
    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }
    use { 'norcalli/nvim-colorizer.lua' }

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

    -- JS
    use { 'pangloss/vim-javascript', ft={'js', 'jsx'} }
    use { 'leafgarland/typescript-vim', ft={'ts', 'tsx'} }
    use { 'MaxMEllon/vim-jsx-pretty', ft={'jsx', 'tsx'} }

    -- LSP
    use { 'neovim/nvim-lspconfig' }
    use { 'hrsh7th/nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'saadparwaiz1/cmp_luasnip' }
    use { 'L3MON4D3/LuaSnip' }
    use { 'RRethy/vim-illuminate' }

    if packer_bootstrap then
        require('packer').sync()
    end
end)


-- Settings

-- Git signs
require('gitsigns').setup()

-- Colors
vim.cmd 'colorscheme molokai'
if vim.fn.has('termguicolors') == 1 then
    vim.o.termguicolors = true
    require 'colorizer'.setup()
end

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



return packer
