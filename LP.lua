local Fluent = nil
local Success, Error = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not Success then
    return
end

Fluent = Error

-- Declaring elements for UI
local AutoAizenToggle
local AutoStartPortalToggle
local AutoStartGameInPortalToggle
local AutoPityToggle

-- ==========================================
-- ANTI CONSOLE SPAM (Safe Check สำหรับ Solara / Wave / Mobile)
-- ==========================================
if hookfunction and getrenv then
    pcall(function()
        local oldWarn
        oldWarn = hookfunction(getrenv().warn, newcclosure(function(...)
            return
        end))
        
        local oldPrint
        oldPrint = hookfunction(getrenv().print, newcclosure(function(...)
            local args = {...}
            if #args > 0 then
                local str = tostring(args[1])
                if str:find("VFX") or str:find("vfx") or str:find("Table") or str:find("table") or str:find("Missing") then
                    return
                end
            end
            return oldPrint(...)
        end))
    end)
end

-- ==========================================
-- DEFAULT CONFIGURATION (For Reset)
-- ==========================================
local DefaultConfig = {
    SelectedWeapon          = "None",
    AutoEquip               = false,
    FarmAngle               = "Behind",
    DistanceBehind          = 7.5,
    TargetMonster           = "None",
    FarmEnabled             = false,
    
    AutoStoneEnabled        = false,
    
    SummonBossEnabled       = false,
    SelectedSummonBoss      = "Sukuna",

    BattleBossEnabled       = false,
    SelectedBattleBoss      = "Verdant Hero",

    PriorityBossEnabled     = false,
    SelectedPriorityBoss    = "Sung Jinwoo",

    SummonRimuruEnabled     = false,
    AutoAizenEnabled        = false,

    -- [NEW] God System Config
    AutoGodSummonEnabled    = false,
    SelectedGodBoss         = "Gilgamesh",
    SelectedGodDifficulty   = "Easy",

    AutoStatsEnabled        = false,
    SelectedStat            = "Strength",
    StatsAmount             = 1,

    SelectedTeleportTarget  = "None",
    SearchTeleportName      = "",

    SelectedTheme           = "Deep Dark",
    AntiAFKEnabled          = false,
    LowLagMode              = false,

    AutoJoinTower           = false,
    AutoKillTower           = false,

    SelectedPortalDifficulty = "Easy",
    SelectedPortalName       = "SHADOW",
    AutoStartPortal          = false,
    AutoStartGameInPortal    = false,
    
    -- Auto Pity System Config
    AutoPitySystem           = false,
    PityTargetValue          = 24,
    
    -- Auto Skill Config (Multi-Select)
    AutoSkillEnabled         = false,
    SelectedSkills           = {} 
}

local Config = {}
for k, v in pairs(DefaultConfig) do Config[k] = v end

-- ==========================================
-- SYSTEM VARIABLES
-- ==========================================
local LastTargetQuest = "None"
local CurrentFarmTarget = nil
local IsFarmingActive = false
local IsSwitchingTarget = false
local LastSafePosition = nil
local LastRimuruSummonTime = 0
local PityReachedTime = nil 
local PityDelayTime = 15.0 -- หน่วงเวลา 15 วิ ก่อนเริ่มระบบแลกของ/ลงประตู

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

local SaveFolder = "ZenithSoulHub"
local SaveFile = SaveFolder .. "/Config.json"

-- ==========================================
-- CORE FUNCTIONS
-- ==========================================
local function SaveConfig()
    pcall(function()
        if writefile and isfolder and makefolder then
            if not isfolder(SaveFolder) then makefolder(SaveFolder) end
            writefile(SaveFile, HttpService:JSONEncode(Config))
        end
    end)
end

local function LoadConfig()
    pcall(function()
        if isfolder and isfile and readfile then
            if isfolder(SaveFolder) and isfile(SaveFile) then
                local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(SaveFile)) end)
                if success and type(decoded) == "table" then
                    for k, v in pairs(decoded) do
                        if Config[k] ~= nil then Config[k] = v end
                    end
                end
            end
        end
    end)
end
LoadConfig()

local function ResetEverything()
    for k, v in pairs(DefaultConfig) do
        Config[k] = v
    end
    SaveConfig()
    task.wait(0.5)
end

local function UpdateLowLag()
    if Config.LowLagMode then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
    end
end

-- ==========================================
-- DATABASE & MAPS
-- ==========================================
local StaticMonsterList = {
    "Bandit [Lv.1]", "Bandit Leader [Lv.50]", "Monkey [Lv.250]", "Shank [Lv.400]",
    "Snow Bandit [Lv.600]", "Mihawk [Lv.800]", "National Level Hunter [Lv.1000]",
    "Sorcerer Student [Lv.1300]", "Miwa [Lv.1600]", "Hollow [Lv.2000]",
    "Arrancar [Lv.2500]", "Ichigo ( Bankai ) [Lv.4000]"
}

local QuestIDs = {
    ["Bandit"] = 1, ["Bandit Leader"] = 2, ["Monkey"] = 3, ["Shank"] = 4,
    ["Snow Bandit"] = 8, ["Mihawk"] = 7, ["National Level Hunter"] = 9,
    ["Sorcerer Student"] = 5, ["Miwa"] = 6, ["Hollow"] = 10,
    ["Arrancar"] = 11, ["Sung Jinwoo"] = 13, ["Ichigo ( Bankai )"] = 12
}

local CustomThemes = {
    ["Deep Dark"] = { Accent = Color3.fromRGB(85, 170, 255), Background = Color3.fromRGB(5, 5, 5), LightContrast = Color3.fromRGB(10, 10, 10), DarkContrast = Color3.fromRGB(2, 2, 2), TextColor = Color3.fromRGB(255, 255, 255) },
    ["Midnight"] = { Accent = Color3.fromRGB(0, 120, 215), Background = Color3.fromRGB(10, 12, 18), LightContrast = Color3.fromRGB(15, 18, 25), DarkContrast = Color3.fromRGB(5, 6, 10), TextColor = Color3.fromRGB(240, 240, 250) },
    ["Charcoal"] = { Accent = Color3.fromRGB(200, 200, 200), Background = Color3.fromRGB(15, 15, 15), LightContrast = Color3.fromRGB(22, 22, 22), DarkContrast = Color3.fromRGB(8, 8, 8), TextColor = Color3.fromRGB(230, 230, 230) },
    ["Black"]    = { Accent = Color3.fromRGB(255, 255, 255), Background = Color3.fromRGB(0, 0, 0), LightContrast = Color3.fromRGB(5, 5, 5), DarkContrast = Color3.fromRGB(2, 2, 2), TextColor = Color3.fromRGB(255, 255, 255) },
    ["White"]    = { Accent = Color3.fromRGB(0, 0, 0), Background = Color3.fromRGB(245, 245, 245), LightContrast = Color3.fromRGB(230, 230, 230), DarkContrast = Color3.fromRGB(220, 220, 220), TextColor = Color3.fromRGB(10, 10, 10) },
    ["Purple"]   = { Accent = Color3.fromRGB(170, 85, 255), Background = Color3.fromRGB(15, 10, 20), LightContrast = Color3.fromRGB(20, 15, 25), DarkContrast = Color3.fromRGB(10, 5, 15), TextColor = Color3.fromRGB(240, 230, 250) }
}

