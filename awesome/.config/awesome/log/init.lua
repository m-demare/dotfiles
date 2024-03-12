local stringify_all = require("log.stringify").stringify_all

local logfile = "/tmp/awesome.log"
local loglevel = "DEBUG"

local levels = {
    DEBUG = 1,
    INFO = 2,
    ERROR = 3,
}

local function notif(title, ...)
    local text = table.concat({ stringify_all(...) }, "\n")
    require("naughty").notify({ title=title, text=text })
end

local function log(level)
    return function (s, ...)
        if levels[level]  < levels[loglevel] then return end
        local fp = assert(io.open(logfile, "a"))
        s = ("%s [%s]: %s\n"):format(os.date(), level, s:format(stringify_all(...)))
        fp:write(s)
        fp:close()
    end
end

return {
    notif = notif,
    debug = log('DEBUG'),
    info = log('INFO'),
    error = log('ERROR'),
}
