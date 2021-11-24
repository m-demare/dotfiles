function install()
    vim.cmd('PackerCompile')
    vim.cmd('PackerSync')
    require('treesitter').install_languages()
    local lsplangs = require('lsplangs').for_current_os()
    for _, ls in ipairs(lsplangs) do
        local silence = vim.fn.has("unix") and ' >> /dev/null' or ''
        if ls.install_method == "npm" then
            vim.cmd('!$HOME/.nvm/versions/node/$vim_node_version/bin/npm i -g ' .. ls.val .. silence)
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
