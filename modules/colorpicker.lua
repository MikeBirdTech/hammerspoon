-- ~/.hammerspoon/modules/colorpicker.lua

local colorpicker = {}
local config = require("config")

-- Load the ColorPicker Spoon
hs.loadSpoon("ColorPicker")

-- Configure ColorPicker
spoon.ColorPicker.show_in_menubar = false  -- Set to true if you want a menubar item

-- Define hotkey
local meh = config.keys.meh
spoon.ColorPicker:bindHotkeys({
    show = {meh, "C"}  -- Use Meh+C to show the color picker
})

return colorpicker

