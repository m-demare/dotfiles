local function get_npm_path()
    if vim.fn.has("unix") == 1 then
        return vim.fn.expand('~/.nvm/versions/node/$vim_node_version/bin/npm')
    else
        return vim.fn.expand('~/AppData/Roaming/nvm/v14.18.0/npm')
    end
end

function install()
    vim.cmd('PackerCompile')
    vim.cmd('PackerSync')
    require('treesitter').install_languages()
    local lsplangs = require('lsplangs').for_current_os()
    for _, ls in ipairs(lsplangs) do
        local silence = vim.fn.has("unix") == 1 and ' >> /dev/null' or ''
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

vim.cmd('command InstallAll lua require("installs").install()')


return {
    install = install
}
