-- Colors
vim.g.sonokai_style = 'shusia'
vim.g.sonokai_transparent_background = vim.fn.has 'unix' and 2 or 0
vim.g.sonokai_current_word = "underline"
vim.cmd 'colorscheme sonokai'

local transparent_groups = {
    -- Already set by sonokai, but not working right now with sonokai_style=2:
    'Normal',
    'NonText',
    'EndOfBuffer',
    'CursorLine',
    --
    'TabLine',
    'TabLineFill'
}
for _, group in ipairs(transparent_groups) do
    vim.cmd('highlight ' .. group .. ' ctermfg=none guibg=none')
end
vim.cmd 'highlight! Visual guibg=#666666'

require('hlargs').setup {
    highlight= {
        fg= '#ef9062',
        italic=true,
        cterm = { italic=true }
    }
}
