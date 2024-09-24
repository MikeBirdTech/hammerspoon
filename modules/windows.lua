-- ~/.hammerspoon/modules/windows.lua

local windows = {}

-- Define meh key
local meh = {"alt", "ctrl", "shift"}

-- Window movement and resizing functions
function windows.moveAndResize(x, y, w, h)
    local win = hs.window.focusedWindow()
    if not win then return end

    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w * x)
    f.y = max.y + (max.h * y)
    f.w = max.w * w
    f.h = max.h * h

    win:setFrame(f)
end

-- Vim-style directional movements (full screen)
hs.hotkey.bind(meh, "K", function() windows.moveAndResize(0, 0, 1, 0.5) end)    -- Top half
hs.hotkey.bind(meh, "J", function() windows.moveAndResize(0, 0.5, 1, 0.5) end)  -- Bottom half
hs.hotkey.bind(meh, "H", function() windows.moveAndResize(0, 0, 0.5, 1) end)    -- Left half
hs.hotkey.bind(meh, "L", function() windows.moveAndResize(0.5, 0, 0.5, 1) end)  -- Right half

-- Corner movements
hs.hotkey.bind(meh, "Y", function() windows.moveAndResize(0, 0, 0.5, 0.5) end)       -- Top-left quarter
hs.hotkey.bind(meh, "O", function() windows.moveAndResize(0.5, 0, 0.5, 0.5) end)     -- Top-right quarter
hs.hotkey.bind(meh, "N", function() windows.moveAndResize(0, 0.5, 0.5, 0.5) end)     -- Bottom-left quarter
hs.hotkey.bind(meh, ".", function() windows.moveAndResize(0.5, 0.5, 0.5, 0.5) end)   -- Bottom-right quarter

-- Center with different sizes
hs.hotkey.bind(meh, "U", function() windows.moveAndResize(0.25, 0.25, 0.5, 0.5) end) -- Center (half of screen)
hs.hotkey.bind(meh, "I", function() windows.moveAndResize(0.125, 0.125, 0.75, 0.75) end) -- Center (3/4 of screen)

-- Full screen
hs.hotkey.bind(meh, "F", function() windows.moveAndResize(0, 0, 1, 1) end)

-- Thirds
hs.hotkey.bind(meh, "1", function() windows.moveAndResize(0, 0, 1/3, 1) end)       -- Left third
hs.hotkey.bind(meh, "2", function() windows.moveAndResize(1/3, 0, 1/3, 1) end)     -- Middle third
hs.hotkey.bind(meh, "3", function() windows.moveAndResize(2/3, 0, 1/3, 1) end)     -- Right third

-- Two thirds
hs.hotkey.bind(meh, "4", function() windows.moveAndResize(0, 0, 2/3, 1) end)       -- Left two thirds
hs.hotkey.bind(meh, "5", function() windows.moveAndResize(1/3, 0, 2/3, 1) end)     -- Right two thirds

return windows