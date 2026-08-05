local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BASE_URL = "https://raw.githubusercontent.com/Zentih-alt/Zentih-Soul-hub/main/"

local GameScripts = {
    [104761395312874] = "LP.lua",
    [119091355492870] = "Rock.lua",
    [1458767429]      = "ABA.lua",
}

-- รองรับ Dungeon / Sub Place
local GameGroups = {
    [10008473853] = "LP.lua",
}

local targetFile = GameScripts[game.PlaceId]

if not targetFile then
    targetFile = GameGroups[game.GameId]
end

if targetFile then
    local success, code = pcall(function()
        return game:HttpGet(BASE_URL .. targetFile)
    end)

    if success and code and #code > 0 then
        local func, err = loadstring(code)

        if func then
            func()
        else
            warn("[Compile Error]:", err)
        end
    else
        LocalPlayer:Kick("Load Failed: "..targetFile)
    end
else
    LocalPlayer:Kick(
        "Game Not Supported\nPlaceID: "..game.PlaceId
    )
end
