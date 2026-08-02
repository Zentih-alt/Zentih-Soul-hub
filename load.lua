-- [[ load.lua ]]
local url = "https://raw.githubusercontent.com/Zentih-alt/Zentih-Soul-hub/main/Game.lua"

local success, code = pcall(function()
    return game:HttpGet(url)
end)

if success and code and #code > 0 then
    local func, err = loadstring(code)
    if func then
        func()
    else
        warn("[Compile Error]:", err)
        game:GetService("Players").LocalPlayer:Kick("load.lua: Compile Error")
    end
else
    game:GetService("Players").LocalPlayer:Kick("load.lua: Failed to load Game.lua")
end
