-- Colors
local unix = vim.fn.has 'unix'==1
vim.g.sonokai_style = 'shusia'
vim.g.sonokai_transparent_background = unix and 2 or 0
vim.g.sonokai_current_word = "underline"
vim.g.sonokai_better_performance = 1
local augroup = vim.api.nvim_create_augroup('SonokaiCustom', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function ()
      vim.api.nvim_set_hl(0, "TSVariableBuiltin", { link = "OrangeItalic" })
      vim.api.nvim_set_hl(0, "TSProperty", { link = "Fg" })
      vim.api.nvim_set_hl(0, "TSField", { link = "Green" })
      vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "Grey" })
        if unix then
            local transparent_groups = { 'CursorLine', 'TabLine', }
            for _, group in ipairs(transparent_groups) do
                vim.cmd('highlight ' .. group .. ' ctermbg=none guibg=none')
            end
        end
        vim.cmd 'highlight! Visual guibg=#666666'
    end,
    group = augroup
})
vim.cmd 'colorscheme sonokai'

require('hlargs').setup {
    hl_priority=150,
    highlight= {
        fg= '#ef9062',
        italic=true,
        cterm = { italic=true }
    }
}
