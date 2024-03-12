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
        awful.spawn(terminal .. " --working-directory " .. dir .. " -e ".. cmd)
    end
end

function M.term(...)
    return M.term_at(home, ...)
end

function M.editor_at(dir)
    return M.term_at(dir, editor)
end

function M.at_tag(cmd, tagnr, screennr)
    log.debug('creating cb for %s at tag %s', cmd, tagnr)
    return function ()
        screennr = screennr or M.main_screen()
        awful.spawn(cmd, { tag = tostring(tagnr), screen=screennr})
        local screen = screen[screennr]
        local tag = screen.tags[tagnr]
        if tag then
            tag:view_only()
        end
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
