local HOME = vim.fn.expand('$HOME')
local sumneko_root_path = HOME .. "\\.config\\sumneko"
local sumneko_binary =  HOME .. "\\.config\\sumneko\\bin\\lua-language-server"

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
        os={'unix', 'win32'},
        cmd= vim.fn.has("unix") == 0 and {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"} or nil,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                    special = {include='require'}
                },
                diagnostics = {
                    globals = { 'vim',
                        'Isaac', 'Game', 'Vector',
                        'EntityType', 'EntityVariants', 'EntityCollisionClass',
                        'CacheFlag', 'ModCallbacks', 'EffectVariant',
                        'FamiliarVariant', 'LevelStage' }
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false
                }
            }
        }
    },
    {
        name='tailwindcss',
        fts={ 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte' },
        install_method='npm',
        val='@tailwindcss/language-server',
        os={'win32', 'unix'}
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

