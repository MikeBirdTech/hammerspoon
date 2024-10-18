-- ~/.hammerspoon/modules/windows.lua

local windows = {}
local config = require("config")

-- Define meh and hyper keys
local meh = config.keys.meh
local hyper = config.keys.hyper

-- Custom screen order mapping
local screenOrder = {
	["LG HDR 4K"] = 3,
	["Built-in Retina Display"] = 1,
	["VX3211-4K"] = 2,
	["Elgato Prom"] = 4,
}

-- Function to get ordered screens
function windows.getOrderedScreens()
	local allScreens = hs.screen.allScreens()
	table.sort(allScreens, function(a, b)
		return (screenOrder[a:name()] or 99) < (screenOrder[b:name()] or 99)
	end)
	return allScreens
end

-- Window movement and resizing functions
function windows.moveAndResize(x, y, w, h)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()
	f.x = max.x + (max.w * x)
	f.y = max.y + (max.h * y)
	f.w = max.w * w
	f.h = max.h * h
	win:setFrame(f)
end

-- Function to list all screens
function windows.listScreens()
	local screens = windows.getOrderedScreens()
	local screenInfo = "Screen Information:\n"
	for i, screen in ipairs(screens) do
		screenInfo = screenInfo .. string.format("Screen %d: %s\n", i, screen:name())
	end
	hs.alert.show(screenInfo, 5)
end

-- Function to move window to a specific screen by index
function windows.moveToScreenIndex(index)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local screens = windows.getOrderedScreens()
	local targetScreen = screens[index]
	if targetScreen then
		win:moveToScreen(targetScreen)
	else
		hs.alert.show("Screen index out of range", 2)
	end
end

-- Function to move window to next/previous screen
function windows.moveToScreen(direction)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local screen = win:screen()
	local screens = windows.getOrderedScreens()
	local currentIndex = hs.fnutils.indexOf(screens, screen)
	local numScreens = #screens
	local newIndex

	if direction == "right" then
		newIndex = (currentIndex % numScreens) + 1
	else
		newIndex = ((currentIndex - 2 + numScreens) % numScreens) + 1
	end

	win:moveToScreen(screens[newIndex])
end

-- Function to resize to 16:9 aspect ratio, maintaining current width
function windows.resizeTo16by9()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()
	local targetHeight = (f.w * 9) / 16
	if targetHeight > max.h then
		targetHeight = max.h
		f.w = (targetHeight * 16) / 9
	end
	local yAdjustment = (max.h - targetHeight) / 2
	if f.y + targetHeight > max.y + max.h then
		f.y = max.y + max.h - targetHeight
	elseif f.y < max.y + yAdjustment then
		f.y = max.y + yAdjustment
	end
	f.h = targetHeight
	win:setFrame(f)
end

-- Function to resize window incrementally
function windows.resizeWindow(deltaWidth, deltaHeight)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	-- Calculate new size
	f.w = math.min(max.w, math.max(100, f.w + deltaWidth))
	f.h = math.min(max.h, math.max(100, f.h + deltaHeight))

	-- Ensure the window stays within screen bounds
	if f.x < max.x then
		f.x = max.x
	end
	if f.y < max.y then
		f.y = max.y
	end
	if (f.x + f.w) > (max.x + max.w) then
		f.x = max.x + max.w - f.w
	end
	if (f.y + f.h) > (max.y + max.h) then
		f.y = max.y + max.h - f.h
	end

	win:setFrame(f)
end

-- Function to resize window proportionally
function windows.resizeWindowProportional(delta)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()
	-- Calculate new size
	f.w = math.min(max.w, math.max(100, f.w + delta))
	f.h = math.min(max.h, math.max(100, f.h + delta * (f.h / f.w)))
	-- Optionally, keep the window centered
	f.x = f.x - delta / 2
	f.y = f.y - (delta * (f.h / f.w)) / 2
	-- Ensure the window stays within screen bounds
	win:setFrame(f)
end

-- Vim-style directional movements (full screen)
hs.hotkey.bind(meh, "K", function()
	windows.moveAndResize(0, 0, 1, 0.5)
end) -- Top half
hs.hotkey.bind(meh, "J", function()
	windows.moveAndResize(0, 0.5, 1, 0.5)
end) -- Bottom half
hs.hotkey.bind(meh, "H", function()
	windows.moveAndResize(0, 0, 0.5, 1)
end) -- Left half
hs.hotkey.bind(meh, "L", function()
	windows.moveAndResize(0.5, 0, 0.5, 1)
end) -- Right half

