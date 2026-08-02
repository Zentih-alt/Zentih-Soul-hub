-- Main.lua (Zenith Soul Hub - Modern Language & Clean System)
local SCRIPT_URL = "https://raw.githubusercontent.com/Zentih-alt/Zentih-Soul-hub/refs/heads/main/Rock.lua"
local DISCORD_LINK = "https://discord.gg/AtvaNuz38e"

-- ============================================================
-- ระบบล้างระบบเก่า & ป้องกันการรันสคริปต์ซ้ำซ้อน (Session Guard)
-- ============================================================
local mySession = math.random(100000, 999999)

local connections = {}
local function registerConn(conn)
    table.insert(connections, conn)
    return conn
end

if _G.ZenithSoul_Cleanup then
    pcall(_G.ZenithSoul_Cleanup)
end

_G.ZenithSoul_Session = mySession

_G.ZenithSoul_Cleanup = function()
    _G.ZenithSoul_Session = nil
    _G.WeaponScanActive = false
    for _, conn in ipairs(connections) do
        if conn and conn.Disconnect then
            pcall(function() conn:Disconnect() end)
        end
    end
    pcall(function()
        local platform = workspace:FindFirstChild("ZenithSoul_Platform")
        if platform then platform:Destroy() end
    end)
    pcall(function()
        local oldBlackScreen = game:GetService("CoreGui"):FindFirstChild("ZenithSoul_BlackScreen")
        if oldBlackScreen then oldBlackScreen:Destroy() end
        
        local oldBlackScreen2 = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ZenithSoul_BlackScreen")
        if oldBlackScreen2 then oldBlackScreen2:Destroy() end
    end)
end

if not game:IsLoaded() then game.Loaded:Wait() end
local player = game.Players.LocalPlayer
player:WaitForChild("Backpack", 10)

-- ============================================================
-- ระบบภาษาปรับปรุงใหม่
-- ============================================================
local currentLang = "Thai"
pcall(function()
    if isfile and isfile("ZenithSoul/configs/default.json") then
        local HttpService = game:GetService("HttpService")
        local config = HttpService:JSONDecode(readfile("ZenithSoul/configs/default.json"))
        if config then
            if config.SelectedLanguage then
                currentLang = config.SelectedLanguage
            elseif config.Flags and config.Flags.SelectedLanguage then
                currentLang = config.Flags.SelectedLanguage
            end
        end
    end
end)

local Str = {
    English = {
        Subtitle = "Rock Fruit",
        TabDashboard = "Dashboard",
        TabFarmSettings = "Settings",
        TabFarmPlay = "Auto Farm",
        TabBossSpawner = "Boss Mode",
        TabGeneral = "General",
        TabConfig = "Configs",
        
        StatusTitle = "Status",
        StatusUser = "License",
        StatusValue = "Free",
        AboutTitle = "Developer",
        AboutDesc = "Solo-developed project. Thanks for using!",
        CopyDiscord = "Discord Link",
        
        SectionOptions = "Weapon Options",
        SelectWeapon = "Weapon",
        AutoEquip = "Auto Equip",
        RefreshWeapons = "Scan Weapons",
        SectionFarmTuning = "Tuning",
        FarmAngle = "Angle",
        FarmAngles = {"Behind", "Above", "Below"},
        FarmDistance = "Distance",
        
        SectionSelectMonster = "Single Target",
        SelectMonsterLabel = "Select Mob",
        StartFarm = "Start Auto Farm",
        
        SectionMultiFarm = "Multi Target",
        MultiMonsterLabel = "Select Mobs",
        StartMultiFarm = "Start Multi Farm",
        
        Boss = "Select Boss",
        Summon = "Summon",
        
        SectionGeneral = "General Settings",
        Theme = "Theme",
        SectionLanguage = "Language Settings",
        Language = "Language",
        SectionDisplay = "Screen Settings",
        BlackScreen = "Black Screen",
        ExitBlackScreen = "Exit Black",
        ToggleKey = "Toggle Key",
        
        SaveConfig = "Save Config",
        ResetConfig = "Reset Config",
        TabEvent = "Event Farm",
        StartEventFarm = "Start Event Farm",
        EventMonsterLabel = "Select Mobs",
        TabSummonBoss = "Boss Farm",
        SectionSummon = "Summon Boss",
        AutoSummon = "Auto Summon",
        AutoSummonDesc = "Auto summon boss",
        TabTeleportNPC = "TP NPC",
        SectionQuestNPC = "NPC",
        SelectNPC = "NPC",
        TeleportAndAccept = "Warp & Accept",
        TabStatus = "Stats",
        SectionStatUpgrade = "Upgrade Stats",
        SelectStats = "Stats",
        Amount = "Amount",
        UpgradeSelected = "Upgrade Now",
        AutoUpgradeOnScan = "Auto Upgrade",
        SectionAntiKick = "AFK & Safety",
        AutoRejoin = "Auto Rejoin",
        UpdateLogTitle = "Updates",
        UpdateLogDesc = "Map Updates & Improvements.",
        TabDungeon = "Dungeon",
        SectionDungeon = "Auto Dungeon Map",
        EnableDungeon = "Enable Auto Dungeon"
    },
    Thai = {
        Subtitle = "Rock Fruit",
        TabDashboard = "แดชบอร์ด",
        TabFarmSettings = "ตั้งค่า",
        TabFarmPlay = "ออโต้ฟาร์ม",
        TabBossSpawner = "โหมดบอส",
        TabGeneral = "ตั้งค่าทั่วไป",
        TabConfig = "จัดการคอนฟิก",
        
        StatusTitle = "สถานะ",
        StatusUser = "สิทธิ์การใช้งาน",
        StatusValue = "ฟรี",
        AboutTitle = "ผู้พัฒนา",
        AboutDesc = "ทีมงานน้อยอาจอัพเดทช้า สามารถสนับสนุนได้ ขอบคุณทุกซัพพอร์ตครับ!",
        CopyDiscord = "คัดลอกดิสคอร์ด",
        
        SectionOptions = "เลือกอาวุธ",
        SelectWeapon = "อาวุธที่จะใช้",
        AutoEquip = "ถืออัตโนมัติเมื่อเกิด",
        RefreshWeapons = "สแกนอาวุธใหม่",
        SectionFarmTuning = "ปรับแต่งตำแหน่ง",
        FarmAngle = "มุมยืนตี",
        FarmAngles = {"ข้างหลัง", "ด้านบน", "ด้านล่าง"},
        FarmDistance = "ระยะห่าง",
        
        SectionSelectMonster = "ออโต้ฟาร์มมอนเดี่ยว",
        SelectMonsterLabel = "เลือกมอนสเตอร์",
        StartFarm = "เปิดออโต้ฟาร์ม",
        
        SectionMultiFarm = "ออโต้ฟาร์มสลับเกาะ",
        MultiMonsterLabel = "เลือกมอนสเตอร์",
        StartMultiFarm = "เปิดออโต้ฟาร์มมอนสลับเกาะ",
        
        Boss = "เลือกบอส",
        Summon = "เสกบอส",
        
        SectionGeneral = "ตั้งค่าทั่วไป",
        Theme = "เปลี่ยนสีเมนู",
        SectionLanguage = "เปลี่ยนภาษา",
        Language = "ภาษา",
        SectionDisplay = "การแสดงผลหน้าจอ",
        BlackScreen = "เปิดจอดำ",
        ExitBlackScreen = "ปิดจอดำ",
        ToggleKey = "ปุ่มซ่อน/แสดงเมนู",
        
        SaveConfig = "บันทึกคอนฟิก",
        ResetConfig = "รีเซ็ตคอนฟิก",
        TabEvent = "ฟาร์มอีเวนต์",
        StartEventFarm = "เปิดฟาร์มอีเวนต์",
        EventMonsterLabel = "เลือกมอนสเตอร์อีเวนต์",
        TabSummonBoss = "ล่าบอส",
        SectionSummon = "ตัวเลือกบอส",
        AutoSummon = "เรียกบอสอัตโนมัติ",
        AutoSummonDesc = "เรียกบอส",
        TabTeleportNPC = "วาป",
        SectionQuestNPC = "NPC เควส",
        SelectNPC = "NPC",
        TeleportAndAccept = "วาร์ปรับเควสทันที",
        TabStatus = "อัปสเตตัส",
        SectionStatUpgrade = "อัปสเตตัส",
        SelectStats = "สเตตัส",
        Amount = "จำนวนที่อัป",
        UpgradeSelected = "กดอัปเกรด",
        AutoUpgradeOnScan = "อัปเกรดอัตโนมัติ",
        SectionAntiKick = "ระบบป้องกัน AFK",
        AutoRejoin = "เชื่อมต่อใหม่เมื่อหลุด",
        UpdateLogTitle = "บันทึกอัปเดต",
        UpdateLogDesc = "อัปเดตแผนที่ใหม่ มอนสเตอร์ใหม่ และดันเจี้ยนอัตโนมัติ",
        TabDungeon = "ดันเจี้ยน",
        SectionDungeon = "ระบบลงดันเจี้ยนอัตโนมัติ",
        EnableDungeon = "เปิดออโต้ลงดันเจี้ยน"
    }
}

