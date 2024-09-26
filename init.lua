-- ~/.hammerspoon/init.lua

-- Load and start the ReloadConfiguration Spoon
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- Load configuration
local config = require("config")

-- Initialize logger
local logger = require("utils.logger")

-- Load modules
for _, module in ipairs(config.modules) do
  local ok, err = pcall(require, "modules." .. module)
  if not ok then
      logger.e("Error loading module " .. module .. ": " .. err)
  end
end

-- Set up hints module
local hints = require("modules.hints")
hints.setup()

-- Log successful initialization
logger.i("Hammerspoon configuration loaded")