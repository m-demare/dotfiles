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
    use { 'windwp/nvim-autopairs' }
    use { 'tpope/vim-commentary' }
    use { 'tpope/vim-surround' }
    use { 'tpope/vim-endwise' }
    use { 'tpope/vim-repeat' }
    use { 'chentau/marks.nvim', config = req('marks', 'setup') }
    use { 'tpope/vim-sleuth' }
    use {
        'norcalli/nvim-colorizer.lua',
        ft = {'css', 'scss'},
        config = req('colorizer', 'setup'),
        disable=true
    }

    -- Status line
    use { 'nvim-lualine/lualine.nvim', config = req 'config.statusline' }
    use {
        "SmiteshP/nvim-gps",
        requires = "nvim-treesitter/nvim-treesitter"
    }

    -- Navigation
    use { 'preservim/nerdtree',
        opt=true,
        cmd={'NERDTreeToggle', 'NERDTreeVCS', 'NERDTreeFind'},
        setup = req 'config.nerdtree'
    }
    use {
        {
            'nvim-telescope/telescope.nvim',
            requires = {
                'nvim-lua/plenary.nvim',
                'nvim-telescope/telescope-smart-history.nvim'
            },
            wants = {
                'plenary.nvim',
                'telescope-smart-history.nvim'
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
        }
    }
    use { 'glepnir/dashboard-nvim', config = req 'config.dashboard' }
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
        config = req 'config.gitsigns'
    }

    -- Theme
    use { 'sainnhe/sonokai' }
    use { '~/localwork/hlargs.nvim', config = req('hlargs', 'setup') }

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
    use { 'RRethy/vim-illuminate', module='illuminate' }
    use { 'tami5/lspsaga.nvim' }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = req('config.treesitter', 'setup')
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
vim.g.sonokai_transparent_background = 1
vim.g.sonokai_current_word = "underline"
vim.cmd 'colorscheme sonokai'

local transparent_groups = {
    -- Already set by sonokai:
    -- 'Normal',
    -- 'NonText',
    -- 'EndOfBuffer'
    'TabLine',
    'TabLineFill'
}
for _, group in ipairs(transparent_groups) do
    vim.cmd('highlight ' .. group .. ' ctermfg=none guibg=none')
end
vim.cmd 'highlight! Visual guibg=#666666'

-- Installs
vim.api.nvim_create_user_command('InstallTSParsers', require'config.treesitter'.install_parsers, {force=true})
vim.api.nvim_create_user_command('InstallLsps', require'installLsps', {force=true})

return packer
