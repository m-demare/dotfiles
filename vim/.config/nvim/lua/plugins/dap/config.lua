local dap = require "dap"
local utils = require "utils"
local unix = utils.unix

local function request_port()
    local val = tonumber(vim.fn.input "Port: ")
    assert(val, "Please provide a port number")
    return val
end

local function request_path()
    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
end

dap.configurations.lua = {
    {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
        host = "127.0.0.1",
        port = request_port,
    },
}

dap.adapters.nlua = function(callback, config)
    callback { type = "server", host = config.host, port = config.port }
end

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript-firefox
dap.adapters.firefox = {
    type = "executable",
    command = "node",
    args = { os.getenv "HOME" .. "/debuggers/vscode-firefox-debug/dist/adapter.bundle.js" },
}

local ff_base_config = {
    name = "Debug with Firefox",
    type = "firefox",
    request = "launch",
    reAttach = true,
    url = "http://localhost:3000",
    webRoot = "${workspaceFolder}",
    firefoxExecutable = "/usr/bin/firefox",
}

dap.configurations.typescript = {
    vim.tbl_extend("force", ff_base_config, { name = "Port 3000", url = "http://localhost:3000" }),
    vim.tbl_extend("force", ff_base_config, { name = "Port 4200", url = "http://localhost:4200" }),
}
dap.configurations.typescriptreact = dap.configurations.typescript
dap.configurations.javascriptreact = dap.configurations.typescript
dap.configurations.javascript = dap.configurations.typescript

-- lldb: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
-- gdb: https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-vscode",
    name = "lldb",
}

dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = os.getenv "HOME" .. "/debuggers/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
}

dap.configurations.cpp = {
    {
        name = "Launch lldb",
        type = "lldb",
        request = "launch",
        program = request_path,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},

        -- For `runInTerminal = true`:
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        runInTerminal = false,
        -- To ignore SIGWINCH when `runInTerminal = true`:
        postRunCommands = { "process handle -p true -s false -n false SIGWINCH" },
    },
    {
        -- If you get an "Operation not permitted" error using this, try disabling YAMA:
        --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        name = "Attach to process (lldb)",
        type = "lldb",
        request = "attach",
        pid = require("dap.utils").pick_process,
        args = {},
    },
    {
        name = "Attach to gdbserver :1234",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/gdb",
        cwd = "${workspaceFolder}",
        program = request_path,
        setupCommands = {
            {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false,
            },
        },
    },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- Icons
-- stylua: ignore
if unix then
    vim.fn.sign_define("DapBreakpoint", { text = "● ", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "● ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "● ", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "→ ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointReject", { text = "●", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })
end

-- dapui
dap.listeners.before.event_terminated["dapui_config"] = function()
    require("dapui").close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    require("dapui").close()
end

local keymap_restore = {}
dap.listeners.after.event_initialized["inspect_k"] = function()
    for _, buf in pairs(vim.api.nvim_list_bufs()) do
        local keymaps = vim.api.nvim_buf_get_keymap(buf, "n")
        for _, keymap in pairs(keymaps) do
            if keymap.lhs == "K" then
                table.insert(keymap_restore, keymap)
                vim.api.nvim_buf_del_keymap(buf, "n", "K")
            end
        end
    end
    vim.keymap.set("n", "K", require("dap.ui.widgets").hover)
end

dap.listeners.after.event_terminated["inspect_k"] = function()
    for _, keymap in pairs(keymap_restore) do
        vim.api.nvim_buf_set_keymap(
            keymap.buffer,
            keymap.mode,
            keymap.lhs,
            keymap.rhs,
            { silent = keymap.silent == 1 }
        )
    end
    keymap_restore = {}
end