local function applyCustomTheme(themeName)
    local themeData = CustomThemes[themeName]
    if themeData and Window then
        for Key, Value in pairs(themeData) do
            pcall(function() Fluent.ThemeManager:SetColor(Key, Value) end)
        end
    end
end

local function isAlive(entity)
    if not entity or not entity:IsDescendantOf(workspace) then return false end
    local humanoid = entity:FindFirstChildOfClass("Humanoid")
    if humanoid then
        return humanoid.Health > 0
    end
    
    local specialBosses = {
        ["Stone"] = true, ["Stone1"] = true, 
        ["Sung Jinwoo"] = true, ["Rimuru"] = true, 
        ["Aizen"] = true, ["Sukuna"] = true, 
        ["Gojo"] = true, 
        ["Verdant Hero"] = true, ["Saber"] = true,
        ["Gilgamesh"] = true
    }
    
    if specialBosses[entity.Name] then
        if entity:IsA("Model") and not entity:FindFirstChild("HumanoidRootPart") and not entity:FindFirstChild("Humanoid") then
            return false
        end
        if entity:IsA("BasePart") and entity.Transparency == 1 then
            return false
        end
        return true
    end
    return false
end

local function getCleanName(fullName)
    return fullName:gsub("%s*%[Lv%.%s*%d+%]", ""):gsub("%s*%[Lv%.%s*Unknown%]", "")
end

local function switchQuest(newMonsterName)
    local questId = QuestIDs[newMonsterName]
    if not questId then return end
    local rs = game:GetService("ReplicatedStorage")
    local qEvent = rs:FindFirstChild("QuestEvent", true) or rs:FindFirstChild("RE/QuestEvent", true)
    if qEvent then
        qEvent:FireServer("Cancel")
        task.wait(0.2)
        qEvent:FireServer("Request", { Id = questId })
    end
end

-- ==========================================
-- BOSS SUMMON SYSTEM FIX 
-- ==========================================
local function summonBoss(bossName)
    pcall(function()
        local args = { "Summon", { Boss = bossName } }
        
        -- ใช้พาธที่ผู้ใช้ต้องการก่อน เพื่อความแน่นอนในการเชื่อมต่อ
        local pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
        if pkgs then
            local idx = pkgs:FindFirstChild("_Index")
            if idx and idx:FindFirstChild("sleitnick_net@0.2.0") then
                local snet = idx["sleitnick_net@0.2.0"]:FindFirstChild("net")
                if snet and snet:FindFirstChild("RE/SummonEvent") then
                    snet["RE/SummonEvent"]:FireServer(unpack(args))
                    return
                end
            end
        end
        
        -- Fallback ปกติเผื่อหลุด
        local rs = game:GetService("ReplicatedStorage")
        local sEvent = rs:FindFirstChild("SummonEvent", true) or rs:FindFirstChild("RE/SummonEvent", true)
        if sEvent then 
            sEvent:FireServer(unpack(args)) 
        end
    end)
end

local function summonRimuru()
    pcall(function()
        local args = { "SummonSlime", { Amount = 1 } }
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/SummonerEvent"):FireServer(unpack(args))
    end)
end

local function allocateStat(statName, amount)
    local rs = game:GetService("ReplicatedStorage")
    local aEvent = rs:FindFirstChild("StatsAllocateEvent", true) or rs:FindFirstChild("RE/StatsAllocateEvent", true)
    if aEvent then aEvent:FireServer(statName, amount) end
end

-- ==========================================
-- OPTIMIZED ENTITY FINDER 
-- ==========================================
local TargetFolders = {"Enemies", "Boss", "NPC", "Mobs", "Spawned"}

local function getEntityInFolders(cleanName)
    for _, fName in ipairs(TargetFolders) do
        local folder = workspace:FindFirstChild(fName)
        if folder then
            for _, v in ipairs(folder:GetChildren()) do
                if v.Name == cleanName and isAlive(v) then return v end
                local subTarget = v:FindFirstChild(cleanName)
                if subTarget and isAlive(subTarget) then return subTarget end
            end
        end
    end
    return nil
end

local function checkSpecificBossExists(bossName)
    local cleanName = getCleanName(bossName)
    local bossFolder = workspace:FindFirstChild("Boss")
    if bossFolder then
        local directBoss = bossFolder:FindFirstChild(cleanName)
        if directBoss and isAlive(directBoss) then return directBoss end
        
        for _, v in ipairs(bossFolder:GetChildren()) do
            if v.Name == cleanName and isAlive(v) then return v end
            local inner = v:FindFirstChild(cleanName)
            if inner and isAlive(inner) then return inner end
        end
    end
    return getEntityInFolders(cleanName)
end

local function getWeaponList()
    local list = {}
    if LocalPlayer then
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
             if tool:IsA("Tool") then table.insert(list, tool.Name) end
        end
        if LocalPlayer.Character then
            for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                 if tool:IsA("Tool") then table.insert(list, tool.Name) end
            end
        end
    end
    return list
end

-- ==========================================
-- AUTO PITY UI PARSING FUNCTION
-- ==========================================
local function getCurrentPity()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local bossGui = playerGui and playerGui:FindFirstChild("ScreenGui") and playerGui.ScreenGui:FindFirstChild("Boss")
    if bossGui then
        for _, child in ipairs(bossGui:GetChildren()) do
            if child.Name:find("Verdant Hero") then
                local pityObj = child:FindFirstChild("BossPity") or (child:FindFirstChild("BossFrame") and child.BossFrame:FindFirstChild("BossPity"))
                if pityObj and (pityObj:IsA("TextLabel") or pityObj:IsA("TextBox")) then
                    local text = pityObj.Text
                    local current = text:match("(%d+)")
                    if current then
                        return tonumber(current)
                    end
                end
            end
        end
    end
    return 0
