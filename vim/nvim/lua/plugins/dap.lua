local utils = require('utils')
local req = utils.req
local cb = utils.call_bind
local cmd = vim.api.nvim_create_user_command

local dap = utils.bind(require, 'dap')
local dapui = utils.bind(require, 'dapui')
local osv = utils.bind(require, 'osv')

cmd('DebugThis', cb(osv, 'launch'), { force=true })
cmd('ClearBreakpoints', cb(dap, 'clear_breakpoints'), { force=true })
cmd('ExceptionBreakpoints', cb(dap, 'set_exception_breakpoints'), { force=true })

return {
    {
        {
            'mfussenegger/nvim-dap',
            config = req 'config.dap',
            dependencies = 'jbyuki/one-small-step-for-vimkind',
            module = 'dap',
            lazy = true,
            cmd = { 'DebugThis', 'ClearBreakpoints', 'ExceptionBreakpoints' },
            keys = {
                { '<F5>',       cb(dap, 'close') },
                { '<F9>',       cb(dap, 'continue') },
                { '<F8>',       cb(dap, 'step_over') },
                { '<F7>',       cb(dap, 'step_into') },
                { '<F6>',       cb(dap, 'step_out') },
                { '<leader>br', cb(dap, 'toggle_breakpoint') },
                {
                    '<leader>bc',
                    function()
                        dap().set_breakpoint(vim.fn.input('Breakpoint condition: '))
                    end
                },
                {
                    '<leader>ev',
                    function()
                        local expr = vim.fn.input 'Expression: '
                        require("dapui").eval(expr)
                    end
                },
            }
        },
        {
            'rcarriga/nvim-dap-ui',
            dependencies = 'nvim-dap',
            module = 'dapui',
            lazy = true,
            keys = {
                { '<M-d>', cb(dapui, 'toggle') },
            },
            opts = {
                layouts = {
                    {
                        elements = {
                            { id = "breakpoints", size = 0.20 },
                            { id = "stacks", size = 0.45 },
                            { id = "watches", size = 0.35 },
                        },
                        size = 40,
                        position = "right",
                    }, {
                        elements = { "repl", "console" },
                        size = 10,
                        position = "bottom",
                    },
                }
            }
        }
    }
}