local L = Str[currentLang] or Str.English

-- ============================================================
-- ฟังก์ชันสแกนหาอาวุธ
-- ============================================================
local function getWeaponList()
    local list = {}
    local added = {}

    if player then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and not added[tool.Name] then 
                    table.insert(list, tool.Name) 
                    added[tool.Name] = true
                end
            end
        end
        if player.Character then
            for _, tool in ipairs(player.Character:GetChildren()) do
                if tool:IsA("Tool") and not added[tool.Name] then 
                    table.insert(list, tool.Name) 
                    added[tool.Name] = true
                end
            end
        end
        local starterGear = player:FindFirstChild("StarterGear")
        if starterGear then
            for _, tool in ipairs(starterGear:GetChildren()) do
                if tool:IsA("Tool") and not added[tool.Name] then
                    table.insert(list, tool.Name)
                    added[tool.Name] = true
                end
            end
        end
    end
    return list
end

local function refreshDropdown(dropdown, newList)
    if dropdown then
        if type(dropdown.Refresh) == "function" then
            pcall(function() dropdown:Refresh(newList, true) end)
        elseif type(dropdown.Update) == "function" then
            pcall(function() dropdown:Update(newList) end)
        elseif type(dropdown.SetOptions) == "function" then
            pcall(function() dropdown:SetOptions(newList) end)
        end
    end
end

-- ดึงข้อมูล UI Library พร้อมระบบป้องกัน Error (Safeguard)
local Solar = nil
local successSolar, errSolar = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/discounthee-sys/Zenith-Soul-hub/refs/heads/main/Solar.lua"))()
end)

if successSolar and Solar then
    Solar = errSolar
else
    Solar = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zentih-alt/Zentih-Soul-hub/refs/heads/main/Solar.lua"))()
end

local Window = Solar.CreateWindow({
    Title = "Zenith Soul",
    Subtitle = L.Subtitle,
    Theme = "Black",
    Icon = "rbxassetid://70537126163494",
    ToggleIcon = "rbxassetid://94329205103503"
})

pcall(function()
    if Window.SetTransparency then
        Window.SetTransparency(0.2)
    end
end)

-- ============================================================
-- CATEGORY: Home
-- ============================================================

local TabDashboard = Window.AddTab(L.TabDashboard, "Home")
TabDashboard:AddLabel(L.StatusTitle)
TabDashboard:AddStatus(L.StatusUser, L.StatusValue)
TabDashboard:AddParagraph(L.AboutTitle, L.AboutDesc)
TabDashboard:AddParagraph(L.UpdateLogTitle, L.UpdateLogDesc)

TabDashboard:AddButton(L.CopyDiscord, function()
    local ok = pcall(function() setclipboard(DISCORD_LINK) end)
    Window.Notify({Title = "Discord", Description = ok and "Copied!" or DISCORD_LINK, Duration = 3})
end)

local TabFarmSettings = Window.AddTab(L.TabFarmSettings, "Home")

local HakiEnabledState = false
local function fireHaki()
    pcall(function()
        local args = {"Misc", "buso"}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Action"):FireServer(unpack(args))
    end)
end
TabFarmSettings:AddCheckbox("Haki (Busoshoku)", "", false, function(state)
    HakiEnabledState = state
    if state then fireHaki() end
end, "HakiEnabled")

TabFarmSettings:AddSection(L.SectionOptions)

local SelectedTool = "None"
local initialWeapons = getWeaponList()
SelectedTool = initialWeapons[1] or "None"

local weaponDropdown = TabFarmSettings:AddDropdown(L.SelectWeapon, "", initialWeapons, SelectedTool, function(v)
    SelectedTool = v
end, "SelectedTool")

local AutoEquipState = false
TabFarmSettings:AddCheckbox(L.AutoEquip, "", false, function(state)
    AutoEquipState = state
end, "AutoEquipTool")

local function runActiveScanner(seconds)
    if _G.WeaponScanActive then return end
    _G.WeaponScanActive = true
    
    task.spawn(function()
        local startTime = tick()
        local lastList = {}
        
        while _G.ZenithSoul_Session == mySession and _G.WeaponScanActive and (tick() - startTime) < seconds do
            local newList = getWeaponList()
            local changed = #newList ~= #lastList
            
            if not changed then
                for i, v in ipairs(newList) do
                    if lastList[i] ~= v then
                        changed = true
                        break
                    end
                end
            end
            
            if changed then
                lastList = newList
                refreshDropdown(weaponDropdown, newList)
                if SelectedTool == "None" and newList[1] ~= "None" then
                    SelectedTool = newList[1]
                    if weaponDropdown and type(weaponDropdown.Set) == "function" then
                        pcall(function() weaponDropdown:Set(SelectedTool) end)
                    end
                end
            end
            task.wait(0.5)
        end
        _G.WeaponScanActive = false
    end)
