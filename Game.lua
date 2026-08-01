-- Game.lua

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local REPO_USER = "Zentih-alt"
local REPO_NAME = "Zenith-Soul-hub"
local BRANCH = "main"

local function KickPlayer(reason)
    if LocalPlayer then
        LocalPlayer:Kick(reason or "Zenith Soul: Execution Error")
    end
end

local function GetFreshScript(fileName, retries)
    retries = retries or 3
    local url = "https://raw.githubusercontent.com/" .. REPO_USER .. "/" .. REPO_NAME .. "/" .. BRANCH .. "/" .. fileName
    local bustUrl = url .. "?t=" .. tostring(math.random(1, 999999)) .. tostring(os.time())

    for i = 1, retries do
        local success, result = pcall(function()
            return game:HttpGet(bustUrl, true)
        end)

        if success and result and #result > 0 then
            return result
        end

        task.wait(1.5 * i)
    end

    return nil
end

local function RunScript(fileName)
    local code = GetFreshScript(fileName)
    if not code then
        KickPlayer("Zenith Soul: โหลดสคริปต์ไม่สำเร็จ กรุณาลองใหม่อีกครั้ง")
        return
    end

    local func = loadstring(code)
    if not func then
        KickPlayer("Zenith Soul: สคริปต์มีข้อผิดพลาด กรุณาติดต่อผู้พัฒนา")
        return
    end

    local ok = pcall(func)
    if not ok then
        KickPlayer("Zenith Soul: รันสคริปต์ไม่สำเร็จ กรุณาลองใหม่อีกครั้ง")
    end
end

local GameScripts = {
    [104761395312874] = "main.lua",
    [119091355492870] = "Rock.lua",
    [1458767429] = "ABA.lua",
}

local placeId = game.PlaceId
local scriptFile = GameScripts[placeId]

if scriptFile then
    RunScript(scriptFile)
else
    KickPlayer("Zenith Soul: ไม่รองรับเกมนี้")
end