end

local function isInDungeon()
    local mapFolder = workspace:FindFirstChild("Map")
    if mapFolder then
        if mapFolder:FindFirstChild("CASTLE") or mapFolder:FindFirstChild("RAIDEN") then
            return true
        end
    end
    return false
end

-- ==========================================
-- AUTO AIZEN SYSTEM FUNC
-- ==========================================
local function AutoAizenSystem()
    pcall(function()
        if Config.AutoAizenEnabled and not checkSpecificBossExists("Aizen") then
            local aizenNPC = workspace:FindFirstChild("NPC") and workspace.NPC:FindFirstChild("AizenSummon") and workspace.NPC.AizenSummon:FindFirstChild("AizenSummonNPC")
            if aizenNPC then
                local prompt = aizenNPC:FindFirstChildOfClass("ProximityPrompt") or aizenNPC:FindFirstChild("ProximityPrompt", true)
                if prompt then
                    prompt.MaxActivationDistance = 10000
                    prompt.RequiresLineOfSight = false
                    
                    local actionTextLabel = LocalPlayer.PlayerGui:FindFirstChild("ProximityPrompts") and LocalPlayer.PlayerGui.ProximityPrompts:FindFirstChild("Prompt") and LocalPlayer.PlayerGui.ProximityPrompts.Prompt.Frame.TextFrame.ActionText
            
                    if actionTextLabel and (actionTextLabel.Text == "50/50" or string.find(actionTextLabel.Text, "50/50")) then
                        if fireproximityprompt then
                            fireproximityprompt(prompt)
                        else
                            pcall(function() fireproximityprompt(prompt) end)
                        end
                    end
                end
            end
        end
    end)
end

-- ==========================================
-- PRIORITY TARGET SYSTEM
-- ==========================================
local function findTarget(currentTarget)
    local currentPity = getCurrentPity()
    
    local isPitySystemActive = Config.AutoPitySystem
    if isInDungeon() then
        isPitySystemActive = false
    end
    
    local isPityNotReady = (isPitySystemActive and currentPity < Config.PityTargetValue)

    local isInternalKillPortalEnabled = Config.AutoStartGameInPortal
    if isPityNotReady then
        isInternalKillPortalEnabled = false 
    end

    if isInDungeon() and (Config.AutoKillTower or isInternalKillPortalEnabled) then
        if currentTarget and isAlive(currentTarget) then
            local hum = currentTarget:FindFirstChild("Humanoid")
            local isTowerMonster = currentTarget.Name:lower():find("tower")
            local isGameBoss = (hum and hum.MaxHealth >= 10000)
            if isTowerMonster or isGameBoss then return currentTarget, false, 0 end
        end
        for _, fName in ipairs(TargetFolders) do
            local folder = workspace:FindFirstChild(fName)
            if folder then
                for _, v in ipairs(folder:GetChildren()) do
                    if v:IsA("Model") and isAlive(v) then 
                        local hum = v:FindFirstChild("Humanoid")
                        local isTowerMonster = v.Name:lower():find("tower")
                        local isGameBoss = (hum and hum.MaxHealth >= 10000)
                        if isTowerMonster or isGameBoss then return v, false, 0 end
                    end
                end
            end
        end
    end

    if isPitySystemActive and isPityNotReady and not isInDungeon() then
        local vHero = checkSpecificBossExists("Verdant Hero")
        if vHero then 
            return vHero, false, 1  
        else 
            return nil, false, 1 
        end
    end

    if (Config.AutoKillTower or isInternalKillPortalEnabled) then
        if currentTarget and isAlive(currentTarget) then
            local hum = currentTarget:FindFirstChild("Humanoid")
            local isTowerMonster = currentTarget.Name:lower():find("tower")
            local isGameBoss = (hum and hum.MaxHealth >= 10000)
            if isTowerMonster or isGameBoss then return currentTarget, false, 4 end
        end
        for _, fName in ipairs(TargetFolders) do
            local folder = workspace:FindFirstChild(fName)
            if folder then
                for _, v in ipairs(folder:GetChildren()) do
                    if v:IsA("Model") and isAlive(v) then 
                        local hum = v:FindFirstChild("Humanoid")
                        local isTowerMonster = v.Name:lower():find("tower")
                        local isGameBoss = (hum and hum.MaxHealth >= 10000)
                        if isTowerMonster or isGameBoss then return v, false, 4 end
                    end
                end
            end
        end
    end

    if Config.AutoStoneEnabled then
        if currentTarget and (currentTarget.Name == "Stone" or currentTarget.Name == "Stone1") and isAlive(currentTarget) then
            return currentTarget, false, 1
        end
        local bossFolder = workspace:FindFirstChild("Boss")
        if bossFolder then
            local stoneInner = bossFolder:FindFirstChild("Stone")
            if stoneInner and isAlive(stoneInner) then return stoneInner, false, 1 end
            local stone1 = bossFolder:FindFirstChild("Stone1")
            if stone1 then
                local sInner = stone1:FindFirstChild("Stone")
                if sInner and isAlive(sInner) then
                    return sInner, false, 1
                elseif isAlive(stone1) then
                    return stone1, false, 1
                end
            end
        end
    end

    if Config.PriorityBossEnabled then
        local priorityList = {"Sung Jinwoo", "Rimuru"}
        if Config.SelectedPriorityBoss ~= "None" then
            table.insert(priorityList, 1, Config.SelectedPriorityBoss)
        end
        for _, bossName in ipairs(priorityList) do
            local boss = checkSpecificBossExists(bossName)
            if boss then return boss, false, 2 end
        end
    end
    
    if Config.AutoGodSummonEnabled then
        local gilgamesh = checkSpecificBossExists("Gilgamesh")
        if gilgamesh then return gilgamesh, false, 2 end
        
        if not isPityNotReady then
            local cleanName = "Snow Bandit"
            if currentTarget and currentTarget.Name == cleanName and isAlive(currentTarget) then
                return currentTarget, true, 3
            end
            local snowBandit = getEntityInFolders(cleanName)
            if snowBandit then return snowBandit, true, 3 end
        end
    end

    if Config.AutoAizenEnabled then
        local aizen = checkSpecificBossExists("Aizen")
        if aizen then return aizen, false, 3 end
        if currentTarget and currentTarget.Name == "Hollow" and isAlive(currentTarget) then
            return currentTarget, true, 3
        end
        local hollow = getEntityInFolders("Hollow")
        if hollow then return hollow, true, 3 end
    end

    if Config.BattleBossEnabled and Config.SelectedBattleBoss ~= "None" then
        local boss = checkSpecificBossExists(Config.SelectedBattleBoss)
        if boss then return boss, false, 4 end
    end
    
    if Config.SummonBossEnabled and Config.SelectedSummonBoss ~= "None" then
        local boss = checkSpecificBossExists(Config.SelectedSummonBoss)
        if boss then return boss, false, 4 end
    end

    if Config.FarmEnabled and Config.TargetMonster ~= "None" then
        local cleanName = getCleanName(Config.TargetMonster)
        if currentTarget and currentTarget.Name == cleanName and isAlive(currentTarget) then
            return currentTarget, true, 4
        end
        
        if cleanName == "Ichigo ( Bankai )" then
            local ichigoFolder = workspace:FindFirstChild("Enemies") and workspace.Enemies:FindFirstChild("Ichigo ( Bankai )")
            if ichigoFolder then
                for _, v in ipairs(ichigoFolder:GetChildren()) do
                     if v.Name == "Ichigo ( Bankai )" and isAlive(v) then
                        return v, true, 4
                     end
                end
            end
        end
        
        local target = getEntityInFolders(cleanName)
        if target then return target, true, 4 end
    end
    return nil, false, 4
