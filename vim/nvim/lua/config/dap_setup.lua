local utils  = require 'utils'
local map  = utils.map
local cb = utils.call_bind
local cmd = vim.api.nvim_create_user_command

local dap = utils.bind(require, 'dap')
local dapui = utils.bind(require, 'dapui')
local osv = utils.bind(require, 'osv')
map('n', '<F9>', cb(dap, 'continue'))
map('n', '<F8>', cb(dap, 'step_over'))
map('n', '<F7>', cb(dap, 'step_into'))
map('n', '<F6>', cb(dap, 'step_out'))

map('n', '<leader>bc', function ()
    dap().set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)
map('n', '<leader>br', cb(dap, 'toggle_breakpoint'))
map('n', '<leader>ev', function ()
    local expr = vim.fn.input 'Expression: '
    require("dapui").eval(expr)
end)
map('n', '<M-d>', cb(dapui, 'toggle'))

cmd('DebugThis', cb(osv, 'launch'), { force=true })
cmd('ClearBreakpoints', cb(dap, 'clear_breakpoints'), { force=true })
cmd('ExceptionBreakpoints', cb(dap, 'set_exception_breakpoints'), { force=true })

