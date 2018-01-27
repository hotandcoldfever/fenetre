local layout = require("wibox.layout").fixed
local imagebox = require("wibox.widget").imagebox
local textbox = require("wibox.widget").textbox
local rotate = require("wibox.container").rotate
local button = require("awful.button")
local join = require("gears.table").join
local escape = require("awful.util").escape

local function fenetre(args)
    local args = args or {  }
    local order = args.order or { "close", "max", "ontop", "sticky", "floating", "separator", "title" }
    local icons_dir = args.icons_dir or debug.getinfo(1, 'S').source:match[[^@(.*/).*$]] .. "icons/"

    local titlebar
    if args.rotation == "left" or args.rotation == "right" then
        titlebar = layout.vertical()
    else
        titlebar = layout.horizontal()
    end

    local clickable
    if args.clickable == false then
        clickable = false
    else
        local mouse_button = args.mouse_button or 1
        clickable = true
    end

    for _, part in ipairs(order) do -- Only show elements included in order
        if part == "close" then
            local close_button = imagebox()
            local close_icon = args.close_icon or icons_dir .. "close.png"

            titlebar:add(close_button)

            if clickable then
                close_button:buttons(join(button({ }, mouse_button, function()
                    if client.focus then client.focus:kill() end
                end)))
            end

            client.connect_signal("focus", function() close_button:set_image(close_icon) end)
            client.connect_signal("unfocus", function() close_button:set_image() end)

        elseif part == "ontop" then
            local ontop_button = imagebox()
            local ontop_icon = args.ontop_icon or icons_dir .. "ontop.png"
            local ontop_off_icon = args.ontop_off_icon or icons_dir .. "ontop_off.png"

            local function update_ontop(c)
                if c == client.focus then
                    if c.ontop then
                        ontop_button:set_image(ontop_icon)
                    else
                        ontop_button:set_image(ontop_off_icon)
                    end
                end
            end

            titlebar:add(ontop_button)

            if clickable then
                ontop_button:buttons(join(button({ }, mouse_button, function()
                    if client.focus then
                        client.focus.ontop = not client.focus.ontop
                        update_ontop(client.focus)
                    end
                end)))
            end

            client.connect_signal("focus", update_ontop)
            client.connect_signal("property::ontop", update_ontop)
            client.connect_signal("unfocus", function() ontop_button:set_image() end)

        elseif part == "sticky" then
            local sticky_button = imagebox()
            local sticky_icon = args.sticky_icon or icons_dir .. "sticky.png"
            local sticky_off_icon = args.sticky_off_icon or icons_dir .. "sticky_off.png"

            local function update_sticky(c)
                if c == client.focus then
                    if c.sticky then
                        sticky_button:set_image(sticky_icon)
                    else
                        sticky_button:set_image(sticky_off_icon)
                    end
                end
            end

            titlebar:add(sticky_button)

            if clickable then
                sticky_button:buttons(join(button({ }, mouse_button, function()
                    if client.focus then
                        client.focus.sticky = not client.focus.sticky
                        update_sticky(client.focus)
                    end
                end)))
            end

            client.connect_signal("focus", update_sticky)
            client.connect_signal("property::sticky", update_sticky)
            client.connect_signal("unfocus", function() sticky_button:set_image() end)

        elseif part == "floating" then
            local floating_button = imagebox()
            local floating_icon = args.floating_icon or icons_dir .. "floating.png"
            local floating_off_icon = args.floating_off_icon or icons_dir .. "floating_off.png"

            local function update_floating(c)
                if c == client.focus then
                    if c.floating then
                        floating_button:set_image(floating_icon)
                    else
                        floating_button:set_image(floating_off_icon)
                    end
                end
            end

            titlebar:add(floating_button)

            if clickable then
                floating_button:buttons(join(button({ }, mouse_button, function()
                    if client.focus then
                        client.focus.floating = not client.focus.floating
                        update_floating(client.focus)
                    end
                end)))
            end

            client.connect_signal("focus", update_floating)
            client.connect_signal("property::floating", update_floating)
            client.connect_signal("unfocus", function() floating_button:set_image() end)

        elseif part == "max" then
            local max_button = imagebox()
            local max_icon = args.max_icon or icons_dir .. "max.png"
            local max_partial_icon = args.max_partial_icon or icons_dir .. "max_partial.png"
            local max_off_icon = args.max_off_icon or icons_dir .. "max_off.png"

            local function update_max(c)
                if c == client.focus then
                    if c.maximized or (c.maximized_vertical and c.maximized_horizontal) then
                        max_button:set_image(max_icon)
                    elseif c.maximized_vertical or c.maximized_horizontal then
                        max_button:set_image(max_partial_icon)
                    else
                        max_button:set_image(max_off_icon)
                    end
                end
            end

            titlebar:add(max_button)

            if clickable then
                local max_vert_button = args.max_vert_button or 2
                local max_horiz_button = args.max_horiz_button or 3

                local max_vert_modifier
                if max_vert_button == "Shift" or max_vert_button == "Control"
                    or max_vert_button == "Mod4" or max_vert_button == "Alt" then
                        max_vert_modifier = max_vert_button
                        max_vert_button = mouse_button
                end

                local max_horiz_modifier
                if max_horiz_button == "Shift" or max_horiz_button == "Control"
                    or max_horiz_button == "Mod4" or max_horiz_button == "Alt" then
                        max_horiz_modifier = max_horiz_button
                        max_horiz_button = mouse_button
                end

                max_button:buttons(join(
                    button({ }, mouse_button, function()
                        if client.focus then
                            client.focus.maximized = not client.focus.maximized
                            update_max(client.focus)
                        end
                    end),

                    button({ max_vert_modifier }, max_vert_button, function()
                        if client.focus then
                            client.focus.maximized_vertical = not client.focus.maximized_vertical
                            update_max(client.focus)
                        end
                    end),

                    button({ max_horiz_modifier }, max_horiz_button, function()
                        if client.focus then
                            client.focus.maximized_horizontal = not client.focus.maximized_horizontal
                            update_max(client.focus)
                        end
                    end)))
            end

            client.connect_signal("focus", update_max)
            client.connect_signal("property::maximized", update_max)
            client.connect_signal("property::maximized_vertical", update_max)
            client.connect_signal("property::maximized_horizontal", update_max)
            client.connect_signal("unfocus", function() max_button:set_image() end)

        elseif part == "title" then
            local title_rotation
            if args.rotation == "left" then
                title_rotation = "east"
            elseif args.rotation == "right" then
                title_rotation = "west"
            else
                title_rotation = "north"
            end

            local client_title = rotate(textbox(), title_rotation)
            local font = args.title_font or nil
            local color = args.title_color or "#FFFFFF"

            local function update_title(c)
                if c == client.focus then
                    title = nil
                    if c.name then
                        title = c.name
                    elseif c.class then
                        title = c.class
                    end

                    if args.title_edit then args.title_edit() end

                    if title then
                        client_title.widget.markup = string.format("<span font='%s' foreground='%s'>%s</span>", font, color, escape(title))
                    end
                end
            end

            titlebar:add(client_title)

            client.connect_signal("focus", update_title)
            client.connect_signal("property::name", update_title)
            client.connect_signal("unfocus", function() client_title.widget.text = "" end)

        elseif part == "separator" then
            local separator_rotation
            if args.rotation == "left" then
                separator_rotation = "east"
            elseif args.rotation == "right" then
                separator_rotation = "west"
            else
                separator_rotation = "north"
            end

            local separator = rotate(textbox(), separator_rotation)
            local font = args.separator_font or args.title_font or nil
            local color = args.separator_color or args.title_color or "#FFFFFF"
            local text = escape(args.separator) or " "

            titlebar:add(separator)

            client.connect_signal("focus", function()
                separator.widget.markup = string.format("<span font='%s' foreground='%s'>%s</span>", font, color, text)
            end)
            client.connect_signal("unfocus", function() separator.widget.text = "" end)
        end
    end

    return titlebar
end

return fenetre
