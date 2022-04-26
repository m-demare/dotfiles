local lss = {
    {
        name='pyright',
        fts={ 'python' },
        install_method='npm',
        val='pyright',
        os={'win32', 'unix'}
    },
    {
        name='tsserver',
        fts={ 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
        install_method='npm',
        val='typescript typescript-language-server',
        os={'win32', 'unix'}
    },
    {
        name='svelte',
        fts={ 'svelte' },
        install_method='npm',
        val='svelte-language-server',
        os={'win32', 'unix'}
    },
    {
        name='vimls',
        fts={ 'vim' },
        install_method='npm',
        val='vim-language-server',
        os={'win32', 'unix'}
    },
    {
        name='clangd',
        fts={ 'c', 'cpp' },
        install_method='package_manager',
        val='clang or lldb',
        os={'unix'}
    },
    {
        name='texlab',
        fts={ 'tex' },
        install_method='cargo',
        val='--git https://github.com/latex-lsp/texlab.git --locked',
        os={'unix'}
    },
    {
        name='sumneko_lua',
        fts={ 'lua' },
        install_method='package_manager',
        val='lua-language-server',
        os={'unix'},
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                },
                telemetry = {
                    enable = false
                }
            }
        }
    }
}

local function for_current_os()
    local retval = {}
    for _, ls in ipairs(lss) do
        local isValid = false
        for _, os in ipairs(ls.os) do
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

