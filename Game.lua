-- [[ Game.lua ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BASE_URL = "https://raw.githubusercontent.com/Zentih-alt/Zentih-Soul-hub/main/"

-- รายชื่อเกม [PlaceId] = "ชื่อไฟล์.lua"
local GameScripts = {
    [104761395312874] = "LP.lua",
    [119091355492870] = "Rock.lua",
    [1458767429]      = "ABA.lua",

    -- Rock Dungeon / Map
    [8287810190702]   = "Rock.lua",
}

local targetFile = GameScripts[game.PlaceId]

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
            LocalPlayer:Kick("Compile Error: " .. targetFile)
        end

    else
        LocalPlayer:Kick("Load Failed: " .. targetFile)
    end

else
    LocalPlayer:Kick("Zenith ไม่รองรับแมพนี้")
end