end

runActiveScanner(10)

TabFarmSettings:AddButton(L.RefreshWeapons, function()
    _G.WeaponScanActive = false
    task.wait(0.1)
    runActiveScanner(5)
    Window.Notify({Title = "Scanner", Description = "Scanning... (5s)", Duration = 2})
end)

local FarmAngleState = "Behind"
local FarmDistanceState = 10

TabFarmSettings:AddSection(L.SectionFarmTuning)
TabFarmSettings:AddDropdown(L.FarmAngle, "", L.FarmAngles, L.FarmAngles[1], function(v)
    FarmAngleState = v
end, "FarmAngle")

TabFarmSettings:AddSpeedSlider(L.FarmDistance, 0, 50, 10, function(v)
    FarmDistanceState = tonumber(v) or 10
end, "FarmDistance")

TabFarmSettings:AddSection("Auto Skill")

local SelectedSkills = {}
local AutoSkillEnabled = false

local skillDropdown = TabFarmSettings:AddMultiDropdown("Auto Skill (เลือกสกิล)", "", {"Z", "X", "C", "V", "F"}, {}, function(v)
    SelectedSkills = v
end, "SelectedSkills")

TabFarmSettings:AddCheckbox("Enable Auto Skill", "", false, function(state)
    AutoSkillEnabled = state
end, "AutoSkillEnabled")

local WeaponSkillOrder = {
    ["Yoru"] = {"z", "x", "c", "v", "f"},
}
local DEFAULT_SKILL_ORDER = {"z", "x", "c", "v", "f"}

-- ============================================================
-- CATEGORY: Farming
-- ============================================================
local TabFarmPlay = Window.AddTab(L.TabFarmPlay, "Farming")

TabFarmPlay:AddSection(L.SectionSelectMonster)

local SelectedMonster = "Bacon"
local MonsterList = {
    "Bacon", "Bacon Strong", "Duck Monster", "Bacon Traveler", "Bacon Fawkes", "Bacon Pirate",
    "Bacon Clown", "Bacon Tarzan", "Gorilla", "Bacon Fisherman", "Bacon The Deep",
    "Bacon Marine", "Bacon Marine Captain", "Bacon Iron", "Bacon Rock", "Bacon Minerals",
    "Bacon Kryptonite", "Bacon Snow", "Bacon Ice", "Bacon Lava", "Bacon Hellfire", "Bacon Shadow Garden",
    "Bacon Horse"
}

TabFarmPlay:AddDropdown(L.SelectMonsterLabel, "", MonsterList, "Bacon", function(v)
    SelectedMonster = v
end, "SelectedMonster")

local FarmEnabledState = false
local MultiFarmEnabledState = false
local EventFarmEnabledState = false
local DungeonActiveState = false
local dungeonTargetMob = nil

local SelectedBoss = "GooGooGaaGaa"
local AutoBossFarmState = false

local farmToggleObj, multiFarmToggleObj, eventFarmToggleObj

farmToggleObj = TabFarmPlay:AddToggle(L.StartFarm, "", function(state)
    FarmEnabledState = state
    if state then
        if MultiFarmEnabledState then
            MultiFarmEnabledState = false
            if multiFarmToggleObj then multiFarmToggleObj:Set(false) end
        end
        if EventFarmEnabledState then
            EventFarmEnabledState = false
            if eventFarmToggleObj then eventFarmToggleObj:Set(false) end
        end
    end
end, "FarmEnabledState")

TabFarmPlay:AddSection(L.SectionMultiFarm)

local SelectedMultiMonsters = {}
local MultiDropdown = TabFarmPlay:AddMultiDropdown(L.MultiMonsterLabel, "", MonsterList, {}, function(v)
    SelectedMultiMonsters = v
end, "SelectedMultiMonsters")

multiFarmToggleObj = TabFarmPlay:AddToggle(L.StartMultiFarm, "", function(state)
    MultiFarmEnabledState = state
    if state then
        if FarmEnabledState then
            FarmEnabledState = false
            if farmToggleObj then farmToggleObj:Set(false) end
        end
        if EventFarmEnabledState then
            EventFarmEnabledState = false
            if eventFarmToggleObj then eventFarmToggleObj:Set(false) end
        end
    end
end, "MultiFarmEnabledState")

-- ============================================================
-- 2.3 แท็บอีเว้นท์ (อัปเดตลบตัวเก่า ใส่ Bacon Trainer)
-- ============================================================
local TabEvent = Window.AddTab(L.TabEvent, "Farming")
TabEvent:AddSection(L.TabEvent)

local EventMonsterList = {"Bacon Trainer"}

local SelectedEventMonsters = {}
local EventDropdown = TabEvent:AddMultiDropdown(L.EventMonsterLabel, "", EventMonsterList, {}, function(v)
    SelectedEventMonsters = v
end, "SelectedEventMonsters")

eventFarmToggleObj = TabEvent:AddToggle(L.StartEventFarm, "", function(state)
    EventFarmEnabledState = state
    if state then
        if FarmEnabledState then
            FarmEnabledState = false
            if farmToggleObj then farmToggleObj:Set(false) end
        end
        if MultiFarmEnabledState then
            MultiFarmEnabledState = false
            if multiFarmToggleObj then multiFarmToggleObj:Set(false) end
        end
    end
end, "EventFarmEnabledState")

-- ============================================================
-- 👾 ระบบหาพิกัดและวาร์ปบอสตรงตัว
-- ============================================================
local function getBossModel(bossName)
    local bossFolder = workspace:FindFirstChild("Boss")
    if bossFolder then
        local boss = bossFolder:FindFirstChild(bossName)
        if boss and boss:FindFirstChildOfClass("Humanoid") and boss:FindFirstChildOfClass("Humanoid").Health > 0 then
            return boss
        end
    end
    return nil
end

local function getTargetMobByName(name)
    if name == "GooGooGaaGaa" or name == "Dark Bacon" then
        return getBossModel(name)
    end
    local mobFolder = workspace:FindFirstChild("Mob")
    if mobFolder then
        for _, mob in ipairs(mobFolder:GetChildren()) do
            if mob.Name == name then
                local hum = mob:FindFirstChildOfClass("Humanoid")
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and hrp then
                    return mob
                end
            end
        end
    end
    return nil
end

-- ============================================================
-- ระบบวาร์ปข้ามเกาะอัตโนมัติ
-- ============================================================
local islandTargetCache = {}

