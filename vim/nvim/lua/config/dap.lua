local dap = require 'dap'

local function request_port()
    local val = tonumber(vim.fn.input 'Port: ')
    assert(val, 'Please provide a port number')
    return val
end

local function request_path()
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end

dap.configurations.lua = {
    {
        type = 'nlua',
        request = 'attach',
        name = 'Attach to running Neovim instance',
        host = '127.0.0.1',
        port = request_port
    }
}

dap.adapters.nlua = function(callback, config)
    callback { type = 'server', host = config.host, port = config.port }
end

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript-firefox
dap.adapters.firefox = {
    type = 'executable',
    command = 'node',
    args = { os.getenv('HOME') .. '/debuggers/vscode-firefox-debug/dist/adapter.bundle.js' }
}

local ff_base_config = {
    name = 'Debug with Firefox',
    type = 'firefox',
    request = 'launch',
    reAttach = true,
    url = 'http://localhost:3000',
    webRoot = '${workspaceFolder}',
    firefoxExecutable = '/usr/bin/firefox'
}

dap.configurations.typescript = {
    vim.tbl_extend('force', ff_base_config, { name = "Port 3000", url = 'http://localhost:3000' }),
    vim.tbl_extend('force', ff_base_config, { name = "Port 4200", url = 'http://localhost:4200' })
}
dap.configurations.typescriptreact = dap.configurations.typescript
dap.configurations.javascriptreact = dap.configurations.typescript
dap.configurations.javascript = dap.configurations.typescript

-- lldb: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
-- gdb: https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode',
  name = "lldb"
}

dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = os.getenv('HOME') .. '/debuggers/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}

dap.configurations.cpp = {
    {
        name = "Launch lldb",
        type = "lldb",
        request = "launch",
        program = request_path,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},

        -- For `runInTerminal = true`:
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        runInTerminal = false,
        -- To ignore SIGWINCH when `runInTerminal = true`:
        postRunCommands = {'process handle -p true -s false -n false SIGWINCH'}
    },
    {
        name = 'Attach to gdbserver :1234',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:1234',
        miDebuggerPath = '/usr/bin/gdb',
        cwd = '${workspaceFolder}',
        program = request_path,
        setupCommands = { {
            text = '-enable-pretty-printing',
            description =  'enable pretty printing',
            ignoreFailures = false
        } }
    },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- Icons
if vim.fn.has("unix") == 1 then
    vim.fn.sign_define("DapBreakpoint", { text = "● ", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "● ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "● ", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→ ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointReject", { text = "●", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })
end

