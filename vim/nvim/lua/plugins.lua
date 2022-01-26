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
    use { 'windwp/nvim-autopairs' }
    use { 'nvim-lualine/lualine.nvim' }
    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }
    use { 'norcalli/nvim-colorizer.lua' }
    use { 'tpope/vim-endwise' }
    use { 'tpope/vim-repeat' }
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
    use { 'sainnhe/sonokai' }

    -- asm
    use { 'shirk/vim-gas', ft={'asm', 's'} }

    -- tex
    use { 'lervag/vimtex', ft={'tex'} }

    -- LSP
    use { 'neovim/nvim-lspconfig' }
    use { 'ms-jpq/coq_nvim', requires={ 'ms-jpq/coq.artifacts' } }
    use { 'RRethy/vim-illuminate' }
    use { 'tami5/lspsaga.nvim' }

    -- Treesitter
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    if packer_bootstrap then
        require('packer').sync()
    end
end)


-- Settings

-- Auto pairs
require('nvim-autopairs').setup{
    disable_filetype = { "TelescopePrompt" , "vim" },
    map_bs = false,
    map_cr = false,
    enable_check_bracket_line = false
}

-- Marks
require('marks').setup{}

-- Git signs
require('gitsigns').setup()

-- Colors
vim.g.sonokai_style = 'shusia'
vim.cmd 'colorscheme sonokai'

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
        theme = 'sonokai',
        section_separators = '',
        component_separators = ''
    }
}

-- Dashboard
require 'dashboard'

-- NERDTree
require 'nerdtree'

-- Telescope
require('telescope-config').setup()

-- asm
vim.cmd [[
    au BufRead,BufNewFile *.asm set filetype=gas
    au BufRead,BufNewFile *.asm syn region Comment start=/;/ end=/$/
]]
-- Treesitter
require("treesitter").setup()


-- Installs
require("installs")


return packer