local IslandMonsterMap = {
    ["Starter island"] = { index = 209, monsters = {"Bacon", "Bacon Strong", "Duck Monster"} },
    ["Port Island"] = { index = 156, monsters = {"Bacon Traveler", "Bacon Fawkes"} },
    ["Clown island"] = { index = 54, monsters = {"Bacon Pirate", "Bacon Clown"} },
    ["Forest island"] = { index = 72, monsters = {"Bacon Tarzan", "Gorilla"} },
    ["Fishing island"] = { index = 85, monsters = {"Bacon Fisherman", "Bacon The Deep"} },
    ["Marine island"] = { index = 132, monsters = {"Bacon Marine", "Bacon Marine Captain"} },
    ["Rock island"] = { index = 92, monsters = {"Bacon Iron", "Bacon Rock"} },
    ["Crystal island"] = { index = 47, monsters = {"Bacon Minerals", "Bacon Kryptonite"} },
    ["Snow island"] = { index = 1, monsters = {"Bacon Snow", "Bacon Ice"} },
    ["Lava island"] = { index = 1, monsters = {"Bacon Lava", "Bacon Hellfire"} },
    ["Event Island"] = { index = 34, monsters = {"Bacon Trainer"} },
    ["Boss island"] = { index = 1, monsters = {"GooGooGaaGaa", "Dark Bacon"} }
}

local monsterToIsland = {}
for islandName, data in pairs(IslandMonsterMap) do
    for _, mob in ipairs(data.monsters) do
        monsterToIsland[mob] = { island = islandName, index = data.index }
    end
end

-- ============================================================
-- ระบบเควส (อัปเดตเพิ่ม NPC_Quest22 -> Bacon Horse)
-- ============================================================
local QuestMap = {
    ["NPC_Quest1"] = "Bacon", ["NPC_Quest2"] = "Bacon Strong", ["NPC_Quest3"] = "Bacon Traveler",
    ["NPC_Quest4"] = "Bacon Fawkes", ["NPC_Quest5"] = "Bacon Pirate", ["NPC_Quest6"] = "Bacon Clown",
    ["NPC_Quest7"] = "Bacon Tarzan", ["NPC_Quest8"] = "Gorilla", ["NPC_Quest9"] = "Bacon Fisherman",
    ["NPC_Quest10"] = "Bacon The Deep", ["NPC_Quest11"] = "Bacon Marine", ["NPC_Quest12"] = "Bacon Marine Captain",
    ["NPC_Quest13"] = "Bacon Rock", ["NPC_Quest14"] = "Bacon Iron", ["NPC_Quest15"] = "Bacon Minerals",
    ["NPC_Quest16"] = "Bacon Kryptonite", ["NPC_Quest17"] = "Bacon Snow", ["NPC_Quest18"] = "Bacon Ice",
    ["NPC_Quest19"] = "Bacon Lava", ["NPC_Quest20"] = "Bacon Hellfire",
    ["NPC_Quest21"] = "Bacon Shadow Garden",
    ["NPC_Quest22"] = "Bacon Horse"
}

local MobToNPC = {}
for npc, mob in pairs(QuestMap) do
    MobToNPC[mob] = npc
end

local function resolveTargetPart(monsterName)
    if monsterName == "Duck Monster" then
        local starterIsland = workspace:FindFirstChild("island") and workspace.island:FindFirstChild("Starter island")
        if starterIsland then
            local part = starterIsland:FindFirstChild("Part") or starterIsland:FindFirstChildWhichIsA("BasePart", true)
            if part then return part end
        end
    elseif monsterName == "GooGooGaaGaa" or monsterName == "Dark Bacon" then
        local bossIsland = workspace:FindFirstChild("island") and workspace.island:FindFirstChild("Boss island")
        if bossIsland then
            local part = bossIsland:FindFirstChild("Part") or bossIsland:FindFirstChildWhichIsA("BasePart", true)
            if part then return part end
        end
    end

    local cached = islandTargetCache[monsterName]
    if cached and cached.Parent then return cached end

    local info = monsterToIsland[monsterName]
    if info then
        local islandModel = workspace:FindFirstChild("island") and workspace.island:FindFirstChild(info.island)
        if islandModel then
            local children = islandModel:GetChildren()
            local part = children[info.index] or islandModel:FindFirstChildWhichIsA("BasePart", true)
            if part then
                islandTargetCache[monsterName] = part
                return part
            end
        end
    end

    local npcName = MobToNPC[monsterName]
    if npcName then
        local npc = workspace:FindFirstChild("NpcQuest") and workspace.NpcQuest:FindFirstChild(npcName) or workspace:FindFirstChild(npcName, true)
        if npc then
            local npcPart = npc:IsA("BasePart") and npc or npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart", true)
            if npcPart then
                islandTargetCache[monsterName] = npcPart
                return npcPart
            end
        end
    end
    return nil
end

local function teleportToIsland(monsterName)
    pcall(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local targetMob = getTargetMobByName(monsterName)
        if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
            local targetHrp = targetMob:FindFirstChild("HumanoidRootPart")
            local dist = (hrp.Position - targetHrp.Position).Magnitude
            if dist > 150 then
                hrp.CFrame = targetHrp.CFrame + Vector3.new(0, FarmDistanceState or 10, 0)
            end
            return
        end

        local targetPart = resolveTargetPart(monsterName)
        if targetPart then
            local targetPos = targetPart:IsA("BasePart") and targetPart.Position or (targetPart:FindFirstChildOfClass("BasePart") and targetPart:FindFirstChildOfClass("BasePart").Position)
            if targetPos then
                local dist = (hrp.Position - targetPos).Magnitude
                if dist > 350 then
                    local platform = workspace:FindFirstChild("ZenithSoul_Platform")
                    if platform then platform:Destroy() end
                    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 15, 0))
                end
            end
        end
    end)
end

-- ============================================================
-- ระบบแพลตฟอร์มกันตกแมพ
-- ============================================================
local function getOrCreatePlatform()
    local platform = workspace:FindFirstChild("ZenithSoul_Platform")
    if not platform then
        platform = Instance.new("Part")
        platform.Name = "ZenithSoul_Platform"
        platform.Size = Vector3.new(20, 1, 20)
        platform.Transparency = 1
        platform.Anchored = true
        platform.CanCollide = true
        platform.CanTouch = false 
        platform.CanQuery = false
        platform.CastShadow = false
        platform.Parent = workspace
    end
    return platform
end

local function removePlatform()
    local platform = workspace:FindFirstChild("ZenithSoul_Platform")
    if platform then platform:Destroy() end
end

