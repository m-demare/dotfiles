local utils = require "utils"
local map = vim.keymap.set
local nmap = utils.bind(map, "n")
local M = {}

nmap("<leader>ll", "<cmd>luafile %<CR>")

nmap("<leader>lz", "<cmd>Lazy<CR>")

M.map_open_mdn = function(bufnr)
    map({ "n", "v" }, "<leader>K", function()
        local base_url = "https://developer.mozilla.org/en-US/search?q="
        local word
        if vim.fn.mode() == "v" then
            local saved_reg = vim.fn.getreg "v"
            vim.cmd [[noautocmd sil norm "vy]]
            local sel = vim.fn.getreg "v"
            vim.fn.setreg("v", saved_reg)
            word = sel
        else
            word = vim.fn.expand "<cword>"
        end
        vim.cmd('noautocmd sil !xdg-open "' .. base_url .. word .. '"')
    end, { buffer = bufnr })
end

-- Installs
vim.api.nvim_create_user_command("InstallLsps", require "utils.install_lsps", { force = true })

return M
