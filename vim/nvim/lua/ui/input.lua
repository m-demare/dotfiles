local utils = require('utils')
local map = utils.map

local function wininput(opts, on_confirm, win_opts)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = "prompt"
    vim.bo[buf].bufhidden = "wipe"

    local prompt = opts.prompt or ""
    local default_text = opts.default or ""

    -- defer the on_confirm callback so that it is
    -- executed after the prompt window is closed
    local deferred_callback = function(input)
        vim.defer_fn(function()
            on_confirm(input)
        end, 1)
    end

    vim.fn.prompt_setprompt(buf, prompt)
    vim.fn.prompt_setcallback(buf, deferred_callback)

    -- CR confirm and exit, ESC in normal mode to abort
    map({ "i", "n" }, "<CR>", "<CR><Esc>:close!<CR>:stopinsert<CR>", { buffer = buf })
    map("n", "<esc>", utils.strict_bind(vim.api.nvim_win_close, 0, true), { buffer = buf })

    local default_win_opts = {
        width = 50,
        height = 1,
        focusable = true,
        style = "minimal",
        border = "rounded",
    }
    win_opts = vim.tbl_deep_extend("force", default_win_opts, win_opts)

    -- adjust window width so that there is always space
    -- for prompt + default text plus a little bit
    win_opts.width = #default_text + #prompt + 5 < win_opts.width and win_opts.width or #default_text + #prompt + 5

    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- Proper colors
    vim.api.nvim_win_set_option(win, "winhighlight", "Normal:None,FloatBorder:None")

    vim.cmd("startinsert")

    -- set the default text (needs to be deferred after the prompt is drawn)
    vim.defer_fn(function()
        vim.api.nvim_buf_set_text(buf, 0, #prompt, 0, #prompt, { default_text })
        vim.cmd("startinsert!") -- bang: go to end of line
    end, 1)

    -- Close on leave
    vim.api.nvim_create_autocmd({ "BufLeave" }, {
        pattern = { "<buffer=" .. tostring(buf) .. ">" },
        once = true,
        callback = utils.strict_bind(vim.api.nvim_win_close, win, true)
    })
end

vim.ui.input = function(opts, on_confirm)
    wininput(opts, on_confirm, { relative = "cursor", row = 1, col = 0, width = 0 })
end