-- ============================================================
-- ระบบรับเควส
-- ============================================================
local function acceptQuest(npcName)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum) then return false end
    
    hum.PlatformStand = true
    local npc = nil
    for i = 1, 30 do
        if workspace:FindFirstChild("NpcQuest") then
            npc = workspace.NpcQuest:FindFirstChild(npcName)
        end
        if not npc then
            npc = workspace:FindFirstChild(npcName, true)
        end
        if npc then break end
        task.wait(0.1)
    end
    
    if not npc then 
        hum.PlatformStand = false
        return false 
    end
    
    for attempt = 1, 6 do
        local success, result = pcall(function()
            if not npc.Parent then return false end
            local npcPart = npc:IsA("BasePart") and npc or npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChildWhichIsA("BasePart", true)
            if npcPart then
                hrp.CFrame = CFrame.lookAt(npcPart.Position + (npcPart.CFrame.LookVector * 2.8) + Vector3.new(0, 0.5, 0), npcPart.Position)
            end
            
            task.wait(0.3)
            local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then
                local oldDist = prompt.MaxActivationDistance
                local oldRequireLineOfSight = prompt.RequiresLineOfSight
                
                prompt.MaxActivationDistance = 999999
                prompt.RequiresLineOfSight = false
                task.wait(0.1)
                
                for clickCount = 1, 3 do
                    if prompt and prompt.Parent then
                        fireproximityprompt(prompt)
                        task.wait(0.15)
                    end
                end
                task.wait(0.2)
                prompt.MaxActivationDistance = oldDist
                prompt.RequiresLineOfSight = oldRequireLineOfSight
                return true
            end
            return false
        end)
        
        if success and result then
            hum.PlatformStand = false
            hrp.Velocity = Vector3.new(0, 0, 0)
            return true
        end
        task.wait(0.4)
    end
    
    hum.PlatformStand = false
    return false
end

local function cancelQuest()
    pcall(function()
        local netEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
            and game:GetService("ReplicatedStorage").Modules:FindFirstChild("NetworkFramework")
            and game:GetService("ReplicatedStorage").Modules.NetworkFramework:FindFirstChild("NetworkEvent")
        if netEvent then
            netEvent:FireServer("fire", nil, "Quest", "Cancel")
            task.wait(0.5)
        end
    end)
end

local function getStableLookAt(eye, target)
    local dir = (target - eye)
    if dir.Magnitude < 0.1 then return CFrame.new(eye) end
    dir = dir.Unit
    local up = Vector3.new(0, 1, 0)
    if math.abs(dir:Dot(up)) > 0.99 then up = Vector3.new(0, 0, 1) end
    return CFrame.lookAt(eye, target, up)
end

-- ============================================================
-- ระบบ No-Clip & Movers
-- ============================================================
local RunService = game:GetService("RunService")
local noclipConn = nil

