local utils = require "utils"
local map = vim.keymap.set
local nmap = utils.bind(map, "n")

local group = vim.api.nvim_create_augroup("my_aucmds", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.highlight.on_yank { on_visual = true, timeout = 250 }
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "netrw",
    callback = function()
        -- Go back in history
        nmap("H", "u", { buffer = true, remap = true })
        -- Go up a directory
        nmap("h", "-^", { buffer = true, remap = true })
        -- Go down a directory / open file
        nmap("l", "<CR>", { buffer = true, remap = true })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function (ev)
        if vim.tbl_contains({"markdown", "tex", "text"}, ev.match) then
            vim.cmd "setlocal spell"
        else
            vim.cmd "setlocal nospell"
        end
    end
})

if utils.unix then
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
        callback = function(ev)
            require("config.maps").map_open_mdn(ev.buf)
        end,
    })
end

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "query",
    callback = function(ev)
        if not vim.api.nvim_get_option_value ("modifiable", {buf=ev.buf}) then
            nmap('o', '<cmd>EditQuery<cr>', { buffer = ev.buf })
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = {
        "dap-float",
        "qf",
    },
    callback = function(ev)
        vim.keymap.set("n", "q", "<c-w>q", { buffer = ev.buf })
    end,
})

