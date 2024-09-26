-- ~/.hammerspoon/modules/hints.lua

local hints = {}
local hsHints = require "hs.hints"
local window = require "hs.window"
local timer = require "hs.timer"
local logger = require("utils.logger")

-- Configuration (keep existing configuration)
hsHints.hintChars = {'J','F','K','D','L','S','A','H','G','Y','U','I','O','P','Q','W','E','R','T','M','N','B','V','C','X','Z'}
hsHints.fontSize = 18
hsHints.showTitleThresh = 0
hsHints.titleMaxSize = 16
hsHints.style = "default"
hsHints.iconAlpha = 0.7
hsHints.fontName = "Helvetica-Bold"

-- Optimize window filtering
local function getValidWindows(allowNonStandard)
    local allWindows = window.allWindows()
    local validWindows = {}
    for _, win in ipairs(allWindows) do
        if allowNonStandard or win:isStandard() then
            table.insert(validWindows, win)
        end
    end
    return validWindows
end

-- Optimize hint character generation
local function generateHintChars(windowCount)
    local chars = {}
    local hintCharsLength = #hsHints.hintChars
    for i = 1, windowCount do
        local char = hsHints.hintChars[(i - 1) % hintCharsLength + 1]
        if i > hintCharsLength then
            char = chars[math.floor((i - 1) / hintCharsLength)] .. char
        end
        table.insert(chars, char)
    end
    return chars
end

local function showHints()
    logger.i("Triggered window hints")
    local validWindows = getValidWindows(true)
    hsHints.windowHints(validWindows)
end

function hints.setup()
    hs.hotkey.bind({"cmd", "alt"}, "H", function()
        local startTime = timer.secondsSinceEpoch()
        
        showHints()
        
        -- Use a delayed timer to measure the total time, including hint display
        timer.doAfter(0.1, function()
            local endTime = timer.secondsSinceEpoch()
            local duration = endTime - startTime
            logger.i(string.format("Total hint process took %.3f seconds", duration))
        end)
    end)
end

return hints