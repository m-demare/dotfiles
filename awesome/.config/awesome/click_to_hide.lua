local awful = require "awful"
local wibox = require "wibox"

local function hide_fn(widget, outside_only)
    return function(object)
        if outside_only and object == widget then
            return
        end
        widget.visible = false
    end
end

local function click_to_hide(widget, hide_fct)
    local click_bind = awful.button({ }, 1, hide_fct)

    local function manage_signals(w)
        if not w.visible then
            wibox.disconnect_signal("button::press", hide_fct)
            client.disconnect_signal("button::press", hide_fct)
            awful.mouse.remove_global_mousebinding(click_bind)
        else
            awful.mouse.append_global_mousebinding(click_bind)
            client.connect_signal("button::press", hide_fct)
            wibox.connect_signal("button::press", hide_fct)
        end
    end

    widget:connect_signal('property::visible', manage_signals)

    return function ()
        widget:disconnect_signal('property::visible', manage_signals)
        wibox.disconnect_signal("button::press", hide_fct)
        client.disconnect_signal("button::press", hide_fct)
        awful.mouse.remove_global_mousebinding(click_bind)
    end
end

local function click_to_hide_menu(menu)
    click_to_hide(menu.wibox, function()
        menu:hide()
    end)
end

return {
    menu = click_to_hide_menu,
    popup = click_to_hide,
    hide_fn = hide_fn,
}