local function startNoclip()
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = RunService.Stepped:Connect(function()
        if not (FarmEnabledState or MultiFarmEnabledState or EventFarmEnabledState or AutoBossFarmState or DungeonActiveState) then
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
            return
        end
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
    table.insert(connections, noclipConn)
end

local function manageMovers(hrp, enable, targetCFrame)
    if enable then
        local bv = hrp:FindFirstChild("ZenithSoul_BV") or Instance.new("BodyVelocity")
        bv.Name = "ZenithSoul_BV"
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = hrp

        local bg = hrp:FindFirstChild("ZenithSoul_BG") or Instance.new("BodyGyro")
        bg.Name = "ZenithSoul_BG"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        if targetCFrame then bg.CFrame = targetCFrame end
        bg.Parent = hrp
    else
        local bv = hrp:FindFirstChild("ZenithSoul_BV")
        if bv then bv:Destroy() end
        local bg = hrp:FindFirstChild("ZenithSoul_BG")
        if bg then bg:Destroy() end
    end
end

-- ============================================================
-- ระบบคำนวณเป้าหมายและลูปโจมตีมอนสเตอร์/บอส
-- ============================================================
local lastTargetName = nil
local lastTargetInstance = nil
local currentQueueIndex = 0
local currentNameKillCount = 0
local KILLS_PER_MONSTER = 5

local suppressAttackUntil = 0
local comboInProgress = false
local lastAutoQuestTarget = nil
local questPending = false

local function autoAcceptQuestFor(monsterName)
    if questPending or monsterName == lastAutoQuestTarget then return end
    if AutoBossFarmState or DungeonActiveState then return end
    
    local npcName = MobToNPC[monsterName]
    if not npcName then
        lastAutoQuestTarget = monsterName
        return
    end

    local targetPart = resolveTargetPart(monsterName)
    if targetPart then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local targetPos = targetPart:IsA("BasePart") and targetPart.Position or (targetPart:FindFirstChildOfClass("BasePart") and targetPart:FindFirstChildOfClass("BasePart").Position)
            if targetPos then
                local dist = (hrp.Position - targetPos).Magnitude
                if dist > 350 then return end
            end
        end
    end

    questPending = true
    lastAutoQuestTarget = monsterName
    task.spawn(function()
        cancelQuest()
        local ok = acceptQuest(npcName)
        if not ok then lastAutoQuestTarget = nil end
        questPending = false
    end)
end

local wasFarming = false

task.spawn(function()
    while _G.ZenithSoul_Session == mySession do
        task.wait(0.02)
        
        local currentTool = SelectedTool
        if currentTool == "None" or not currentTool then
            local weapons = getWeaponList()
            if weapons[1] and weapons[1] ~= "None" then
                currentTool = weapons[1]
                SelectedTool = weapons[1]
            end
        end

        if currentTool == "None" then
            removePlatform()
            continue
        end

        local activeFarm = nil
        
        if FarmEnabledState and SelectedMonster ~= "None" then
            activeFarm = SelectedMonster
        elseif MultiFarmEnabledState and #SelectedMultiMonsters > 0 then
            pcall(function()
                if lastTargetInstance and lastTargetInstance.Parent and lastTargetInstance:FindFirstChild("Humanoid") and lastTargetInstance.Humanoid.Health > 0 then
                    activeFarm = lastTargetInstance.Name
                else
                    if comboInProgress then
                        activeFarm = lastTargetName
                        return
                    end
                    if lastTargetName then currentNameKillCount = currentNameKillCount + 1 end
                    if lastTargetName and currentNameKillCount < KILLS_PER_MONSTER then
                        local sameMobType = getTargetMobByName(lastTargetName)
                        lastTargetInstance = sameMobType
                        activeFarm = lastTargetName
                        return
                    end

                    currentNameKillCount = 0
                    currentQueueIndex = currentQueueIndex + 1
                    if currentQueueIndex > #SelectedMultiMonsters then currentQueueIndex = 1 end

                    local nextName = SelectedMultiMonsters[currentQueueIndex]
                    lastTargetName = nextName
                    lastTargetInstance = getTargetMobByName(nextName)
                    activeFarm = nextName
                end
            end)
        elseif EventFarmEnabledState and #SelectedEventMonsters > 0 then
            pcall(function()
                if lastTargetInstance and lastTargetInstance.Parent and lastTargetInstance:FindFirstChild("Humanoid") and lastTargetInstance.Humanoid.Health > 0 then
                    activeFarm = lastTargetInstance.Name
                else
                    if comboInProgress then
                        activeFarm = lastTargetName
                        return
                    end
                    if lastTargetName then currentNameKillCount = currentNameKillCount + 1 end
                    if lastTargetName and currentNameKillCount < KILLS_PER_MONSTER then
                        local sameMobType = getTargetMobByName(lastTargetName)
                        lastTargetInstance = sameMobType
                        activeFarm = lastTargetName
                        return
                    end

                    currentNameKillCount = 0
                    currentQueueIndex = currentQueueIndex + 1
                    if currentQueueIndex > #SelectedEventMonsters then currentQueueIndex = 1 end

                    local nextName = SelectedEventMonsters[currentQueueIndex]
                    lastTargetName = nextName
                    lastTargetInstance = getTargetMobByName(nextName)
                    activeFarm = nextName
                end
            end)
        elseif AutoBossFarmState and SelectedBoss ~= "None" then
            activeFarm = SelectedBoss
        end

        if activeFarm then
            wasFarming = true
            if not noclipConn then startNoclip() end

            if FarmEnabledState then
                autoAcceptQuestFor(activeFarm)
                if questPending then continue end
            end

            pcall(function()
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if hrp and hum and hum.Health > 0 then
                    teleportToIsland(activeFarm)
                    
                    local target = getTargetMobByName(activeFarm)
                    if target and target:FindFirstChild("HumanoidRootPart") then
                        local targetHrp = target:FindFirstChild("HumanoidRootPart")
                        if targetHrp then
                            local platform = getOrCreatePlatform()
                            hum.PlatformStand = true
                            
                            local targetPos = targetHrp.Position
                            local goalCFrame
                            
                            if FarmAngleState == "Above" or FarmAngleState == "บน" then
                                local myPos = targetPos + Vector3.new(0, FarmDistanceState, 0)
                                goalCFrame = getStableLookAt(myPos, targetPos)
                            elseif FarmAngleState == "Below" or FarmAngleState == "ล่าง" then
                                local myPos = targetPos - Vector3.new(0, FarmDistanceState, 0)
                                goalCFrame = getStableLookAt(myPos, targetPos)
                            else
                                local offset = CFrame.new(0, 0, FarmDistanceState)
                                local targetRotation = targetHrp.CFrame - targetHrp.CFrame.Position
                                goalCFrame = CFrame.new(targetPos) * targetRotation * offset
                            end
                            
                            platform.CFrame = goalCFrame * CFrame.new(0, -3.5, 0)

                            hrp.CFrame = goalCFrame
                            hrp.Velocity = Vector3.new(0, 0, 0)
                            hrp.RotVelocity = Vector3.new(0, 0, 0)
                        end
                    else
                        if hum then hum.PlatformStand = false end
                        manageMovers(hrp, false)
                        removePlatform()
                        
                        local uprightLook = hrp.CFrame.LookVector
                        uprightLook = Vector3.new(uprightLook.X, 0, uprightLook.Z)
                        if uprightLook.Magnitude < 0.01 then uprightLook = Vector3.new(0, 0, 1) end
                        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + uprightLook)
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        hrp.RotVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
        else
            if wasFarming and not DungeonActiveState then
                wasFarming = false
                pcall(function()
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    
                    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
                    if hum then hum.PlatformStand = false end
                    if hrp then
                        manageMovers(hrp, false)
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        hrp.RotVelocity = Vector3.new(0, 0, 0)
                    end
                    if char then
                        for _, part in ipairs(char:GetChildren()) do
                            if part:IsA("BasePart") then part.CanCollide = true end
                        end
                    end
                end)
                task.wait(0.15)
                removePlatform()
            end
        end
    end
end)

-- ============================================================
-- ระบบปลดปล่อยสกิลคอมโบ
-- ============================================================
local function runSkillBurst()
    pcall(function()
        local activeName = nil
        if FarmEnabledState then
            activeName = SelectedMonster
        elseif MultiFarmEnabledState then
            activeName = lastTargetName
        elseif EventFarmEnabledState then
            activeName = lastTargetName
        elseif AutoBossFarmState then
            activeName = SelectedBoss
        end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if DungeonActiveState and dungeonTargetMob and dungeonTargetMob:FindFirstChild("HumanoidRootPart") then
            if (hrp.Position - dungeonTargetMob.HumanoidRootPart.Position).Magnitude > 60 then return end
        else
            if not activeName then return end
            local mobTarget = getTargetMobByName(activeName)
            if not (mobTarget and mobTarget:FindFirstChild("HumanoidRootPart")) then return end
            if (hrp.Position - mobTarget.HumanoidRootPart.Position).Magnitude > 60 then return end
        end

        local remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5)
        local actionRemote = remotes and remotes:WaitForChild("Action", 5)
        if not actionRemote then return end

        local rawSkills = {}
        if skillDropdown and type(skillDropdown.Get) == "function" then
            pcall(function() rawSkills = skillDropdown:Get() end)
        else
            rawSkills = SelectedSkills
        end
        local selectedSet = {}
        for _, v in ipairs(rawSkills) do
            if type(v) == "string" then selectedSet[string.upper(v)] = true end
        end

        local order = WeaponSkillOrder[SelectedTool] or DEFAULT_SKILL_ORDER
        local skillsToTrigger = {}
        for _, key in ipairs(order) do
            if selectedSet[string.upper(key)] then
                table.insert(skillsToTrigger, key)
            end
        end
        if #skillsToTrigger == 0 then return end

        comboInProgress = true
        local pauseDuration = 0.3
        suppressAttackUntil = tick() + pauseDuration

        while tick() < suppressAttackUntil do
            for _, skillKey in ipairs(skillsToTrigger) do
                if tick() >= suppressAttackUntil then break end
                local args = { SelectedTool, skillKey }
                actionRemote:FireServer(unpack(args))
                task.wait(0.08)
            end
        end
        comboInProgress = false
    end)
end

