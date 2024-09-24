-- ~/.hammerspoon/utils/logger.lua

local logger = {}

function logger.i(...)
    print(os.date(), "INFO", ...)
end

function logger.w(...)
    print(os.date(), "WARN", ...)
end

function logger.e(...)
    print(os.date(), "ERROR", ...)
end

return logger