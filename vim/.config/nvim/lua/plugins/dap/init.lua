local utils = require "utils"
local req = utils.req
local cb = utils.call_bind

local dap = utils.bind(require, "dap")
local dapui = utils.bind(require, "dapui")

return {
    {
        {
            "mfussenegger/nvim-dap",
            config = req "plugins.dap.config",
            dependencies = {
                "jbyuki/one-small-step-for-vimkind",
                "rcarriga/nvim-dap-ui",
            },
            module = "dap",
            lazy = true,
            cmd = { "OsvStart", "OsvStop", "ClearBreakpoints", "ExceptionBreakpoints" },
            keys = {
                { "<leader><F9>", cb(dap, "run_to_cursor") },
                { "<F9>", cb(dap, "continue") },
                { "<F8>", cb(dap, "step_over") },
                { "<F7>", cb(dap, "step_into") },
                { "<F6>", cb(dap, "step_out") },
                { "<F5>", cb(dap, "close") },
                { "<leader>br", cb(dap, "toggle_breakpoint") },
                {
                    "<leader>bc",
                    function()
                        dap().set_breakpoint(vim.fn.input "Breakpoint condition: ")
                    end,
                },
            },
        },
        {
            "rcarriga/nvim-dap-ui",
            module = "dapui",
            dependencies = "nvim-neotest/nvim-nio",
            lazy = true,
            keys = {
                { "<M-d>", cb(dapui, "toggle") },
                { "<leader>.", cb(dapui, "eval", nil), mode = { "n", "v" } },
                {
                    "<leader>ev",
                    function()
                        local expr = vim.fn.input "Expression: "
                        require("dapui").eval(expr)
                    end,
                },
            },
            opts = {
                layouts = {
                    {
                        elements = {
                            { id = "breakpoints", size = 0.20 },
                            { id = "stacks", size = 0.15 },
                            { id = "scopes", size = 0.40 },
                            { id = "watches", size = 0.25 },
                        },
                        size = 45,
                        position = "right",
                    },
                    {
                        elements = { "repl", "console" },
                        size = 10,
                        position = "bottom",
                    },
                },
            },
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {
                enabled = false,
            },
            keys = {
                { "<leader>vtt", "<cmd>DapVirtualTextToggle<CR>" },
            },
        },
    },
}
