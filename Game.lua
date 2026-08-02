-- [[ ZX LOADER (Repo A) ]]
local REPO_USER = "Zentih-alt"     -- เช็ค ยูสเซอร์เนม GitHub ให้ถูกต้อง
local REPO_NAME = "Zenith-Soul-hub" -- เช็คชื่อ Repo ให้ถูกต้อง
local BRANCH    = "main"

local url = string.format(
    "https://raw.githubusercontent.com/%s/%s/%s/Game.lua?v=%s",
    REPO_USER, REPO_NAME, BRANCH, os.time()
)

local success, code = pcall(function()
    return game:HttpGet(url, true)
end)

if success and code and #code > 0 and not code:find("404: Not Found") then
    local func, err = loadstring(code)
    if func then
        func()
    else
        warn("[Loader Error]:", err)
        game:GetService("Players").LocalPlayer:Kick("Loader: Compile Error")
    end
else
    game:GetService("Players").LocalPlayer:Kick("Loader: Failed to load Game.lua")
end
