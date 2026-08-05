local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

repeat task.wait() until LocalPlayer

task.wait(3)

local BASE_URL = "https://raw.githubusercontent.com/Zentih-alt/Zentih-Soul-hub/main/"

local GameScripts = {
    [104761395312874] = "LP.lua",
    [119091355492870] = "Rock.lua",
    [1458767429] = "ABA.lua",
}

local GameGroups = {
    [10008473853] = "LP.lua",
}

local targetFile = GameScripts[game.PlaceId] or GameGroups[game.GameId]

print("Loading:", targetFile)
print("Place:", game.PlaceId)
print("Game:", game.GameId)

if targetFile then
    local success, code = pcall(function()
        return game:HttpGet(BASE_URL .. targetFile)
    end)

    if success then
        local func, err = loadstring(code)

        if func then
            task.spawn(func)
        else
            warn(err)
        end
    else
        warn("HttpGet Failed")
    end
else
    warn("No Script Found")
end