end

-- ==========================================
-- WINDOW CREATION
-- ==========================================
local Window = Fluent:CreateWindow({
    Title = "Zenith Soul Hub",
    SubTitle = "lineage piece",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local HubTabs = {
    Main     = Window:AddTab({ Title = "Main", Icon = "home" }),
    Farm     = Window:AddTab({ Title = "Farm", Icon = "swords" }),
    Boss     = Window:AddTab({ Title = "Boss", Icon = "skull" }),
    Dungeon  = Window:AddTab({ Title = "Dungeon", Icon = "shield" }),
    Stats    = Window:AddTab({ Title = "Stats", Icon = "bar-chart" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- ==========================================
-- TAB: MAIN
-- ==========================================
local MainSection = Window or HubTabs.Main:AddSection("Welcome back")
HubTabs.Main:AddParagraph({
    Title = "Zenith Soul Hub",
    Content = "เปิดใหม่นะครับจะปล่อยให้ฟรีตลอดกับเเยกเสียตัง."
})

-- ==========================================
-- TAB: FARM
-- ==========================================
local WeaponSection = HubTabs.Farm:AddSection("Weapon Settings")
local WeaponDropdown = HubTabs.Farm:AddDropdown("WeaponDropdown", { Title = "Select Melee / Weapon", Description = "เลือกอาวุธ", Values = getWeaponList(), Default = Config.SelectedWeapon, Callback = function(Value) Config.SelectedWeapon = Value end })
HubTabs.Farm:AddToggle("AutoEquipToggle", { Title = "Auto Equip", Description = "", Default = Config.AutoEquip, Callback = function(Value) Config.AutoEquip = Value end })
HubTabs.Farm:AddButton({ Title = "Refresh Weapons List", Description = "กดอัปเดตรายชื่ออาวุธใหม่ในตัว", Callback = function() WeaponDropdown:SetValues(getWeaponList()) end })

local PositionSection = HubTabs.Farm:AddSection("Position Settings")
local AngleDropdown = HubTabs.Farm:AddDropdown("AngleDropdown", { Title = "Attack Position / Angle", Description = "", Values = { "Behind", "Above", "Below" }, Default = Config.FarmAngle, Callback = function(Value) Config.FarmAngle = Value end })
HubTabs.Farm:AddInput("DistanceInput", { Title = "Distance Offset Range", Description = "ระยะห่างระหว่างตัวละครกับมอนสเตอร์", Default = tostring(Config.DistanceBehind), Numeric = true, Finished = true, Callback = function(Value) Config.DistanceBehind = tonumber(Value) or 7.5 end })

local FarmSection = HubTabs.Farm:AddSection("Farm Monster")
local MonsterDropdown = HubTabs.Farm:AddDropdown("MonsterDropdown", { Title = "Select Monster", Description = " ", Values = StaticMonsterList, Default = Config.TargetMonster, Callback = function(Value) Config.TargetMonster = Value end })
HubTabs.Farm:AddToggle("FarmToggle", { Title = "Auto Farm", Description = "open", Default = Config.FarmEnabled, Callback = function(Value) Config.FarmEnabled = Value end })

local NaturalBossSection = HubTabs.Farm:AddSection("Natural Boss Farm")
HubTabs.Farm:AddToggle("AutoStoneToggle", { Title = "Auto Kill Stone Boss", Description = "Most important", Default = Config.AutoStoneEnabled, Callback = function(Value) Config.AutoStoneEnabled = Value end })

-- ==========================================
-- TAB: BOSS
-- ==========================================
local SummonSection = HubTabs.Boss:AddSection("Boss Summon")
local SummonDropdown = HubTabs.Boss:AddDropdown("SummonDropdown", { Title = "Select Summon Boss", Description = "Spawn BOSS v1", Values = { "Sukuna", "Gojo" }, Default = Config.SelectedSummonBoss, Callback = function(Value) Config.SelectedSummonBoss = Value end })
HubTabs.Boss:AddToggle("AutoSummonToggle", { Title = "Auto Summon Boss", Description = "go", Default = Config.SummonBossEnabled, Callback = function(Value) Config.SummonBossEnabled = Value end })

local BattleSection = HubTabs.Boss:AddSection("Special Bosses")
AutoAizenToggle = HubTabs.Boss:AddToggle("AutoAizenToggle", {
    Title = "Auto Farm Aizen",
    Description = "Kill Hollows -> Check 0/50 -> Summon Aizen -> Kill",
    Default = Config.AutoAizenEnabled,
    Callback = function(Value) 
        Config.AutoAizenEnabled = Value
        if Value then
            Config.AutoStartPortal = false
            Config.AutoStartGameInPortal = false
            if AutoStartPortalToggle then AutoStartPortalToggle:SetValue(false) end
            if AutoStartGameInPortalToggle then AutoStartGameInPortalToggle:SetValue(false) end
        end
        if not Value then
            pcall(function()
                local aizenNPC = workspace:FindFirstChild("NPC") and workspace.NPC:FindFirstChild("AizenSummon") and workspace.NPC.AizenSummon:FindFirstChild("AizenSummonNPC")
                if aizenNPC then
                    local prompt = aizenNPC:FindFirstChildOfClass("ProximityPrompt") or aizenNPC:FindFirstChild("ProximityPrompt", true)
                    if prompt then
                        prompt.MaxActivationDistance = 10
                        prompt.RequiresLineOfSight = true
                    end
                end
            end)
        end
    end
})

local BattleBossDropdown = HubTabs.Boss:AddDropdown("BattleBossDropdown", { Title = "Select Battle Boss", Description = "Spawn Boss V2", Values = { "Verdant Hero", "Saber" }, Default = Config.SelectedBattleBoss, Callback = function(Value) Config.SelectedBattleBoss = Value end })
HubTabs.Boss:AddToggle("AutoBossToggle", { Title = "Auto Boss", Description = "", Default = Config.BattleBossEnabled, Callback = function(Value) Config.BattleBossEnabled = Value end })

local PrioritySection = HubTabs.Boss:AddSection("Priority Targets")
local PriorityDropdown = HubTabs.Boss:AddDropdown("PriorityDropdown", { Title = "Select Target Boss", Description = "", Values = { "Sung Jinwoo", "Rimuru" }, Default = Config.SelectedPriorityBoss, Callback = function(Value) Config.SelectedPriorityBoss = Value end })
HubTabs.Boss:AddToggle("PriorityToggle", { Title = "Auto Farm Boss", Description = "Most important 3", Default = Config.PriorityBossEnabled, Callback = function(Value) Config.PriorityBossEnabled = Value end })

HubTabs.Boss:AddToggle("AutoSummonRimuruToggle", { 
    Title = "Summon Rimuru", 
    Description = "Spawn Rimuru", 
    Default = Config.SummonRimuruEnabled, 
    Callback = function(Value) 
        Config.SummonRimuruEnabled = Value 
        if Value then LastRimuruSummonTime = 0 end
    end 
})

-- ==========================================
-- [NEW] SUMMON GOD SYSTEM
-- ==========================================
local GodSection = HubTabs.Boss:AddSection("Summon v3")
HubTabs.Boss:AddDropdown("GodBossDropdown", { 
    Title = "Select God Boss", 
    Values = { "Gilgamesh" }, 
    Default = Config.SelectedGodBoss, 
    Callback = function(Value) Config.SelectedGodBoss = Value end 
})
HubTabs.Boss:AddDropdown("GodDifficultyDropdown", { 
    Title = "Select Difficulty", 
    Description = "", 
    Values = { "Easy", "Medium", "Hard", "Extreme" }, 
    Default = Config.SelectedGodDifficulty, 
    Callback = function(Value) Config.SelectedGodDifficulty = Value end 
})
HubTabs.Boss:AddToggle("AutoGodSummonToggle", { 
    Title = "Auto Summon & Farm GOD", 
    Description = "kills Snow Bandit [Lv.600] -> open -> opne -> kills", 
    Default = Config.AutoGodSummonEnabled, 
    Callback = function(Value) Config.AutoGodSummonEnabled = Value end 
})

local PitySection = HubTabs.Boss:AddSection("Auto Pity System (Verdant Hero)")
AutoPityToggle = HubTabs.Boss:AddToggle("AutoPityToggle", {
    Title = "Enable Auto Pity System",
    Description = "Farm pity",
    Default = Config.AutoPitySystem,
    Callback = function(Value)
        Config.AutoPitySystem = Value
    end
})
HubTabs.Boss:AddInput("PityTargetInput", {
    Title = "Pity Target Value",
    Description = "0-25 add",
    Default = tostring(Config.PityTargetValue),
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        Config.PityTargetValue = tonumber(Value) or 24
    end
})

-- ==========================================
-- TAB: DUNGEON
-- ==========================================
local DungeonSection = HubTabs.Dungeon:AddSection("Tower Systems")
HubTabs.Dungeon:AddToggle("AutoJoinTowerToggle", { Title = "Auto Join Tower", Default = Config.AutoJoinTower, Callback = function(Value) Config.AutoJoinTower = Value end })
HubTabs.Dungeon:AddToggle("AutoKillTowerToggle", { Title = "Auto Kill Tower", Default = Config.AutoKillTower, Callback = function(Value) Config.AutoKillTower = Value end })

local PortalSection = HubTabs.Dungeon:AddSection("Portal Systems")
HubTabs.Dungeon:AddDropdown("PortalDifficultyDropdown", { Title = "Portal Level", Values = { "Easy", "Medium", "Hard", "Extreme" }, Default = Config.SelectedPortalDifficulty, Callback = function(Value) Config.SelectedPortalDifficulty = Value end })
HubTabs.Dungeon:AddDropdown("PortalNameDropdown", { Title = "Portal", Values = { "SHADOW", "RAIDEN" }, Default = Config.SelectedPortalName, Callback = function(Value) Config.SelectedPortalName = Value end })

AutoStartPortalToggle = HubTabs.Dungeon:AddToggle("AutoStartPortalToggle", { 
    Title = "AutoStart Portal", 
    Default = Config.AutoStartPortal, 
    Callback = function(Value) 
        Config.AutoStartPortal = Value 
        if Value then
            Config.AutoAizenEnabled = false
            if AutoAizenToggle then AutoAizenToggle:SetValue(false) end
        end
    end 
})

AutoStartGameInPortalToggle = HubTabs.Dungeon:AddToggle("AutoStartGameInPortalToggle", { 
    Title = "Auto Kill Portal", 
    Default = Config.AutoStartGameInPortal, 
    Callback = function(Value) 
        Config.AutoStartGameInPortal = Value 
        if Value then
            Config.AutoAizenEnabled = false
            if AutoAizenToggle then AutoAizenToggle:SetValue(false) end
        end
    end 
})

-- ==========================================
-- TAB: STATS
-- ==========================================
local StatsSection = HubTabs.Stats:AddSection("Auto Allocate Points")
local StatSelectionDropdown = HubTabs.Stats:AddDropdown("StatSelectionDropdown", { Title = "Select Stat Type", Values = { "Strength", "Defense", "Weapon", "Power" }, Default = Config.SelectedStat, Callback = function(Value) Config.SelectedStat = Value end })
HubTabs.Stats:AddInput("StatAmountInput", { Title = "Stat Points Amount", Default = tostring(Config.StatsAmount), Numeric = true, Finished = true, Callback = function(Value) Config.StatsAmount = tonumber(Value) or 1 end })
HubTabs.Stats:AddToggle("AutoStatsToggle", { Title = "Enable Auto Stats", Default = Config.AutoStatsEnabled, Callback = function(Value) Config.AutoStatsEnabled = Value end })

local SkillSection = HubTabs.Stats:AddSection("Auto Skills (In-Game System)")
HubTabs.Stats:AddToggle("AutoSkillToggle", { 
    Title = "Enable Auto Skill", 
    Description = "OFF BOSS", 
    Default = Config.AutoSkillEnabled, 
    Callback = function(Value) 
        Config.AutoSkillEnabled = Value 
    end 
})

HubTabs.Stats:AddDropdown("SkillSelectDropdown", {
    Title = "Select Skills to Auto",
    Description = "skills open",
    Values = {"Z", "X", "C", "V", "F", "R"},
    Multi = true,
    Default = Config.SelectedSkills,
    Callback = function(Value)
        Config.SelectedSkills = Value
    end
})

-- ==========================================
-- TAB: TELEPORT
-- ==========================================
local TeleportSection = HubTabs.Teleport:AddSection("Instant Teleportation")
HubTabs.Teleport:AddInput("SearchBarInput", { Title = "Search World Target", Callback = function(Value) Config.SearchTeleportName = Value:lower() end })
local TeleportDropdown = HubTabs.Teleport:AddDropdown("TeleportDropdown", { Title = "Select Map Target", Values = StaticMonsterList, Default = Config.SelectedTeleportTarget, Callback = function(Value) Config.SelectedTeleportTarget = Value end })
HubTabs.Teleport:AddButton({ Title = "Activate Teleport", Callback = function()
    local targetName = Config.SelectedTeleportTarget
    if Config.SearchTeleportName ~= "" then
        for _, v in ipairs(workspace:GetDescendants()) do
             if v.Name:lower():find(Config.SearchTeleportName) and v:FindFirstChild("HumanoidRootPart") then
                targetName = v.Name
                break
             end
        end
    end
    local targetInstance = workspace:FindFirstChild(targetName, true)
    if targetInstance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetInstance.HumanoidRootPart.CFrame
    end
end })

-- ==========================================
-- TAB: SETTINGS
-- ==========================================
HubTabs.Settings:AddSection("Main Configuration")
HubTabs.Settings:AddButton({ Title = "Save Config Now", Callback = function() SaveConfig() end })
HubTabs.Settings:AddButton({ Title = "Reset All Settings", Description = "Restore all settings to default values", Callback = function() ResetEverything() end })

HubTabs.Settings:AddSection("Performance & Appearance")
local ThemeDropdown = HubTabs.Settings:AddDropdown("ThemeSelectorDropdown", { Title = "Select GUI Theme", Values = { "Deep Dark", "Midnight", "Charcoal", "Black", "White", "Purple" }, Default = Config.SelectedTheme, Callback = function(Value) Config.SelectedTheme = Value applyCustomTheme(Value) end })
HubTabs.Settings:AddToggle("AntiAFKToggle", { Title = "Anti-AFK Security", Default = Config.AntiAFKEnabled, Callback = function(Value) Config.AntiAFKEnabled = Value end })
HubTabs.Settings:AddToggle("LowLagToggle", { Title = "Low Lag Mode", Description = "Removes textures/shadows for FPS", Default = Config.LowLagMode, Callback = function(Value) Config.LowLagMode = Value UpdateLowLag() end })

-- ==========================================
-- UTILITY LOOPS 
-- ==========================================
task.spawn(function()
    local LastSavedConfig = HttpService:JSONEncode(Config)
    while task.wait(5) do
        local currentConfigStr = HttpService:JSONEncode(Config)
        if currentConfigStr ~= LastSavedConfig then
            SaveConfig()
            LastSavedConfig = currentConfigStr
        end
    end
end)

local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFKEnabled then
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

task.spawn(function()
    while task.wait(0.8) do
        if Config.AutoStatsEnabled then pcall(function() allocateStat(Config.SelectedStat, Config.StatsAmount) end) end
    end
end)

task.spawn(function()
    while task.wait(1.5) do
        if Config.AutoJoinTower then
             pcall(function()
                  game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/TowerEvent"):FireServer("Play")
            end)
        end
    end
end)

-- PORTAL SYSTEMS MONITOR LOOP
task.spawn(function()
    while task.wait(2.0) do
        pcall(function()
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local portalGui = playerGui:FindFirstChild("PortalGui") or playerGui:FindFirstChild("ScreenGui")
                local finishFrame = portalGui and (portalGui:FindFirstChild("Finish") or portalGui:FindFirstChild("Result") or portalGui:FindFirstChild("GameOver"))
                
                if finishFrame and finishFrame.Visible then
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/PortalEvent"):FireServer("Lobby")
                    task.wait(1.0)
                end
            end
        end)

        -- คุมระบบวาร์ปเข้าประตูจากข้างในโค้ด
        local allowPortalRun = Config.AutoStartPortal
        local currentPity = getCurrentPity()
        
        if Config.AutoPitySystem and not isInDungeon() then
            if currentPity >= Config.PityTargetValue then
                if not PityReachedTime then
                    PityReachedTime = tick()
                end
                
                -- หน่วงเวลา PityDelayTime (15 วินาที) ก่อนระบบประตูจะทำงาน
                if (tick() - PityReachedTime) >= PityDelayTime then
                    allowPortalRun = Config.AutoStartPortal 
                else
                    allowPortalRun = false 
                end
            else
                PityReachedTime = nil 
                allowPortalRun = false 
            end
        else
            PityReachedTime = nil
            if isInDungeon() then
                allowPortalRun = false
            end
        end

        if allowPortalRun and not isInDungeon() then
            pcall(function()
                local keyToUse = "Cid's Key"
                if Config.SelectedPortalName == "RAIDEN" then
                    keyToUse = "Shrine Key"
                elseif Config.SelectedPortalName == "SHADOW" then
                    keyToUse = "Cid's Key"
                end
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/MaterialEvent"):FireServer("Use", { Item = keyToUse, Amount = 1 })
                task.wait(0.5)
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/PortalEvent"):FireServer("Select", { Difficulty = Config.SelectedPortalDifficulty, Portal = Config.SelectedPortalName, FriendOnly = false })
                task.wait(0.5)
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/PortalEvent"):FireServer("EarlyStart")
             end)
        end
        
        local allowStartGameInPortal = Config.AutoStartGameInPortal
        if Config.AutoPitySystem and currentPity < Config.PityTargetValue and not isInDungeon() then
            allowStartGameInPortal = false
        end

        if allowStartGameInPortal then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/PortalEvent"):FireServer("Start")
            end)
        end
    end
end)

-- SUMMON MONITOR LOOP (ระบบคุมเสกบอส และ Pity System)
local LastGodExchangeTime = 0
local LastGodSummonTime = 0
local LastPitySummonTime = 0
local LastSummonBossTime = 0
local LastBattleBossTime = 0

task.spawn(function()
    while task.wait(0.1) do -- ลดเวลาให้ลูปทำงานเร็วและถี่ขึ้นมาก (ทุก 0.1 วิ) เพื่อการเสกที่ต่อเนื่องและเสถียร
        local blockOtherSummons = false
        
        -- ยกเลิกการเรียกเสกทั้งหมดหากอยู่ระหว่างเล่นดันเจี้ยน
        if isInDungeon() then
            continue 
        end
        
        -- LOGIC Pity System
        if Config.AutoPitySystem and not isInDungeon() then
            local currentPity = getCurrentPity()
            
            -- กรณีที่ 1: Pity ถึงจำนวนที่ตั้งเป้าหมาย หรือเกินที่ตั้งไว้
            if currentPity >= Config.PityTargetValue then
                if not PityReachedTime then
                    PityReachedTime = tick()
                end
                
                -- หน่วงเวลายับยั้งทุกระบบอื่นๆเพื่อให้ตัวละครจัดการตัวเดิมให้เสร็จก่อน
                if (tick() - PityReachedTime) < PityDelayTime then
                    blockOtherSummons = true
                else
                    blockOtherSummons = false
                end
            else
                -- กรณีที่ 2: Pity ยังไม่ถึงเป้าหมาย
                PityReachedTime = nil 
                blockOtherSummons = true -- ระงับระบบเสกอื่นๆ เพื่อโฟกัสปั้ม Pity ให้ได้ไวที่สุดปละต่อเนื่อง
                
                -- เสกตัวใหม่ทันทีเมื่อตัวเก่าไม่อยู่แล้ว
                if not checkSpecificBossExists("Verdant Hero") then
                    if (tick() - LastPitySummonTime) >= 0.5 then
                        summonBoss("Verdant Hero")
                        LastPitySummonTime = tick()
                    end
                end
            end
        end

        -- ถ้า blockOtherSummons เป็น true ระบบเหล่านี้ (เช่นแลกของ, เสก God ซ้อน) จะไม่ทำงาน
        if not blockOtherSummons and not isInDungeon() then
            if Config.SummonBossEnabled and not checkSpecificBossExists(Config.SelectedSummonBoss) then 
                if (tick() - LastSummonBossTime) >= 1.0 then -- กันสแปมถี่เกินไป
                    summonBoss(Config.SelectedSummonBoss) 
                    LastSummonBossTime = tick()
                end
            end
            if Config.BattleBossEnabled and not checkSpecificBossExists(Config.SelectedBattleBoss) then 
                if (tick() - LastBattleBossTime) >= 1.0 then 
                    summonBoss(Config.SelectedBattleBoss)
                    LastBattleBossTime = tick()
                end
            end
            
            if Config.SummonRimuruEnabled and not checkSpecificBossExists("Rimuru") then
                if (tick() - LastRimuruSummonTime) >= 120 then
                    summonRimuru()
                    LastRimuruSummonTime = tick()
                end
            end
            
            -- =======================================
            -- [NEW] GOD SUMMON SYSTEM & EXCHANGE
            -- =======================================
            if Config.AutoGodSummonEnabled then
                if (tick() - LastGodExchangeTime) >= 30 then
                    pcall(function()
                        for i = 1, 1 do -- ให้มันรัน 1 ครั้งตามลูป
                            local args = {
                                "Exchange",
                                {
                                    Key = "Holy Grail1",
                                    Amount = 1
                                }
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/ExchangeEvent"):FireServer(unpack(args))
                            task.wait(0.5)
                        end
                    end)
                    LastGodExchangeTime = tick()
                end

                if not checkSpecificBossExists("Gilgamesh") then
                    if (tick() - LastGodSummonTime) >= 20 then
                        pcall(function()
                            local args = { "Summon", { Difficult = Config.SelectedGodDifficulty, Boss = Config.SelectedGodBoss } }
                            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/SummonEvent"):FireServer(unpack(args))
                        end)
                        LastGodSummonTime = tick()
                    end
                end
            end
            -- =======================================

            AutoAizenSystem()
        end
    end
end)

-- AUTO SKILL LOOP
task.spawn(function()
    local CurrentlyOn = {} 
    
    while task.wait(0.5) do
        local shouldUseSkill = false
        
        if Config.AutoSkillEnabled and IsFarmingActive then
            shouldUseSkill = true
            
            if Config.AutoPitySystem and not isInDungeon() then
                local currentPity = getCurrentPity()
                if currentPity < Config.PityTargetValue then
                    shouldUseSkill = false
                end
            end
        end
        
        pcall(function()
            local uiEvent = game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/ToolUIEvent")
            
            if shouldUseSkill then
                local desiredSkills = Config.SelectedSkills or {}
                
                for key, isSelected in pairs(desiredSkills) do
                    if isSelected and not CurrentlyOn[key] then
                        uiEvent:FireServer("AutoKey", { Key = key })
                        CurrentlyOn[key] = true
                        task.wait(0.1)
                    end
                end
                
                for key, isOn in pairs(CurrentlyOn) do
                    if isOn and not desiredSkills[key] then
                        uiEvent:FireServer("AutoKey", { Key = key })
                        CurrentlyOn[key] = false
                        task.wait(0.1)
                    end
                end
                
            else
                for key, isOn in pairs(CurrentlyOn) do
                    if isOn then
                        uiEvent:FireServer("AutoKey", { Key = key })
                        CurrentlyOn[key] = false
                        task.wait(0.1)
                    end
                end
            end
        end)
    end
end)

local PendingBossTarget = nil
local BossDetectionTime = 0
local TweenService = game:GetService("TweenService")
local TeleportTween = nil

local function SmoothTeleport(targetCFrame)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    if dist < 10 then 
        hrp.CFrame = targetCFrame
        return 
    end
    
    local speed = 800
    local tTime = dist / speed
    if tTime > 5 then tTime = 5 end 
    
    if TeleportTween then TeleportTween:Cancel() end
    local tweenInfo = TweenInfo.new(tTime, Enum.EasingStyle.Linear)
    TeleportTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    TeleportTween:Play()
end

-- CORE MONITOR LOOP
task.spawn(function()
    while task.wait(0.3) do 
        IsFarmingActive = (Config.FarmEnabled or Config.SummonBossEnabled or Config.BattleBossEnabled or Config.PriorityBossEnabled or Config.AutoKillTower or Config.AutoStartGameInPortal or Config.AutoAizenEnabled or Config.AutoStoneEnabled or Config.AutoPitySystem or Config.AutoGodSummonEnabled)
        
        if IsFarmingActive and not IsSwitchingTarget then
            local bestTarget, isQuest, priorityLevel = findTarget(CurrentFarmTarget)
            
            if bestTarget ~= CurrentFarmTarget then
                local waitDelay = 0.5 
                
                if bestTarget and bestTarget:FindFirstChild("Humanoid") and bestTarget.Humanoid.MaxHealth >= 1000000 then
                    waitDelay = 1.5 
                end
                 
                if PendingBossTarget ~= bestTarget then
                    PendingBossTarget = bestTarget
                    BossDetectionTime = tick()
                end

                if (tick() - BossDetectionTime) < waitDelay then
                    continue 
                end
                
                IsSwitchingTarget = true
            
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.RotVelocity = Vector3.new(0, 0, 0)
                    if LastSafePosition then hrp.CFrame = LastSafePosition end
                end
                
                task.wait(0.1)

                if Config.AutoKillTower then
                     pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/TowerEvent"):FireServer("Start")
                    end)
                end
                
                CurrentFarmTarget = bestTarget
                PendingBossTarget = nil
                IsSwitchingTarget = false
                
                if CurrentFarmTarget and isQuest then
                    local cleanName = getCleanName(CurrentFarmTarget.Name)
                     if cleanName ~= LastTargetQuest then
                        LastTargetQuest = cleanName
                        task.spawn(function() switchQuest(cleanName) end)
                    end
                 end
            elseif CurrentFarmTarget and isAlive(CurrentFarmTarget) then
                PendingBossTarget = nil
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LastSafePosition = LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        elseif not IsFarmingActive then
            CurrentFarmTarget = nil
            PendingBossTarget = nil
        end
    end
end)

-- KINEMATICS (SMOOTH CFrame CONTROLLER / ANTI-KICK)
RunService.Heartbeat:Connect(function()
    if IsFarmingActive and not IsSwitchingTarget then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
       
        if hrp then
            if CurrentFarmTarget and isAlive(CurrentFarmTarget) then
                local tHrp = CurrentFarmTarget:FindFirstChild("HumanoidRootPart")
                if not tHrp and CurrentFarmTarget:IsA("BasePart") then tHrp = CurrentFarmTarget end
                
                if tHrp then
                    local targetPos = tHrp.Position
                    local smoothGoalCFrame
                    
                    if Config.FarmAngle == "Above" then 
                        local myPos = targetPos + Vector3.new(0, Config.DistanceBehind, 0)
                        smoothGoalCFrame = CFrame.lookAt(myPos, targetPos)
                    elseif Config.FarmAngle == "Below" then 
                         local myPos = targetPos - Vector3.new(0, Config.DistanceBehind, 0)
                        smoothGoalCFrame = CFrame.lookAt(myPos, targetPos)
                    else
                        local offset = CFrame.new(0, 0, Config.DistanceBehind)
                        local targetRotation = tHrp.CFrame - tHrp.CFrame.Position
                        smoothGoalCFrame = CFrame.new(targetPos) * targetRotation * offset
                    end
                 
                    hrp.CFrame = smoothGoalCFrame
                    LastSafePosition = hrp.CFrame
                end
            else
                if LastSafePosition then
                    hrp.CFrame = LastSafePosition
                end
            end
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- SAFE NOCLIP
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
         if IsFarmingActive then
            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            if hrp then
                hrp.Velocity = Vector3.new(0, 0, 0)
                 hrp.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- AUTO ATTACK
task.spawn(function()
    while task.wait(0.15) do
        if IsFarmingActive and CurrentFarmTarget and isAlive(CurrentFarmTarget) and Config.SelectedWeapon ~= "None" and not IsSwitchingTarget then
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChild(Config.SelectedWeapon) or LocalPlayer.Backpack:FindFirstChild(Config.SelectedWeapon)
                if tool then
                    if Config.AutoEquip and tool.Parent ~= char then tool.Parent = char end
                    if tool.Parent == char then tool:Activate() end
                 end
             end
        end
    end
end)

-- INITIALIZATION THEME & LAG MODE
applyCustomTheme(Config.SelectedTheme)
if Config.LowLagMode then UpdateLowLag() end

-- ==========================================
-- DRAGGABLE TOGGLE BUTTON
-- ==========================================
local ToggleGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ToggleGui.Name = "ZenithSoulToggle"

local SafeParent = LocalPlayer:FindFirstChild("PlayerGui")
pcall(function()
    if game:GetService("CoreGui") then
        SafeParent = game:GetService("CoreGui")
    end
end)
ToggleGui.Parent = SafeParent
ToggleGui.ResetOnSpawn = false

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ToggleGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.BackgroundTransparency = 0.1
ToggleButton.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Image = "rbxassetid://94329205103503"
ToggleButton.BorderSizePixel = 0

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleButton

local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
          
        input.Changed:Connect(function()
             if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
     if input == dragInput and dragging then
         update(input)
     end
end)

ToggleButton.MouseButton1Click:Connect(function()
    if Window then
        Window:Minimize()
    else
        local coreGui = game:GetService("CoreGui")
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local fluentGui = (coreGui and coreGui:FindFirstChild("Fluent")) or (playerGui and playerGui:FindFirstChild("Fluent"))
        if fluentGui then
            fluentGui.Enabled = not fluentGui.Enabled
        end
    end
end)
