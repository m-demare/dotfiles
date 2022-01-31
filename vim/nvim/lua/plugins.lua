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
require('gitsigns').setup({
    on_attach = function (bufnr)
        local gs = package.loaded.gitsigns
        local function buf_noremap(mode, lhs, rhs, opts)
            local options = {noremap = true, silent = true}
            if opts then options = vim.tbl_extend('force', options, opts) end
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
        end
        buf_noremap('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
        buf_noremap('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})
        buf_noremap('n', '<leader>hs', "<cmd>lua package.loaded.gitsigns.stage_hunk()<CR>")
        buf_noremap('n', '<leader>hr', "<cmd>lua package.loaded.gitsigns.reset_hunk()<CR>")
        buf_noremap('n', '<leader>hS', "<cmd>lua package.loaded.gitsigns.stage_buffer()<CR>")
        buf_noremap('n', '<leader>hu', "<cmd>lua package.loaded.gitsigns.undo_stage_hunk()<CR>")
        buf_noremap('n', '<leader>hR', "<cmd>lua package.loaded.gitsigns.reset_buffer()<CR>")
        buf_noremap('n', '<leader>hp', "<cmd>lua package.loaded.gitsigns.preview_hunk()<CR>")
        buf_noremap('n', '<leader>hb', "<cmd>lua package.loaded.gitsigns.blame_line{full=true}<CR>")
        buf_noremap('n', '<leader>tb', "<cmd>lua package.loaded.gitsigns.toggle_current_line_blame()<CR>")
        buf_noremap('n', '<leader>hd', "<cmd>lua package.loaded.gitsigns.diffthis()<CR>")
        buf_noremap('n', '<leader>hD', "<cmd>lua package.loaded.gitsigns.diffthis('~')<CR>")
        buf_noremap('n', '<leader>td', "<cmd>lua package.loaded.gitsigns.toggle_deleted()<CR>")
    end
})

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
