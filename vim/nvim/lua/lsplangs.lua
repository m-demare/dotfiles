local lss = {
    {
        name='pyright',
        install_method='npm',
        val='pyright',
        os={'win32', 'unix'}
    },
    {
        name='tsserver',
        install_method='npm',
        val='typescript typescript-language-server',
        os={'win32', 'unix'}
    },
    {
        name='vimls',
        install_method='npm',
        val='vim-language-server',
        os={'win32', 'unix'}
    },
    {
        name='ccls',
        install_method='package_manager',
        val='ccls',
        os={'unix'}
    },
    {
        name='texlab',
        install_method='cargo',
        val='--git https://github.com/latex-lsp/texlab.git --locked',
        os={'unix'}
    }
}

local function for_current_os()
    local retval = {}
    for _, ls in ipairs(lss) do
        isValid = false
        for __, os in ipairs(ls.os) do
            if vim.fn.has(os) == 1 then
                isValid = true
                break
            end
        end
        if isValid then retval[#retval+1] = ls end
    end

    return retval
end


return {
    for_current_os = for_current_os
}

