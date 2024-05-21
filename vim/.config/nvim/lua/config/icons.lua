local unix = require("utils").unix

local cmp_icons = {}
local lualine_separators, navic_icons, nvim_tree_icons

if unix then
    cmp_icons = {
        Text = "   ",
        Method = "  ",
        Function = "  ",
        Constructor = "  ",
        Variable = "  ",
        Class = "  ",
        Interface = "  ",
        Struct = "  ",
        Module = "  ",
        Field = " ﰠ ",
        Property = " ﰠ ",
        Unit = "  ",
        Value = "  ",
        Keyword = "  ",
        Snippet = "  ",
        Color = "  ",
        File = "  ",
        Reference = "  ",
        Folder = "  ",
        Enum = "  ",
        EnumMember = "  ",
        Constant = " ﲀ ",
        Event = "  ",
        Operator = "  ",
        TypeParameter = "  ",
    }

    -- stylua: ignore
    do
        vim.fn.sign_define("DapBreakpoint", { text = "● ", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "● ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
        vim.fn.sign_define("DapLogPoint", { text = "● ", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "→ ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointReject", { text = "●", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })
    end
else
    lualine_separators = ""
    navic_icons = {
        File = "",
        Module = "",
        Namespace = "",
        Package = "",
        Class = "",
        Method = "",
        Property = "",
        Field = "",
        Constructor = "",
        Enum = "",
        Interface = "",
        Function = "",
        Variable = "",
        Constant = "",
        String = "",
        Number = "",
        Boolean = "",
        Array = "",
        Object = "",
        Key = "",
        Null = "",
        EnumMember = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
    }
    nvim_tree_icons = {
        show = {
            file = false,
            folder = false,
            folder_arrow = true,
            git = false,
        },
        glyphs = {
            folder = {
                arrow_closed = ">",
                arrow_open = "v",
                default = ">",
                open = "v",
                empty = ">",
                empty_open = "v",
                symlink = ">",
                symlink_open = "v",
            },
        },
    }
end

return {
    cmp_icons = cmp_icons,
    navic_icons = navic_icons,
    lualine_separators = lualine_separators,
    nvim_tree_icons = nvim_tree_icons,
}
