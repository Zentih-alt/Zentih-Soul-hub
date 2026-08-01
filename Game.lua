local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local REPO_USER = "Zentih-alt"
local REPO_NAME = "Zenith-Soul-hub"
local BRANCH = "main"

local function KickPlayer(reason)
    if LocalPlayer then
        LocalPlayer:Kick(reason or "Execution Error")
    end
end

local function GetFreshScript(fileName, retries)
    retries = retries or 3

    local url =
        "https://raw.githubusercontent.com/"
        .. REPO_USER
        .. "/"
        .. REPO_NAME
        .. "/"
        .. BRANCH
        .. "/"
        .. fileName

    local bustUrl =
        url
        .. "?t="
        .. tostring(math.random(100000,999999))
        .. tostring(os.time())

    for i = 1, retries do

        local success,result = pcall(function()

            return game:HttpGet(bustUrl,true)

        end)

        if success and result and #result > 0 then
            return result
        end

        task.wait(i)

    end

    return nil
end

local function RunScript(file)

    local code = GetFreshScript(file)

    if not code then
        KickPlayer("Load Failed")
        return
    end

    local func = loadstring(code)

    if not func then
        KickPlayer("Compile Failed")
        return
    end

    local ok = pcall(func)

    if not ok then
        KickPlayer("Runtime Failed")
    end

end

local GameScripts = {

    [104761395312874] = "LP.lua",
    [119091355492870] = "Rock.lua",
    [1458767429] = "ABA.lua",

}

local file = GameScripts[game.PlaceId]

if file then

    RunScript(file)

else

    KickPlayer("Game Not Supported")

end
