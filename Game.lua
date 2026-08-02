-- [[ Main Selector (Repo B: Game.lua) ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local REPO_USER = "Zentih-alt"
local REPO_NAME = "Zentih-Soul-hub" -- แก้ชื่อ Repo ให้ตรงกับ GitHub แล้ว
local BRANCH    = "main"

-- รายชื่อเกมที่รองรับ [PlaceId] = "ชื่อไฟล์.lua"
local GameScripts = {
    [104761395312874] = "LP.lua",
    [119091355492870] = "Rock.lua",
    [1458767429]      = "ABA.lua",
    -- ถ้ามี PlaceID ของ Solar.lua เพิ่ม ให้เอามาใส่ตรงนี้ได้เลย
}

local function KickPlayer(reason)
    if LocalPlayer then
        LocalPlayer:Kick(reason or "Execution Error")
    end
end

local function GetFreshScript(fileName, retries)
    retries = retries or 3
    local rawUrl = string.format(
        "https://raw.githubusercontent.com/%s/%s/%s/%s?v=%s",
        REPO_USER, REPO_NAME, BRANCH, fileName, os.time()
    )

    for i = 1, retries do
        local success, result = pcall(function()
            return game:HttpGet(rawUrl, true)
        end)

        if success and result and #result > 0 and not result:find("404: Not Found") then
            return result
        end

        task.wait(1)
    end

    return nil
end

local function RunScript(file)
    local code = GetFreshScript(file)

    if not code then
        KickPlayer("Load Failed: " .. file)
        return
    end

    local func, compileErr = loadstring(code)

    if not func then
        warn("[Compile Error]:", compileErr)
        KickPlayer("Compile Failed: " .. file)
        return
    end

    local ok, runtimeErr = pcall(func)

    if not ok then
        warn("[Runtime Error]:", runtimeErr)
        KickPlayer("Runtime Failed: " .. file)
    end
end

-- เช็คเกมปัจจุบัน
local currentPlaceId = game.PlaceId
local targetFile = GameScripts[currentPlaceId]

if targetFile then
    RunScript(targetFile)
else
    KickPlayer("Game Not Supported (PlaceID: " .. tostring(currentPlaceId) .. ")")
end
