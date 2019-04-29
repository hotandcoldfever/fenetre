## fenêtre

awesome 4 widget that provides a global titlebar with buttons for closing, un/maximising completely/vertically/horizontally, + toggling ontop, sticky, + floating. The buttons also serve as indicators for the corresponding client property

All elements're optional + can be arranged as you like

## Basic use:
```bash
git clone https://github.com/cool-cool-sweat/fenetre ~/.config/awesome/fenetre
```
rc.lua:
```lua
awful.rules.rules = {
...
{ rule_any = { type = { "dialog", "normal" } }, properties = { titlebars_enabled = false } },
...
```
theme.lua:
```lua
local fenetre = require("fenetre")
local titlebar = fenetre { }
```
Then add it to your wibar

## Available arguments

Argument | Use | Type | Default
--- | --- | --- | ---
`order` | Elements to create + order to show them in | table of strings | `{ "close", "max", "ontop", "sticky", "floating", "separator", "title" }`
`rotation` | If set to `left` or `right` the elements're arranged for a vertical wibar + the title's rotated facing left or right. If not set to `left` or `right` they're arranged for a horizontal wibar | string | None
`clickable` | Allow clicking the buttons to change the corresponding client property | boolean | true
`icons_path` | Where to look for the icons to use | string | path_to_widget/icons/
`close_icon` | Path of image to use for the close button | string | icons_path/close.xpm
`ontop_icon` | Path of image to use for the ontop button when the client's ontop | string | icons_path/ontop.xpm
`ontop_off_icon` | Path of image to use for the ontop button when the client's not ontop | string | icons_path/ontop_off.xpm
`sticky_icon` | Path of image to use for the sticky button when the client's sticky | string | icons_path/sticky.xpm
`sticky_off_icon` | Path of image to use for the sticky button when the client's not sticky | string | icons_path/sticky_off.xpm
`floating_icon` | Path of image to use for the floating button when the client's floating | string | icons_path/floating.xpm
`floating_off_icon` | Path of image to use for the floating button when the client's not floating | string | icons_path/floating_off.xpm
`max_icon` | Path of image to use for the maximise button when the client's fully maximised | string | icons_path/max.xpm
`max_horizontal_icon` | Path of image to use for the maximise button when the client's only horizontally maximised | string | icons_path/max_horizontal.xpm
`max_vertical_icon` | Path of image to use for the maximise button when the client's only vertically maximised | string | icons_path/max_vertical.xpm
`max_off_icon` | Path of image to use for the maximise button when the client's not maximised | string | icons_path/max_off.xpm
`mouse_button` | Mouse button to use for clicking | number | 1
`max_vert_button` | Mouse button to use for toggle un/maximising the client vertically using the maximise button. If set to `Shift` or `Control` or `Alt` or `Mod4`, then `mouse_button` plus the specified key're used together | number or string | 2
`max_horiz_button` | Mouse button to use for toggle un/maximising the client horizontally. If set to `Shift` or `Control` or `Alt` or `Mod4`, then `mouse_button` plus the specified key're used together | number or string | 3
`title_edit` | Function to use to edit the title | function | None
`separator` | Text to use as a separator | string | " "

The title and separator's font's controlled by the value of theme.font in the awesome theme

The title colour's controlled by 1 of the following, listed in order of precedence: theme.titlebar_fg_focus, theme.fg_focus

The separator's colour's controlled by 1 of the following, listed in order of precedence: theme.titlebar_separator, theme.titlebar_fg_focus, theme.fg_focus

## Notes
The default icons're included in xpm format for easy customisation. You can quickly change the colours using bash/zsh, sed, + imagemagick:
```bash
cd path_to_widget/icons
sed -i "s,#7ED68D,new_colour," {close,max_vertical,*_off}.xpm
sed -i "s,white,new_colour," {ontop,sticky,floating,max}.xpm
```
The default icons were originally sourced from https://github.com/lcpz/awesome-copycats + are the same designs except for the ontop icons, which were slightly modified

Icons licence: [BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/)

## Usage examples
```lua
local titlebar = fenetre {
    title_edit = function()
        -- Remove " - Mozilla Firefox" from the ends of firefox's titles
        local firefox = " - Mozilla Firefox"
        local pri_brow = firefox .. " (Private Browsing)"
        if title:sub(-firefox:len()) == firefox or title:sub(-pri_brow:len()) == pri_brow then
            title = title:gsub(" %- Mozilla Firefox", "")
        end
    end,
    order = { "max", "ontop", "sticky", "floating", "title" }
}
```

```lua
local titlebar = fenetre {
    max_vert_button = "Shift",
    max_horiz_button = "Control",
    order = { "max", "ontop", "sticky", "floating", "title" }
}
```

```lua
local titlebar = fenetre {
    rotation = "right",
    max_vert_button = "Shift",
    max_horiz_button = "Control",
    title_edit = function()
        if title == "calc" then title = "calculator" end
        title = title:upper()
    end,
    order = { "title", "separator", "ontop", "sticky", "floating", "max" }
}
```

```lua
local titlebar = fenetre {
    clickable = false,
    separator = "|",
    order = { "title", "separator", "max", "separator", "ontop", "separator", "sticky", "separator", "floating" }
}
```

```lua
local titlebar = fenetre {
    mouse_button = 5,
    order = { "title", "separator", "max", "floating", "ontop", "sticky", "close" }
}
```

```lua
local titlebar = fenetre {
    rotation = "left",
    clickable = false,
    icons_path = theme.dir .. "icons/",
    order = { "sticky", "floating", "ontop" }
}
```

```lua
local titlebar = fenetre {
    rotation = "right",
    max_vert_button = 3,
    max_horiz_button = 2,
    ontop_icon = file_name,
    ontop_off_icon = file_name,
    sticky_icon = file_name,
    sticky_off_icon = file_name,
    max_icon = file_name,
    max_vertical_icon = file_name,
    max_off_icon = file_name,
    order = { "title", "max", "ontop", "sticky" }
}
```
