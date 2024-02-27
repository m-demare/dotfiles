local unix = require('utils').unix

local function get_npm_path()
    if unix then
        return 'npm'
    else
        return vim.fn.expand('~/AppData/Roaming/nvm/v16.17.0/npm')
    end
end

local function install()
    local lsplangs = require('plugins.lsp.langs').for_current_os()
    for _, ls in ipairs(lsplangs) do
        local silence = unix and ' >> /dev/null' or ''
        if ls.install_method == "npm" then
            local npm = get_npm_path()
            vim.cmd('!' .. npm .. ' i -g ' .. ls.val .. silence)
        elseif ls.install_method == "cargo" then
            vim.cmd('!cargo install ' .. ls.val)
        elseif ls.install_method == "package_manager" then
            print("Install " .. ls.val .. " with your package manager")
        end
    end
    print("Done!")
end

return install
