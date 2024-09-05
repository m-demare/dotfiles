local HOME = vim.fn.expand "$HOME"
local sumneko_root_path = HOME .. "\\.config\\sumneko"
local sumneko_binary = HOME .. "\\.config\\sumneko\\bin\\lua-language-server"
local unix = require("utils").unix

local lualib = vim.api.nvim_get_runtime_file("", true)
table.insert(lualib, "/usr/share/awesome/lib")

local lss = {
    {
        name = "pyright",
        filetypes = { "python" },
        install_method = "npm",
        val = "pyright",
        os = { "win32", "unix" },
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    extraPaths= {
                        "~/localwork/simics/packages/simics-6.0.185/linux64/lib/python-py3/",
                        "~/localwork/simics/packages/simics-6.0.185/linux64/bin/py3",
                    },
                },
            },
        }
    },
    {
        name = "ts_ls",
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
        },
        install_method = "npm",
        val = "typescript typescript-language-server",
        os = { "win32", "unix" },
    },
    {
        name = "svelte",
        filetypes = { "svelte" },
        install_method = "npm",
        val = "svelte-language-server",
        os = { "win32", "unix" },
    },
    {
        name = "vimls",
        filetypes = { "vim" },
        install_method = "npm",
        val = "vim-language-server",
        os = { "win32", "unix" },
    },
    {
        name = "clangd",
        filetypes = { "c", "cpp" },
        install_method = "package_manager",
        val = "clang or lldb",
        os = { "unix" },
    },
    {
        name = "texlab",
        filetypes = { "tex" },
        install_method = "cargo",
        val = "--git https://github.com/latex-lsp/texlab.git --locked",
        os = { "unix" },
    },
    {
        name = "lua_ls",
        filetypes = { "lua" },
        install_method = "package_manager",
        val = "lua-language-server",
        os = { "unix", "win32" },
        cmd = (not unix) and { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" } or nil,
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                    special = { include = "require" },
                },
                diagnostics = {
                    globals = {
                        "vim",
                        "Isaac",
                        "Game",
                        "Vector",
                        "EntityType",
                        "EntityVariants",
                        "EntityCollisionClass",
                        "CacheFlag",
                        "ModCallbacks",
                        "EffectVariant",
                        "FamiliarVariant",
                        "LevelStage",

                        "awesome",
                        "client",
                        "root",
                        "screen",
                    },
                },
                workspace = {
                    library = lualib,
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    {
        name = "tailwindcss",
        filetypes = { "svelte" },
        install_method = "npm",
        val = "@tailwindcss/language-server",
        os = { "win32", "unix" },
    },
    {
        name = "rust_analyzer",
        fts = { "rust" },
        install_method = "other",
        os = { "unix" },
    },
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
        if isValid then retval[#retval + 1] = ls end
    end

    return retval
end

return {
    for_current_os = for_current_os,
}
