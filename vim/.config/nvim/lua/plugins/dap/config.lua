local dap = require "dap"
local utils = require "utils"
local osv = require "osv"

local cmd = vim.api.nvim_create_user_command
local b = utils.strict_bind
local LUA_DB_PORT = 9996
cmd("OsvStart", b(osv.launch, { port = LUA_DB_PORT }), { force = true })
cmd("OsvStop", b(osv.stop), { force = true })
cmd("ClearBreakpoints", b(dap.clear_breakpoints), { force = true })
cmd("ExceptionBreakpoints", b(dap.set_exception_breakpoints), { force = true })

local function request_port()
    local val = tonumber(vim.fn.input("Port: ", tostring(LUA_DB_PORT)))
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
    type = "firefox",
    request = "launch",
    reAttach = true,
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
dap.configurations.rust = {
    vim.tbl_extend("error", dap.configurations.cpp[1], {
        initCommands = function()
            local rustc_sysroot = vim.fn.trim(vim.fn.system "rustc --print sysroot")

            local script_import = 'command script import "'
                .. rustc_sysroot
                .. '/lib/rustlib/etc/lldb_lookup.py"'
            local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

            local commands = {}
            local file = io.open(commands_file, "r")
            if file then
                for line in file:lines() do
                    table.insert(commands, line)
                end
                file:close()
            end
            table.insert(commands, 1, script_import)

            return commands
        end,
    }),
}

-- dapui
dap.listeners.before.attach.dapui_config = function()
    require("dapui").open()
end
dap.listeners.before.launch.dapui_config = function()
    require("dapui").open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    require("dapui").close()
end
dap.listeners.before.event_exited.dapui_config = function()
    require("dapui").close()
end

dap.listeners.after.event_initialized.inspect_kk = function()
    vim.keymap.set("n", "gK", require("dap.ui.widgets").hover)
end

dap.listeners.after.event_exited.inspect_kk = function()
    vim.keymap.del("n", "gK")
end

dap.listeners.after.event_terminated.inspect_kk = function()
    vim.keymap.del("n", "gK")
end
