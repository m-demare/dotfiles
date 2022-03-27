local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap
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
    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }
    use { 'tpope/vim-endwise' }
    use { 'tpope/vim-repeat' }
    use { 'chentau/marks.nvim', config = [[require('marks').setup {}]] }
    use { 'tpope/vim-sleuth' }
    use {
        'norcalli/nvim-colorizer.lua',
        ft = {'css', 'scss'},
        config = [[require('colorizer').setup()]]
    }

    -- Status line
    use { 'nvim-lualine/lualine.nvim', config = [[require 'config.statusline']] }
    use {
        "SmiteshP/nvim-gps",
        requires = "nvim-treesitter/nvim-treesitter"
    }

    -- Navigation
    use { 'preservim/nerdtree',
        opt=true,
        cmd={'NERDTreeToggle', 'NERDTreeVCS', 'NERDTreeFind'},
        setup = [[require 'config.nerdtree']]
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function ()
            require('config.telescope').setup()
        end
    }
    use {
        'nvim-telescope/telescope-smart-history.nvim',
        requires = { "tami5/sqlite.lua" }
    }
    use {
        'glepnir/dashboard-nvim',
        config = function ()
            require 'config.dashboard'
        end
    }
    use { 'andymass/vim-matchup' }
    use {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
        setup = [[vim.api.nvim_set_keymap('n', '<leader>u', '<cmd>UndotreeToggle<CR>', {noremap = true, silent = true})]]
    }

    -- Git
    use {
        'tpope/vim-fugitive',
        setup = [[vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>G<CR>', {noremap = true, silent = true})]]
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function ()
            require('config.gitsigns')
        end
    }

    -- Theme
    use { 'sainnhe/sonokai' }
    use { '~/localwork/hlargs.nvim', config = [[ require("hlargs").setup {} ]] }

    -- asm
    use {
        'shirk/vim-gas',
        ft={'asm', 's'},
        config = function ()
            vim.cmd [[
                au BufRead,BufNewFile *.asm set filetype=gas
                au BufRead,BufNewFile *.asm syn region Comment start=/;/ end=/$/
            ]]
        end
    }

    -- tex
    use { 'lervag/vimtex', ft={'tex'}, config=[[vim.g.vimtex_view_method = 'zathura']] }

    -- LSP
    use { 'neovim/nvim-lspconfig' }
    use { 'ms-jpq/coq_nvim', requires={ 'ms-jpq/coq.artifacts' } }
    use { 'RRethy/vim-illuminate' }
    use { 'tami5/lspsaga.nvim' }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = [[ require("config.treesitter").setup() ]]
    }
    use { 'nvim-treesitter/playground' }

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

-- Colors
vim.g.sonokai_style = 'shusia'
vim.cmd 'colorscheme sonokai'

-- Installs
-- TODO vim.api.nvim_add_user_command() (nvim 0.7)
vim.cmd [[ command! InstallTSParsers lua require'config.treesitter'.install_parsers() ]]
vim.cmd [[ command! InstallLsps lua require'installLsps'() ]]


return packer
