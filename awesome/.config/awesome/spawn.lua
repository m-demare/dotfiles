local awful = require("awful")
local log = require("log")

local M = {}

local terminal = "alacritty"
local editor = os.getenv("EDITOR") or "vim"
local home = os.getenv('HOME') or error("No home?")

function M.term_at(dir, ...)
    local args = { ... }
    local cmd = table.concat(args, ' ')
    log.debug('creating term cb for %s at %s', cmd, dir)
    return function()
        dir = string.gsub(dir, '~', home)
        awful.spawn(terminal .. " --working-directory " .. dir .. " -e ".. cmd, false)
    end
end

function M.term(...)
    return M.term_at(home, ...)
end

function M.editor_at(dir)
    return M.term_at(dir, editor)
end

function M.at_tag(cmd, tagnr, screennr, except_exists_name)
    log.debug('creating cb for %s at tag %s', cmd, tagnr)
    return function ()
        screennr = screennr or M.main_screen()
        local screen = screen[screennr]
        local tag = screen.tags[tagnr]
        if not tag then return end

        -- Focus on tag
        tag:view_only()

        if except_exists_name then
            for _, client in ipairs(tag:clients()) do
                if client.class == except_exists_name then
                    log.debug('%s already exists, not opening again', except_exists_name)
                    return
                end
            end
        end
        awful.spawn(cmd, { tag = tostring(tagnr), screen=screennr})
    end
end

function M.main_screen()
    for i = 1, screen.count() do
        if screen[i].geometry.height == 1080 then
            log.debug("Detected main screen %s, with geometry %s", i, screen[i].geometry)
            return i
        end
    end
    return 1
end

function M.with_shell(...)
    local args = {...}
    return function()
        local unpack = unpack or table.unpack
        awful.spawn.with_shell(unpack(args))
    end
end

setmetatable(M, {
    __call = function (_, ...)
        local args = {...}
        return function()
            local unpack = unpack or table.unpack
            awful.spawn(unpack(args))
        end
    end
})

return M