local swingCount = 0
task.spawn(function()
    while _G.ZenithSoul_Session == mySession do
        task.wait(0.08)
        if tick() < suppressAttackUntil then continue end

        local isAttackingMode = FarmEnabledState or MultiFarmEnabledState or EventFarmEnabledState or AutoBossFarmState or DungeonActiveState

        if SelectedTool ~= "None" and isAttackingMode then
            pcall(function()
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local tool = char:FindFirstChild(SelectedTool) or player.Backpack:FindFirstChild(SelectedTool)
                    if tool then
                        if tool.Parent ~= char then hum:EquipTool(tool) end
                        tool:Activate()

                        if AutoSkillEnabled then
                            swingCount = swingCount + 1
                            if swingCount >= 4 then
                                swingCount = 0
                                runSkillBurst()
                            end
                        else
                            swingCount = 0
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- ส่วนการสวมใส่อาวุธ
-- ============================================================
local function equipSelectedTool(char)
    if AutoEquipState and SelectedTool ~= "None" then
        task.wait(0.5)
        local backpack = player:FindFirstChild("Backpack")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if backpack and hum and hum.Health > 0 then
            local tool = backpack:FindFirstChild(SelectedTool)
            if tool and tool:IsA("Tool") then hum:EquipTool(tool) end
        end
    end
end

local charAddedConn = player.CharacterAdded:Connect(function(newChar)
    if _G.ZenithSoul_Session ~= mySession then return end
    task.wait(1.5)
    
    local cAddedSub = newChar.ChildAdded:Connect(function(child)
        if _G.ZenithSoul_Session ~= mySession then return end
        if child:IsA("Tool") then task.wait(0.2) end
    end)
    registerConn(cAddedSub)
    equipSelectedTool(newChar)
    if HakiEnabledState then
        task.wait(1)
        fireHaki()
    end
end)
registerConn(charAddedConn)

if player.Character then
    task.spawn(function() 
        if _G.ZenithSoul_Session ~= mySession then return end
        equipSelectedTool(player.Character) 
        local charChildConn = player.Character.ChildAdded:Connect(function(child)
            if _G.ZenithSoul_Session ~= mySession then return end
            if child:IsA("Tool") then task.wait(0.2) end
        end)
        registerConn(charChildConn)
    end)
end

-- ============================================================
-- CATEGORY: Bosses
-- ============================================================
local TabSummonBoss = Window.AddTab(L.TabSummonBoss, "Bosses")
TabSummonBoss:AddSection(L.SectionSummon)

local BossNameList = {"GooGooGaaGaa", "Dark Bacon"}

TabSummonBoss:AddDropdown("Boss", "", BossNameList, SelectedBoss, function(v)
    SelectedBoss = v
end, "SelectedBoss")

TabSummonBoss:AddToggle(L.AutoSummon, L.AutoSummonDesc, function(state)
    AutoBossFarmState = state
end, "AutoBossFarmState")

task.spawn(function()
    while _G.ZenithSoul_Session == mySession do
        task.wait(1.5)
        if AutoBossFarmState and SelectedBoss ~= "None" then
            pcall(function()
                local bossModel = getBossModel(SelectedBoss)
                if not bossModel then
                    local args = {
                        [1] = "fire",
                        [3] = "SummonBoss",
                        [4] = SelectedBoss
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("NetworkFramework"):WaitForChild("NetworkEvent"):FireServer(unpack(args))
                    task.wait(2)
                end
            end)
        end
    end
end)

-- ============================================================
-- CATEGORY: Dungeon (ระบบออโต้ลงดันเจี้ยนใหม่)
-- ============================================================
local TabDungeon = Window.AddTab(L.TabDungeon, "Dungeon")
TabDungeon:AddSection(L.SectionDungeon)

local dungeonRunning = false

local function getNearbyDungeonMob(radius)
    radius = radius or 300
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closestMob = nil
    local minDistance = radius

    local mobFolder = workspace:FindFirstChild("Mob") or workspace
    for _, mob in ipairs(mobFolder:GetChildren()) do
        if mob:IsA("Model") and mob:FindFirstChildOfClass("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local mHrp = mob.HumanoidRootPart
            if hum.Health > 0 and mob.Name ~= player.Name then
                local dist = (hrp.Position - mHrp.Position).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    closestMob = mob
                end
            end
        end
    end
    return closestMob
end

local function startDungeonLoop()
    if dungeonRunning then return end
    dungeonRunning = true

    task.spawn(function()
        while _G.ZenithSoul_Session == mySession and DungeonActiveState do
            pcall(function()
                Window.Notify({Title = "Dungeon", Description = "กำลังเดินทางไปเปิดดันเจี้ยน...", Duration = 3})

                local npcPromptFolder = workspace:FindFirstChild("NpcPrompt")
                local openDungeonNpc = npcPromptFolder and npcPromptFolder:FindFirstChild("Open Dungeon")
                
                if openDungeonNpc then
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local npcPart = openDungeonNpc:IsA("BasePart") and openDungeonNpc or openDungeonNpc:FindFirstChildWhichIsA("BasePart", true)
                        if npcPart then
                            hrp.CFrame = npcPart.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.5)

                            local prompt = openDungeonNpc:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end

                task.wait(0.5)
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local targetCFrame = CFrame.new(124.15, 24.52, 183.81)
                    hrp.CFrame = targetCFrame
                    local platform = getOrCreatePlatform()
                    platform.CFrame = targetCFrame * CFrame.new(0, -3.5, 0)
                end

                Window.Notify({Title = "Dungeon", Description = "รอระบบสร้างดันเจี้ยน 17 วินาที...", Duration = 3})
                task.wait(17)

                local dungeonMap = workspace:FindFirstChild("DungeonMap")
                local hasDungeon = dungeonMap and (#dungeonMap:GetChildren() > 0)

                if hasDungeon then
                    Window.Notify({Title = "Dungeon", Description = "เข้าสู่ดันเจี้ยนสำเร็จ! เริ่มทำการฟาร์ม", Duration = 3})

                    while _G.ZenithSoul_Session == mySession and DungeonActiveState and dungeonMap and #dungeonMap:GetChildren() > 0 do
                        local mob = getNearbyDungeonMob(300)
                        dungeonTargetMob = mob

                        if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") then
                            local hum = char:FindFirstChildOfClass("Humanoid")
                            local mobHrp = mob.HumanoidRootPart
                            if hum and hrp then
                                hum.PlatformStand = true
                                local platform = getOrCreatePlatform()
                                local myPos = mobHrp.Position + Vector3.new(0, FarmDistanceState or 10, 0)
                                local goalCFrame = getStableLookAt(myPos, mobHrp.Position)

                                platform.CFrame = goalCFrame * CFrame.new(0, -3.5, 0)
                                hrp.CFrame = goalCFrame
                                hrp.Velocity = Vector3.new(0, 0, 0)
                            end
                        else
                            dungeonTargetMob = nil
                            removePlatform()
                        end
                        task.wait(0.1)
                    end
                    Window.Notify({Title = "Dungeon", Description = "ดันเจี้ยนจบแล้ว เตรียมเริ่มรอบใหม่...", Duration = 3})
                else
                    Window.Notify({Title = "Dungeon", Description = "ไม่พบดันเจี้ยน ลองใหม่อีกครั้ง...", Duration = 3})
                end
            end)
            task.wait(2)
        end
        dungeonTargetMob = nil
        dungeonRunning = false
        removePlatform()
    end)
end

TabDungeon:AddToggle(L.EnableDungeon, "", function(state)
    DungeonActiveState = state
    if state then
        startDungeonLoop()
    else
        dungeonTargetMob = nil
        removePlatform()
    end
end, "DungeonActiveState")

-- ============================================================
-- CATEGORY: Progression (เควส & อัพสเตตัส)
-- ============================================================

local TabTeleportNPC = Window.AddTab(L.TabTeleportNPC, "Progression")
TabTeleportNPC:AddSection(L.SectionQuestNPC)

local questOptions = {}
local questLabelToNPC = {}
for npc, mob in pairs(QuestMap) do
    local label = npc .. " (" .. mob .. ")"
    table.insert(questOptions, label)
    questLabelToNPC[label] = npc
end
table.sort(questOptions)

local selectedQuestLabel = questOptions[1]
TabTeleportNPC:AddDropdown(L.SelectNPC, "", questOptions, selectedQuestLabel, function(v)
    selectedQuestLabel = v
end, "SelectedQuestNPC")

TabTeleportNPC:AddButton(L.TeleportAndAccept, function()
    local npcName = questLabelToNPC[selectedQuestLabel]
    if npcName then
        cancelQuest()
        local ok = acceptQuest(npcName)
        Window.Notify({Title = "Quest", Description = ok and ("Accepted: " .. npcName) or "ไม่พบ Prompt", Duration = 3})
    end
end)

local TabStatus = Window.AddTab(L.TabStatus, "Progression")
TabStatus:AddSection(L.SectionStatUpgrade)

local StatOptions = {"Melee", "Defense", "Sword", "Power"}
local SelectedStats = {}
TabStatus:AddMultiDropdown(L.SelectStats, "", StatOptions, {}, function(v)
    SelectedStats = v
end, "SelectedStats")

local StatUpgradeAmount = 1
TabStatus:AddSpeedSlider(L.Amount, 1, 100, 1, function(v)
    StatUpgradeAmount = v
end, "Amount")

local function upgradeStat(statName, amount)
    pcall(function()
        for i = 1, amount do
            local args = { "UpStats", statName, 1 }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("System"):FireServer(unpack(args))
            task.wait(0.05)
        end
    end)
end

TabStatus:AddButton(L.UpgradeSelected, function()
    for _, stat in ipairs(SelectedStats) do
        upgradeStat(stat, StatUpgradeAmount)
    end
    Window.Notify({Title = "Status", Description = "Upgraded: " .. table.concat(SelectedStats, ", "), Duration = 3})
end)

local AutoUpgradeOnScan = false
TabStatus:AddToggle(L.AutoUpgradeOnScan, "", function(state)
    AutoUpgradeOnScan = state
end, "AutoUpgradeOnScan")

task.spawn(function()
    while _G.ZenithSoul_Session == mySession do
        task.wait(10)
        if AutoUpgradeOnScan and _G.WeaponScanActive and #SelectedStats > 0 then
            for _, stat in ipairs(SelectedStats) do
                upgradeStat(stat, StatUpgradeAmount)
            end
        end
    end
end)

-- ============================================================
-- ร้านค้า (Shop) - สุ่มกล่อง
-- ============================================================
TabStatus:AddSection("Shop")

local BoxOptions = {"x1", "x5", "x15"}
local SelectedBox = "x15"
TabStatus:AddDropdown("กล่องสุ่ม", "", BoxOptions, SelectedBox, function(v)
    SelectedBox = v
end, "SelectedBox")

local function openRandomBox()
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("NetworkFramework"):WaitForChild("NetworkEvent"):FireServer("fire", nil, "RandomItem", SelectedBox)
    end)
end

local AutoRandomBoxState = false
TabStatus:AddToggle("ออโต้สุ่ม", "", function(state)
    AutoRandomBoxState = state
end, "AutoRandomBoxState")

task.spawn(function()
    while _G.ZenithSoul_Session == mySession do
        task.wait(3)
        if AutoRandomBoxState then
            openRandomBox()
        end
    end
end)

-- ============================================================
-- CATEGORY: Settings
-- ============================================================

local TabGeneral = Window.AddTab(L.TabGeneral, "Settings")
TabGeneral:AddSection(L.SectionGeneral)
TabGeneral:AddDropdown(L.Theme, "", {"Black", "White", "GreenBlack", "NeonPurple"}, "Black", function(v)
    Window.SetTheme(v)
end, "SelectedTheme")

TabGeneral:AddSection(L.SectionLanguage)
TabGeneral:AddDropdown(L.Language, "", {"Thai", "English"}, currentLang, function(v)
    if v ~= currentLang then
        pcall(function()
            Window.SaveConfig("default")
        end)
        Window.Notify({Title = "Language", Description = "Switching to " .. v .. "...", Duration = 1})
        task.delay(0.3, function()
            Window.Destroy()
            if _G.ZenithSoul_Cleanup then pcall(_G.ZenithSoul_Cleanup) end
            loadstring(game:HttpGet(SCRIPT_URL))()
        end)
    end
end, "SelectedLanguage")

TabGeneral:AddSection(L.SectionDisplay)

local SafeParent = player:FindFirstChild("PlayerGui")
pcall(function() if game:GetService("CoreGui") then SafeParent = game:GetService("CoreGui") end end)

local blackScreenGui = Instance.new("ScreenGui")
blackScreenGui.Name = "ZenithSoul_BlackScreen"
blackScreenGui.IgnoreGuiInset = true
blackScreenGui.ResetOnSpawn = false
blackScreenGui.Enabled = false
blackScreenGui.Parent = SafeParent

local blackScreenFrame = Instance.new("Frame")
blackScreenFrame.Size = UDim2.new(1, 0, 1, 0)
blackScreenFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
blackScreenFrame.BorderSizePixel = 0
blackScreenFrame.Parent = blackScreenGui

local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0, 200, 0, 50)
exitBtn.AnchorPoint = Vector2.new(0.5, 0.5)
exitBtn.Position = UDim2.new(0.5, 0, 0.1, 0)
exitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
exitBtn.Text = L.ExitBlackScreen
exitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exitBtn.Font = Enum.Font.GothamBold
exitBtn.TextSize = 14
exitBtn.Parent = blackScreenFrame
do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = exitBtn
end

local exitBtnConn = exitBtn.MouseButton1Click:Connect(function()
    blackScreenGui.Enabled = false
end)
registerConn(exitBtnConn)

TabGeneral:AddToggle(L.BlackScreen, "", function(state)
    blackScreenGui.Enabled = state
end, "BlackScreen")

TabGeneral:AddKeybind(L.ToggleKey, "", Enum.KeyCode.RightShift, function(key)
    if Window.Toggle then Window.Toggle() end
end, "ToggleKey")

-- ============================================================
-- กันหลุด / รีจอย
-- ============================================================
TabGeneral:AddSection(L.SectionAntiKick)

local AutoRejoinEnabled = true
TabGeneral:AddCheckbox(L.AutoRejoin, "", true, function(state)
    AutoRejoinEnabled = state
end, "AutoRejoinEnabled")

task.spawn(function()
    while _G.ZenithSoul_Session == mySession do
        task.wait(90)
        if AutoRejoinEnabled then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end
    end
end)

-- Tab 2: Config Management
local TabConfig = Window.AddTab(L.TabConfig, "Settings")
TabConfig:AddButton(L.SaveConfig, function()
    Window.SaveConfig("default")
end)

TabConfig:AddButton(L.ResetConfig, function()
    pcall(function()
        if isfile and delfile and isfile("ZenithSoul/configs/default.json") then
            delfile("ZenithSoul/configs/default.json")
        end
    end)
    Window.Notify({Title = "Reset", Description = "Reloading...", Duration = 1})
    task.delay(0.3, function()
        Window.Destroy()
        if _G.ZenithSoul_Cleanup then pcall(_G.ZenithSoul_Cleanup) end
        loadstring(game:HttpGet(SCRIPT_URL))()
    end)
end)

pcall(function()
    Window.LoadConfig("default")
end)