-- Corner movements
hs.hotkey.bind(meh, "Y", function()
	windows.moveAndResize(0, 0, 0.5, 0.5)
end) -- Top-left quarter
hs.hotkey.bind(meh, "O", function()
	windows.moveAndResize(0.5, 0, 0.5, 0.5)
end) -- Top-right quarter
hs.hotkey.bind(meh, "N", function()
	windows.moveAndResize(0, 0.5, 0.5, 0.5)
end) -- Bottom-left quarter
hs.hotkey.bind(meh, ".", function()
	windows.moveAndResize(0.5, 0.5, 0.5, 0.5)
end) -- Bottom-right quarter

-- Center with different sizes
hs.hotkey.bind(meh, "U", function()
	windows.moveAndResize(0.25, 0.25, 0.5, 0.5)
end) -- Center (half of screen)
hs.hotkey.bind(meh, "I", function()
	windows.moveAndResize(0.125, 0.125, 0.75, 0.75)
end) -- Center (3/4 of screen)

-- Full screen
hs.hotkey.bind(meh, "F", function()
	windows.moveAndResize(0, 0, 1, 1)
end)

-- Thirds
hs.hotkey.bind(meh, "1", function()
	windows.moveAndResize(0, 0, 1 / 3, 1)
end) -- Left third
hs.hotkey.bind(meh, "2", function()
	windows.moveAndResize(1 / 3, 0, 1 / 3, 1)
end) -- Middle third
hs.hotkey.bind(meh, "3", function()
	windows.moveAndResize(2 / 3, 0, 1 / 3, 1)
end) -- Right third

-- Two thirds
hs.hotkey.bind(meh, "4", function()
	windows.moveAndResize(0, 0, 2 / 3, 1)
end) -- Left two thirds
hs.hotkey.bind(meh, "5", function()
	windows.moveAndResize(1 / 3, 0, 2 / 3, 1)
end) -- Right two thirds

-- 1/3rd width centered, 1/3rd height with top, middle, bottom
hs.hotkey.bind(meh, "6", function()
	windows.moveAndResize(1 / 3, 0, 1 / 3, 1 / 3)
end) -- Top third
hs.hotkey.bind(meh, "7", function()
	windows.moveAndResize(1 / 3, 1 / 3, 1 / 3, 1 / 3)
end) -- Middle third
hs.hotkey.bind(meh, "8", function()
	windows.moveAndResize(1 / 3, 2 / 3, 1 / 3, 1 / 3)
end) -- Bottom third

-- 16x9
hs.hotkey.bind(meh, "9", windows.resizeTo16by9)

-- Move to next/previous screen using hyper key
hs.hotkey.bind(hyper, "right", function()
	windows.moveToScreen("right")
end) -- Move to next screen
hs.hotkey.bind(hyper, "left", function()
	windows.moveToScreen("left")
end) -- Move to previous screen

-- Move to next/previous screen using Vim bindings with hyper key
hs.hotkey.bind(hyper, "L", function()
	windows.moveToScreen("right")
end) -- Move to next screen
hs.hotkey.bind(hyper, "H", function()
	windows.moveToScreen("left")
end) -- Move to previous screen

-- Move to specific screens
hs.hotkey.bind(hyper, "1", function()
	windows.moveToScreenIndex(1)
end)
hs.hotkey.bind(hyper, "2", function()
	windows.moveToScreenIndex(2)
end)
hs.hotkey.bind(hyper, "3", function()
	windows.moveToScreenIndex(3)
end)
hs.hotkey.bind(hyper, "4", function()
	windows.moveToScreenIndex(4)
end)

-- Keybindings for resizing the window
hs.hotkey.bind(meh, "up", function()
	windows.resizeWindow(0, 80)
end) -- Decrease height
hs.hotkey.bind(meh, "down", function()
	windows.resizeWindow(0, -80)
end) -- Increase height
hs.hotkey.bind(meh, "left", function()
	windows.resizeWindow(80, 0)
end) -- Decrease width
hs.hotkey.bind(meh, "right", function()
	windows.resizeWindow(-80, 0)
end) -- Increase width

-- Keybindings for proportional resizing
hs.hotkey.bind(meh, "=", function()
	windows.resizeWindowProportional(80)
end) -- Increase size
hs.hotkey.bind(meh, "-", function()
	windows.resizeWindowProportional(-80)
end) -- Decrease size

-- Print screen information
hs.hotkey.bind(hyper, "s", windows.listScreens)

return windows

