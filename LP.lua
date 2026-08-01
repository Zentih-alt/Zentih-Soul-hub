-- เทส
local Solar = nil
local Success, Error = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/discounthee-sys/Zenith-Soul-hub/refs/heads/main/Solar.lua"))()
end)

if not Success then
    return
end

Solar = Error

-- ==========================================
-- ANTI CONSOLE SPAM (Only runs once)
-- ==========================================
if hookfunction and getrenv and not _G.ZenithAntiSpamHooked then
    _G.ZenithAntiSpamHooked = true
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
-- DEFAULT CONFIGURATION & GLOBAL VARIABLES
-- ==========================================
local DefaultConfig = {
    SelectedLanguage        = "English",
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
    SummonJinwooV2Enabled   = false,
    AutoAizenEnabled        = false,

    AutoGodSummonEnabled    = false,
    SelectedGodBoss         = "Gilgamesh",
    SelectedGodDifficulty   = "Easy",

    AutoStatsEnabled        = false,
    SelectedStat            = "Strength",
    StatsAmount             = 1,

    SelectedTeleportTarget  = "None",
    SelectedNPCTarget       = "None",
    SearchTeleportName      = "",

    SelectedTheme           = "Dark",
    AntiAFKEnabled          = false,
    LowLagMode              = false,

    AutoJoinTower           = false, 
    AutoKillTower           = false,
    AutoFarmBossAll         = false,
    AutoFarmNoQuest         = false,
    BlackScreenEnabled      = false,

    SelectedPortalDifficulty = "Easy",
    SelectedPortalName       = "SHADOW",
    AutoStartPortal          = false,
    AutoStartGameInPortal    = false,
    
    AutoPitySystem           = false,
    PityTargetValue          = 24,
    
    AutoSkillEnabled         = false,
    SelectedSkills           = {} 
}

local Config = {}
for k, v in pairs(DefaultConfig) do Config[k] = v end

-- Shared State Variables (Reset on Re-Script)
local LastTargetQuest = "None"
local CurrentFarmTarget = nil
local IsFarmingActive = false
local IsSwitchingTarget = false
local LastSafePosition = nil
local LastRimuruSummonTime = 0
local LastJinwooV2SummonTime = 0
local PityReachedTime = nil 
local PityDelayTime = 15.0 
local LastGodExchangeTime = 0
local LastGodSummonTime = 0
local LastPitySummonTime = 0
local LastSummonBossTime = 0
local LastBattleBossTime = 0
local PendingBossTarget = nil
local BossDetectionTime = 0
local TeleportTween = nil
local LastGilSnowTeleportTime = 0  

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local SaveFolder = "ZenithSoulHub"
local SaveFile = SaveFolder .. "/Config.json"

-- ==========================================
-- LOCALIZATION DICTIONARY (WITH DESCRIPTIONS)
-- ==========================================
local Translations = {
    English = {
        MainTab = "Home", FarmTab = "Farm", BossTab = "Boss", DungeonTab = "Dungeon", StatsTab = "Stats", TeleportTab = "Teleport", SettingsTab = "Settings",
        MenuTab = "Menu", SetTab = "Set", BossSummonTab = "Boss Summon", PortalTab = "Portal", AppearanceTab = "Appearance",
        MenuDesc = "Menu navigation.", PlayerName = "Player", RemoveScript = "Remove Script & Reset UI",
        Welcome = "Zenith Soul Hub", Subtitle = "// Lineage Piece", Desc = "Free Version.",
        DiscordSection = "Community", DiscordDesc = "Join our Discord for updates, support, and announcements.", DiscordLink = "Copy Discord Link", DiscordCopied = "Discord link copied to clipboard!",
        CombatSetup = "Combat Setup", SelectWeapon = "Select Melee / Weapon", AutoEquip = "Auto Equip", AutoEquipDesc = "equips the selected tool.", RefreshWeapons = "Refresh Weapons List",
        PositionSettings = "Position Settings", AttackAngle = "Attack Position / Angle", DistanceOffset = "Distance Offset Range",
        FarmingSystems = "Farming Systems", SelectMonster = "Select Monster", AutoFarm = "Auto Farm", AutoFarmDesc = "farm selected monster.", AutoFarmNoQuest = "Auto Farm (No Quest)", AutoFarmNoQuestDesc = "Farms the monster.",
        SpecialTargets = "Special Targets", KillStone = "Auto Kill Stone Boss", KillStoneDesc = "Prioritizes Stone Boss over normal monsters.", FarmAllBoss = "Auto Farm Boss All", FarmAllBossDesc = "Farms all boss.",
        BossSummoning = "Boss Summoning", SelectSummon = "Select Summon Boss", AutoSummon = "Auto Summon Boss", AutoSummonDesc = "Automatically spawns the selected boss.",
        GodSummoning = "God Summon System", SelectTargetBoss = "Select Target Boss", SelectDifficulty = "Select Difficulty", AutoSummonFarm = "Auto Summon & Farm", AutoSummonFarmDesc = "auto farm boss",
        BossFarming = "Boss Farming", SelectBattleBoss = "Select Battle Boss", AutoBoss = "Auto Boss", PriorityTargets = "Priority Targets", AutoFarmBoss = "Auto Farm Priority Boss",
        SpecialEvents = "Special Events", FarmAizen = "Auto Farm Aizen", FarmAizenDesc = "Kills Hollows -> Checks 50/50 -> Summons Aizen.", SummonRimuru = "Summon Rimuru", SummonJinwooV2 = "Summon Sung Jinwoo V2 (Clone)",
        AutoPitySystem = "Auto Pity System (Verdant Hero)", EnablePity = "Enable Auto Pity System", EnablePityDesc = "Farms Verdant Hero until pity is reached.", PityTarget = "Pity Target Value",
        TowerSystems = "Tower Systems", AutoTower = "Auto Tower (Join & Kill)", AutoTowerDesc = "Automatically joins and completes Tower stages.",
        PortalSystems = "Portal Systems", PortalLevel = "Portal Level", AutoStartPortal = "AutoStart Portal", AutoStartPortalDesc = "Automatically creates and enters the portal.", AutoKillPortal = "Auto Kill Portal", AutoKillPortalDesc = "Automatically farms enemies inside the portal.",
        AutoAllocate = "Auto Allocate Points", StatType = "Select Stat Type", StatAmount = "Stat Points Amount", EnableAutoStats = "Enable Auto Stats",
        AutoSkills = "Auto Skills (In-Game System)", EnableAutoSkill = "Enable Auto Skill", EnableAutoSkillDesc = "Fires selected skills during active combat.", SelectSkills = "Select Skill",
        SkillSwitch = "Skill Switch", SkillSwitchDesc = "Enable/disable the selected skill above.",
        InstantTeleport = "Instant Teleportation", SearchWorld = "Search World Target", SelectMap = "Select Map Target", ActivateTeleport = "Activate Teleport",
        NPCTeleport = "Teleport to NPC", SelectNPC = "Select NPC",
        LangInit = "Language & Initialization", LanguageSelect = "Language / ภาษา / Ngôn ngữ", ReScript = "Re-Script UI", ReScriptDesc = "Completely reloads the script without rejoining.",
        MainConfig = "Main Configuration", SaveConfig = "Save Config Now", ResetSettings = "Reset All Settings", 
        PerfApp = "Performance & Appearance", SelectGuiTheme = "Select GUI Theme", AntiAfk = "Anti-AFK Security", AntiAfkDesc = "Prevents you from being kicked for inactivity.", LowLag = "Low Lag Mode", LowLagDesc = "Removes textures/shadows for FPS",
        AfkSystem = "AFK System", BlackScreen = "Black Screen (AFK Mode)", BlackScreenDesc = "Renders screen black to save processing power.",
        LangChangedNotif = "Language changed. Please press Re-Script.", LangTitle = "Language Updated", ReloadNotif = "Successfully reloaded Zenith Hub!"
    },
    Thai = {
        MainTab = "หน้าแรก", FarmTab = "ฟาร์ม", BossTab = "บอส", DungeonTab = "ดันเจี้ยน", StatsTab = "สเตตัส", TeleportTab = "เทเลพอร์ต", SettingsTab = "ตั้งค่า",
        MenuTab = "เมนู", SetTab = "ตั้งค่าฟาร์ม", BossSummonTab = "เสกบอส", PortalTab = "ประตูมิติ", AppearanceTab = "ปรับสี",
        MenuDesc = "เมนูนำทาง", PlayerName = "ผู้เล่น", RemoveScript = "ลบสคริปต์ทั้งยูไอ",
        Welcome = "Zenith Soul Hub", Subtitle = "// Lineage Piece", Desc = "เวอร์ชันฟรี",
        DiscordSection = "ชุมชน", DiscordDesc = "เข้าร่วม Discord เพื่ออัปเดต ขอความช่วยเหลือ และประกาศข่าวสาร", DiscordLink = "คัดลอกลิงก์ Discord", DiscordCopied = "คัดลอกลิงก์ Discord แล้ว!",
        CombatSetup = "ตั้งค่าการต่อสู้", SelectWeapon = "เลือกอาวุธ / หมัด", AutoEquip = "ติดตั้งอาวุธฮัตโนมัติ", AutoEquipDesc = "ถืออาวุธที่เลือกอัตโนมัติเวลาฟาร์ม", RefreshWeapons = "รีเฟรชรายชื่ออาวุธ",
        PositionSettings = "ตั้งค่าตำแหน่ง", AttackAngle = "มุมโจมตี / ตำแหน่ง", DistanceOffset = "ระยะห่างจากเป้าหมาย",
        FarmingSystems = "ระบบฟาร์มหลัก", SelectMonster = "เลือกมอนสเตอร์", AutoFarm = "เปิดฟาร์มอัตโนมัติ", AutoFarmDesc = "โจมตีมอนสเตอร์ที่เลือกอัตโนมัติ", AutoFarmNoQuest = "ฟาร์มอัตโนมัติ (ไม่ทำเควส)", AutoFarmNoQuestDesc = "ฟาร์มมอนสเตอร์โดยไม่รับเควส",
        SpecialTargets = "เป้าหมายพิเศษ", KillStone = "ฟาร์มบอสสโตนอัตโนมัติ", KillStoneDesc = "จัดลำดับความสำคัญให้บอสสโตนก่อนมอนสเตอร์ทั่วไป", FarmAllBoss = "ฟาร์มบอสทั้งหมดอัตโนมัติ", FarmAllBossDesc = "ไล่ฟาร์มบอสทุกตัวที่มีในแผนที่",
        BossSummoning = "ระบบเสกบอส", SelectSummon = "เลือกบอสที่จะเสก", AutoSummon = "เสกบอสอัตโนมัติ", AutoSummonDesc = "เสกบอสที่เลือกอัตโนมัติเมื่อพร้อม",
        GodSummoning = "ระบบเสกบอสขั้นสูง", SelectTargetBoss = "เลือกบอสเป้าหมายหลัก", SelectDifficulty = "เลือกระดับความยาก", AutoSummonFarm = "เสกและฟาร์มอัตโนมัติ", AutoSummonFarmDesc = "หามบอส สุดโหด",
        BossFarming = "ระบบฟาร์มบอส", SelectBattleBoss = "เลือกแบทเทิลบอส", AutoBoss = "เปิดบอสอัตโนมัติ", PriorityTargets = "เป้าหมายสำคัญ", AutoFarmBoss = "ฟาร์มบอสหลักอัตโนมัติ",
        SpecialEvents = "อีเวนต์พิเศษ", FarmAizen = "ฟาร์มไอเซ็นอัตโนมัติ", FarmAizenDesc = "ตี Hollows -> เช็ค 50/50 -> เสกไอเซ็น", SummonRimuru = "เสกริมุรุ", SummonJinwooV2 = "เสกซงจินวู v2 (ทุก 1.3 นาที)",
        AutoPitySystem = "ระบบการันตีอัตโนมัติ (Verdant Hero)", EnablePity = "เปิดระบบการันตีอัตโนมัติ", EnablePityDesc = "ฟาร์ม Verdant Hero จนกว่าจะถึงการันตี", PityTarget = "ตั้งค่าจำนวนการันตี",
        TowerSystems = "ระบบหอคอย", AutoTower = "ลงหอคอยอัตโนมัติ (เข้าและสู้)", AutoTowerDesc = "เข้าร่วมและเคลียร์ด่านหอคอยอัตโนมัติ",
        PortalSystems = "ระบบประตูมิติ", PortalLevel = "ระดับความยาก", AutoStartPortal = "เข้าประตูมิติอัตโนมัติ", AutoStartPortalDesc = "สร้างและเข้าประตูมิติอัตโนมัติ", AutoKillPortal = "สู้ในประตูมิติอัตโนมัติ", AutoKillPortalDesc = "จัดการศัตรูในประตูมิติอัตโนมัติ",
        AutoAllocate = "อัปสเตตอัตโนมัติ", StatType = "เลือกประเภทสเตต", StatAmount = "จำนวนแต้มต่อครั้ง", EnableAutoStats = "เปิดอัปสเตตอัตโนมัติ",
        AutoSkills = "ระบบใช้สกิลอัตโนมัติ", EnableAutoSkill = "เปิดใช้สกิลอัตโนมัติ", EnableAutoSkillDesc = "ใช้สกิลที่เลือกอัตโนมัติขณะต่อสู้", SelectSkills = "เลือกสกิล",
        SkillSwitch = "เปิด/ปิด สกิลที่เลือก", SkillSwitchDesc = "เปิดหรือปิดสกิลที่เลือกไว้ด้านบน",
        InstantTeleport = "ระบบวาร์ป", SearchWorld = "ค้นหาเป้าหมาย", SelectMap = "เลือกแผนที่เป้าหมาย", ActivateTeleport = "เริ่มการวาร์ป",
        NPCTeleport = "วาร์ปไปหา NPC", SelectNPC = "เลือก NPC",
        LangInit = "ภาษาและเริ่มต้นใหม่", LanguageSelect = "เลือกภาษา / Language / Ngôn ngữ", ReScript = "โหลดสคริปต์ใหม่ (Re-Script)", ReScriptDesc = "โหลดสคริปต์ใหม่ทั้งหมดโดยไม่ต้องออกเกม",
        MainConfig = "ตั้งค่าหลัก", SaveConfig = "บันทึกการตั้งค่าตอนนี้", ResetSettings = "รีเซ็ตการตั้งค่าทั้งหมด", 
        PerfApp = "ประสิทธิภาพและการแสดงผล", SelectGuiTheme = "เลือกธีมเมนู", AntiAfk = "ป้องกันการหลุด AFK", AntiAfkDesc = "ป้องกันเกมเตะออกเมื่อไม่ได้ขยับตัว", LowLag = "โหมดลดอาการแลค", LowLagDesc = "ลบพื้นผิว/เงาเพื่อเพิ่ม FPS",
        AfkSystem = "ระบบ AFK", BlackScreen = "หน้าจอแบล็คสกรีน (โหมด AFK)", BlackScreenDesc = "ทำให้จอดำเพื่อลดการทำงานของเครื่อง",
        LangChangedNotif = "เปลี่ยนภาษาแล้ว กรุณากด Re-Script", LangTitle = "อัปเดตภาษา", ReloadNotif = "โหลดสคริปต์ใหม่สำเร็จ!"
    },
    Vietnamese = {
        MainTab = "Home", FarmTab = "Farm", BossTab = "Boss", DungeonTab = "Phụ Bản", StatsTab = "Chỉ Số", TeleportTab = "Dịch Chuyển", SettingsTab = "Cài Đặt",
        MenuTab = "Menu", SetTab = "Set", BossSummonTab = "Boss Summon", PortalTab = "Portal", AppearanceTab = "Giao Diện",
        MenuDesc = "Điều hướng menu.", PlayerName = "Người Chơi", RemoveScript = "Xóa Script & Reset UI",
        Welcome = "Zenith Soul Hub", Subtitle = "Lineage Piece", Desc = " Free Version",
        DiscordSection = "Cộng Đồng", DiscordDesc = "Tham gia Discord để cập nhật, hỗ trợ và thông báo.", DiscordLink = "Sao Chép Liên Kết Discord", DiscordCopied = "Đã sao chép liên kết Discord!",
        CombatSetup = "Cài Đặt Chiến Đấu", SelectWeapon = "Chọn Vũ Khí / Cận Chiến", AutoEquip = "Tự Động Trang Bị", AutoEquipDesc = "Tự động cầm vũ khí khi farm.", RefreshWeapons = "Làm Mới Danh Sách Vũ Khí",
        PositionSettings = "Cài Đặt Vị Trí", AttackAngle = "Vị Trí / Góc Tấn Công", DistanceOffset = "Khoảng Cách",
        FarmingSystems = "Hệ Thống Farm", SelectMonster = "Chọn Quái Vật", AutoFarm = "Tự Động Farm", AutoFarmDesc = "Tự động tấn công quái vật đã chọn.", AutoFarmNoQuest = "Tự Động Farm (Không Nhiệm Vụ)", AutoFarmNoQuestDesc = "Farm quái vật mà không nhận nhiệm vụ.",
        SpecialTargets = "Mục Tiêu Đặc Biệt", KillStone = "Tự Động Diệt Boss Stone", KillStoneDesc = "Ưu tiên đánh Boss Stone trước quái vật thường.", FarmAllBoss = "Tự Động Farm Tất Cả Boss", FarmAllBossDesc = "Farm toàn bộ Boss trên bản đồ.",
        BossSummoning = "Triệu Hồi Boss", SelectSummon = "Chọn Boss Triệu Hồi", AutoSummon = "Tự Động Triệu Hồi Boss", AutoSummonDesc = "Tự động gọi Boss đã chọn.",
        GodSummoning = "Hệ Thống Triệu Hồi Nâng Cao", SelectTargetBoss = "Chọn Boss Mục Tiêu", SelectDifficulty = "Chọn Độ Khó", AutoSummonFarm = "Tự Động Triệu Hồi & Farm", AutoSummonFarmDesc = ":)",
        BossFarming = "Hệ Thống Farm Boss", SelectBattleBoss = "Chọn Battle Boss", AutoBoss = "Bật Tự Động Boss", PriorityTargets = "Mục Tiêu Ưu Tiên", AutoFarmBoss = "Tự Động Farm Boss Ưu Tiên",
        SpecialEvents = "Sự Kiện Đặc Biệt", FarmAizen = "Tự Động Farm Aizen", FarmAizenDesc = "Giết Hollows -> Kiểm tra 50/50 -> Gọi Aizen.", SummonRimuru = "Triệu Hồi Rimuru", SummonJinwooV2 = "Triệu hồi Sung Jinwoo V2",
        AutoPitySystem = "Hệ Thống Pity Tự Động", EnablePity = "Bật Hệ Thống Pity", EnablePityDesc = "Farm Verdant Hero cho đến khi đạt pity.", PityTarget = "Giá Trị Pity Mục Tiêu",
        TowerSystems = "Hệ Thống Tháp", AutoTower = "Tự Động Tháp (Tham Gia & Diệt)", AutoTowerDesc = "Tự động vào và hoàn thành các tầng tháp.",
        PortalSystems = "Hệ Thống Cổng", PortalLevel = "Cấp Độ Cổng", AutoStartPortal = "Tự Động Vào Cổng", AutoStartPortalDesc = "Tự động tạo và tiến vào cổng.", AutoKillPortal = "Tự Động Diệt Trong Cổng", AutoKillPortalDesc = "Tự động tiêu diệt địch bên trong cổng.",
        AutoAllocate = "Tự Động Cộng Điểm", StatType = "Chọn Loại Thuộc Tính", StatAmount = "Số Điểm Cộng Mỗi Lần", EnableAutoStats = "Bật Tự Động Cộng Điểm",
        AutoSkills = "Hệ Thống Kỹ Năng Tự Động", EnableAutoSkill = "Bật Tự Động Dùng Kỹ Năng", EnableAutoSkillDesc = "Tự động tung kỹ năng khi đang chiến đấu.", SelectSkills = "Chọn Kỹ Năng",
        SkillSwitch = "Công Tắc Kỹ Năng", SkillSwitchDesc = "Bật/tắt kỹ năng đã chọn ở trên.",
        InstantTeleport = "Dịch Chuyển Tức Thời", SearchWorld = "Tìm Kiếm Mục Tiêu Thế Giới", SelectMap = "Chọn Bản Đồ Mục Tiêu", ActivateTeleport = "Kích Hoạt Dịch Chuyển",
        NPCTeleport = "Dịch Chuyển Đến NPC", SelectNPC = "Chọn NPC",
        LangInit = "Ngôn Ngữ & Khởi Tạo", LanguageSelect = "Chọn Ngôn Ngữ / Language / ภาษา", ReScript = "Tải Lại Cấu Trúc UI", ReScriptDesc = "Tải lại toàn bộ script mà không cần vào lại game.",
        MainConfig = "Cấu Hình Chính", SaveConfig = "Lưu Cấu Hình Ngay", ResetSettings = "Đặt Lại Tất Cả", 
        PerfApp = "Hiệu Suất & Giao Diện", SelectGuiTheme = "Chọn Chủ Đề GUI", AntiAfk = "Bảo Mật Chống AFK", AntiAfkDesc = "Tránh bị kick do không hoạt động.", LowLag = "Chế Độ Giảm Lag", LowLagDesc = "Xóa texture/đổ bóng để tăng FPS",
        AfkSystem = "Hệ Thống AFK", BlackScreen = "Màn Hình Đen", BlackScreenDesc = "Làm đen màn hình để tiết kiệm tài nguyên.",
        LangChangedNotif = "Đã đổi ngôn ngữ. Vui lòng nhấn Re-Script.", LangTitle = "Cập Nhật Ngôn Ngữ", ReloadNotif = "Tải lại script thành công!"
    }
}

-- ==========================================
-- CORE CONFIG FUNCTIONS
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
    "Arrancar [Lv.2500]", "Ichigo ( Bankai ) [Lv.4000]", "Mahito [Lv.4000]"
}

local QuestIDs = {
    ["Bandit"] = 1, ["Bandit Leader"] = 2, ["Monkey"] = 3, ["Shank"] = 4,
    ["Snow Bandit"] = 8, ["Mihawk"] = 7, ["National Level Hunter"] = 9,
    ["Sorcerer Student"] = 5, ["Miwa"] = 6, ["Hollow"] = 10,
    ["Arrancar"] = 11, ["Sung Jinwoo"] = 13, ["Ichigo ( Bankai )"] = 12,
    ["Mahito"] = 13
}

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
        ["Gilgamesh"] = true,
        ["Sukuna Shinjuku"] = true,
        ["Gojo Shinjuku"] = true
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

local function summonBoss(bossName)
    pcall(function()
        local args = { "Summon", { Boss = bossName } }
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
        local rs = game:GetService("ReplicatedStorage")
        local sEvent = rs:FindFirstChild("SummonEvent", true) or rs:FindFirstChild("RE/SummonEvent", true)
        if sEvent then sEvent:FireServer(unpack(args)) end
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
                    if current then return tonumber(current) end
                end
            end
        end
    end
    return 0
end

local function isInDungeon()
    local mapFolder = workspace:FindFirstChild("Map")
    if mapFolder then
        if mapFolder:FindFirstChild("CASTLE") or mapFolder:FindFirstChild("RAIDEN") then return true end
    end
    return false
end

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

local function findTarget(currentTarget)
    local currentPity = getCurrentPity()
    local isPitySystemActive = Config.AutoPitySystem
    if isInDungeon() then isPitySystemActive = false end
    local isPityNotReady = (isPitySystemActive and currentPity < Config.PityTargetValue)
    local isInternalKillPortalEnabled = Config.AutoStartGameInPortal
    
    if isPityNotReady then isInternalKillPortalEnabled = false end

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
        if vHero then return vHero, false, 1 else return nil, false, 1 end
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
                if sInner and isAlive(sInner) then return sInner, false, 1
                elseif isAlive(stone1) then return stone1, false, 1 end
            end
        end
    end

    if Config.PriorityBossEnabled then
        local priorityList = {"Sung Jinwoo", "Rimuru"}
        if Config.SelectedPriorityBoss ~= "None" then table.insert(priorityList, 1, Config.SelectedPriorityBoss) end
        for _, bossName in ipairs(priorityList) do
            local boss = checkSpecificBossExists(bossName)
            if boss then return boss, false, 2 end
        end
    end
    
    if Config.AutoFarmBossAll then
        local bossFolder = workspace:FindFirstChild("Boss")
        if bossFolder then
            if currentTarget and isAlive(currentTarget) and currentTarget:IsDescendantOf(bossFolder) then
                return currentTarget, false, 2
            end
            for _, v in ipairs(bossFolder:GetChildren()) do
                if isAlive(v) then return v, false, 2 end
                for _, sub in ipairs(v:GetChildren()) do
                    if isAlive(sub) then return sub, false, 2 end
                end
            end
        end
        return nil, false, 2
    end

    if Config.AutoGodSummonEnabled then
        local godBoss = checkSpecificBossExists(Config.SelectedGodBoss)
        if godBoss then
            return godBoss, false, 2
        end
        return nil, false, 3
    end

    if Config.AutoAizenEnabled then
        local aizen = checkSpecificBossExists("Aizen")
        if aizen then return aizen, false, 3 end
        if currentTarget and currentTarget.Name == "Hollow" and isAlive(currentTarget) then return currentTarget, true, 3 end
        local hollow = getEntityInFolders("Hollow")
        if hollow then return hollow, true, 3 end
        return nil, false, 3
    end

    if Config.BattleBossEnabled and Config.SelectedBattleBoss ~= "None" then
        local boss = checkSpecificBossExists(Config.SelectedBattleBoss)
        if boss then return boss, false, 4 end
        return nil, false, 4
    end
    
    if Config.SummonBossEnabled and Config.SelectedSummonBoss ~= "None" then
        local boss = checkSpecificBossExists(Config.SelectedSummonBoss)
        if boss then return boss, false, 4 end
        return nil, false, 4
    end

    if (Config.FarmEnabled or Config.AutoFarmNoQuest) and Config.TargetMonster ~= "None" then
        local cleanName = getCleanName(Config.TargetMonster)
        if currentTarget and currentTarget.Name == cleanName and isAlive(currentTarget) then return currentTarget, true, 4 end
        if cleanName == "Ichigo ( Bankai )" then
            local ichigoFolder = workspace:FindFirstChild("Enemies") and workspace.Enemies:FindFirstChild("Ichigo ( Bankai )")
            if ichigoFolder then
                for _, v in ipairs(ichigoFolder:GetChildren()) do
                     if v.Name == "Ichigo ( Bankai )" and isAlive(v) then return v, true, 4 end
                end
            end
        end
        local target = getEntityInFolders(cleanName)
        if target then return target, true, 4 end
    end
    return nil, false, 4
end

local function SmoothTeleport(targetCFrame)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    local speed = 730
    local tTime = dist / speed
    
    if TeleportTween then
        TeleportTween:Cancel()
    end
    
    local tweenInfo = TweenInfo.new(tTime, Enum.EasingStyle.Linear)
    TeleportTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    TeleportTween:Play()
    TeleportTween.Completed:Wait()
end

-- ==========================================
-- MAIN UI CONSTRUCTION & SESSION ENVIRONMENT
-- ==========================================
local function StartHub(isReload)
    -- 1. Full Cleanup Phase
    if _G.ZenithSoulCleanup then
        pcall(_G.ZenithSoulCleanup)
        task.wait(0.3)
    end

    -- 2. Setup New Session Token
    local currentSessionToken = math.random()
    _G.ZenithCurrentSession = currentSessionToken
    local currentConnections = {}

    local function registerConnection(conn)
        table.insert(currentConnections, conn)
        return conn
    end

    CurrentFarmTarget = nil
    IsFarmingActive = false
    IsSwitchingTarget = false
    LastSafePosition = nil

    LoadConfig()
    
    local lang = Config.SelectedLanguage or "English"
    local t = Translations[lang] or Translations["English"]

    local BlackScreenGui
    local ToggleGui

    -- 3. Construct GUI Window
    local ThemeMap = {
        Dark = "Slate", Light = "Cloud", Amethyst = "Lavender", Aqua = "SoftGreen",
        Slate = "Slate", Cloud = "Cloud", DarkGray = "DarkGray", SoftGreen = "SoftGreen", Lavender = "Lavender"
    }
    local SelectedSolarTheme = ThemeMap[Config.SelectedTheme] or "Slate"

    local Window = Solar.CreateWindow({
        Title = t.Welcome,
        Subtitle = t.Subtitle,
        Theme = SelectedSolarTheme
    })

    local HubTabs = {
        Home     = Window.AddTab(t.MainTab, "Hostel"),
        Menu     = Window.AddTab(t.MenuTab, "Hostel"),
        Set      = Window.AddTab(t.SetTab, "Hostel"),
        Farm     = Window.AddTab(t.FarmTab, "Farm"),
        Boss     = Window.AddTab(t.BossTab, "Boss"),
        BossSummon = Window.AddTab(t.BossSummonTab, "Boss"),
        Dungeon  = Window.AddTab(t.DungeonTab, "Dungeon"),
        Portal   = Window.AddTab(t.PortalTab, "Dungeon"),
        Stats    = Window.AddTab(t.StatsTab, "Upgrade stats"),
        Teleport = Window.AddTab(t.TeleportTab, "Upgrade stats"),
        Settings = Window.AddTab(t.SettingsTab, "Setting"),
        Appearance = Window.AddTab(t.AppearanceTab, "Setting")
    }

    -- ------------------------------------------
    -- TAB: HOME
    -- ------------------------------------------
    HubTabs.Home:AddSection(t.Welcome)
    HubTabs.Home:AddLabel(t.Desc)
    HubTabs.Home:AddStatus(t.PlayerName, LocalPlayer.Name)
    HubTabs.Home:AddSection(t.DiscordSection)
    HubTabs.Home:AddLabel(t.DiscordDesc)
    HubTabs.Home:AddButton(t.DiscordLink, function()
        pcall(function() setclipboard("https://discord.gg/sWZYarcbx6") end)
        Window.Notify({
            Title = t.DiscordSection,
            Description = t.DiscordCopied,
            Duration = 4
        })
    end)


    -- ------------------------------------------
    -- TAB: MENU (navigation info + re-script)
    -- ------------------------------------------
    HubTabs.Menu:AddSection(t.MenuTab)
    HubTabs.Menu:AddLabel(t.MenuDesc)

    HubTabs.Menu:AddSection(t.LangInit)
    HubTabs.Menu:AddLabel(t.ReScriptDesc)
    HubTabs.Menu:AddButton(t.ReScript, function()
        task.spawn(function()
            StartHub(true)
        end)
    end)


    -- ------------------------------------------
    -- TAB: SET (general settings - equip & position only)
    -- ------------------------------------------
    HubTabs.Set:AddSection(t.CombatSetup)
    HubTabs.Set:AddDropdown(t.SelectWeapon, nil, getWeaponList(), Config.SelectedWeapon, function(Value) Config.SelectedWeapon = Value end)
    HubTabs.Set:AddToggle(t.AutoEquip, t.AutoEquipDesc, Config.AutoEquip, function(Value) Config.AutoEquip = Value end)
    HubTabs.Set:AddButton(t.RefreshWeapons, function() end)

    HubTabs.Set:AddSection(t.PositionSettings)
    HubTabs.Set:AddDropdown(t.AttackAngle, nil, { "Behind", "Above", "Below" }, Config.FarmAngle, function(Value) Config.FarmAngle = Value end)
    HubTabs.Set:AddInput(t.DistanceOffset, tostring(Config.DistanceBehind), function(Value) Config.DistanceBehind = tonumber(Value) or 7.5 end)

    -- ------------------------------------------
    -- TAB: FARM (Auto Farm main toggle + farm config)
    -- ------------------------------------------
    HubTabs.Farm:AddSection(t.FarmingSystems)
    HubTabs.Farm:AddDropdown(t.SelectMonster, nil, StaticMonsterList, Config.TargetMonster, function(Value) Config.TargetMonster = Value end)
    HubTabs.Farm:AddToggle(t.AutoFarm, t.AutoFarmDesc, Config.FarmEnabled, function(Value) Config.FarmEnabled = Value end)
    HubTabs.Farm:AddToggle(t.AutoFarmNoQuest, t.AutoFarmNoQuestDesc, Config.AutoFarmNoQuest, function(Value) Config.AutoFarmNoQuest = Value end)

    HubTabs.Farm:AddSection(t.SpecialTargets)
    HubTabs.Farm:AddToggle(t.KillStone, t.KillStoneDesc, Config.AutoStoneEnabled, function(Value) Config.AutoStoneEnabled = Value end)
    HubTabs.Farm:AddToggle(t.FarmAllBoss, t.FarmAllBossDesc, Config.AutoFarmBossAll, function(Value) Config.AutoFarmBossAll = Value end)


    -- ------------------------------------------
    -- TAB: BOSS (Boss spawn only)
    -- ------------------------------------------
    HubTabs.Boss:AddSection(t.BossFarming)
    HubTabs.Boss:AddDropdown(t.SelectBattleBoss, nil, { "Verdant Hero", "Saber" }, Config.SelectedBattleBoss, function(Value) Config.SelectedBattleBoss = Value end)
    HubTabs.Boss:AddToggle(t.AutoBoss, nil, Config.BattleBossEnabled, function(Value) Config.BattleBossEnabled = Value end)
    HubTabs.Boss:AddDropdown(t.PriorityTargets, nil, { "Sung Jinwoo", "Rimuru" }, Config.SelectedPriorityBoss, function(Value) Config.SelectedPriorityBoss = Value end)
    HubTabs.Boss:AddToggle(t.AutoFarmBoss, nil, Config.PriorityBossEnabled, function(Value) Config.PriorityBossEnabled = Value end)

    -- ------------------------------------------
    -- TAB: BOSS SUMMON (Summon / Pity systems)
    -- ------------------------------------------
    HubTabs.BossSummon:AddSection(t.BossSummoning)
    HubTabs.BossSummon:AddDropdown(t.SelectSummon, nil, { "Sukuna", "Gojo" }, Config.SelectedSummonBoss, function(Value) Config.SelectedSummonBoss = Value end)
    HubTabs.BossSummon:AddToggle(t.AutoSummon, t.AutoSummonDesc, Config.SummonBossEnabled, function(Value) Config.SummonBossEnabled = Value end)

    HubTabs.BossSummon:AddSection(t.GodSummoning)
    HubTabs.BossSummon:AddDropdown(t.SelectTargetBoss, nil, { "Gilgamesh", "Sukuna Shinjuku", "Gojo Shinjuku" }, Config.SelectedGodBoss, function(Value) Config.SelectedGodBoss = Value end)
    HubTabs.BossSummon:AddDropdown(t.SelectDifficulty, nil, { "Easy", "Medium", "Hard", "Extreme" }, Config.SelectedGodDifficulty, function(Value) Config.SelectedGodDifficulty = Value end)
    HubTabs.BossSummon:AddToggle(t.AutoSummonFarm, t.AutoSummonFarmDesc, Config.AutoGodSummonEnabled, function(Value) Config.AutoGodSummonEnabled = Value end)

    HubTabs.BossSummon:AddSection(t.SpecialEvents)
    HubTabs.BossSummon:AddToggle(t.FarmAizen, t.FarmAizenDesc, Config.AutoAizenEnabled, function(Value)
        Config.AutoAizenEnabled = Value
        if Value then
            Config.AutoStartPortal = false
            Config.AutoStartGameInPortal = false
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
    end)
    HubTabs.BossSummon:AddToggle(t.SummonJinwooV2, nil, Config.SummonJinwooV2Enabled, function(Value) Config.SummonJinwooV2Enabled = Value if Value then LastJinwooV2SummonTime = 0 end end)

    HubTabs.BossSummon:AddSection(t.AutoPitySystem)
    HubTabs.BossSummon:AddToggle(t.EnablePity, t.EnablePityDesc, Config.AutoPitySystem, function(Value) Config.AutoPitySystem = Value end)
    HubTabs.BossSummon:AddInput(t.PityTarget, tostring(Config.PityTargetValue), function(Value) Config.PityTargetValue = tonumber(Value) or 24 end)
    HubTabs.BossSummon:AddToggle(t.SummonRimuru, nil, Config.SummonRimuruEnabled, function(Value) Config.SummonRimuruEnabled = Value if Value then LastRimuruSummonTime = 0 end end)


    -- ------------------------------------------
    -- TAB: DUNGEON
    -- ------------------------------------------
    HubTabs.Dungeon:AddSection(t.TowerSystems)
    HubTabs.Dungeon:AddToggle(t.AutoTower, t.AutoTowerDesc, Config.AutoKillTower, function(Value) Config.AutoKillTower = Value end)

    -- ------------------------------------------
    -- TAB: PORTAL (separated from Dungeon)
    -- ------------------------------------------
    HubTabs.Portal:AddSection(t.PortalSystems)
    HubTabs.Portal:AddDropdown("Portal", nil, { "SHADOW", "RAIDEN", "ARTIFACT_01", "ARTIFACT_02", "ARTIFACT_03", "SUNG" }, Config.SelectedPortalName, function(Value) Config.SelectedPortalName = Value end)
    HubTabs.Portal:AddDropdown(t.PortalLevel, nil, { "Easy", "Medium", "Hard", "Extreme" }, Config.SelectedPortalDifficulty, function(Value) Config.SelectedPortalDifficulty = Value end)

    HubTabs.Portal:AddToggle(t.AutoStartPortal, t.AutoStartPortalDesc, Config.AutoStartPortal, function(Value)
        Config.AutoStartPortal = Value
        if Value then Config.AutoAizenEnabled = false end
    end)

    HubTabs.Portal:AddToggle(t.AutoKillPortal, t.AutoKillPortalDesc, Config.AutoStartGameInPortal, function(Value)
        Config.AutoStartGameInPortal = Value
        if Value then Config.AutoAizenEnabled = false end
    end)

    -- ------------------------------------------
    -- TAB: STATS (Upgrade stats category)
    -- ------------------------------------------
    HubTabs.Stats:AddSection(t.AutoAllocate)
    HubTabs.Stats:AddDropdown(t.StatType, nil, { "Strength", "Defense", "Weapon", "Power" }, Config.SelectedStat, function(Value) Config.SelectedStat = Value end)
    HubTabs.Stats:AddInput(t.StatAmount, tostring(Config.StatsAmount), function(Value) Config.StatsAmount = tonumber(Value) or 1 end)
    HubTabs.Stats:AddToggle(t.EnableAutoStats, nil, Config.AutoStatsEnabled, function(Value) Config.AutoStatsEnabled = Value end)

    HubTabs.Stats:AddSection(t.AutoSkills)
    HubTabs.Stats:AddToggle(t.EnableAutoSkill, t.EnableAutoSkillDesc, Config.AutoSkillEnabled, function(Value) Config.AutoSkillEnabled = Value end)
    local SkillKeys = {"Z", "X", "C", "V", "F", "R"}
    local SelectedSkillKey = SkillKeys[1]
    HubTabs.Stats:AddDropdown(t.SelectSkills, nil, SkillKeys, SelectedSkillKey, function(Value)
        SelectedSkillKey = Value
    end)
    HubTabs.Stats:AddToggle(t.SkillSwitch, t.SkillSwitchDesc, (Config.SelectedSkills and Config.SelectedSkills[SelectedSkillKey] == true), function(Value)
        Config.SelectedSkills = Config.SelectedSkills or {}
        Config.SelectedSkills[SelectedSkillKey] = Value
    end)

    -- ------------------------------------------
    -- TAB: TELEPORT
    -- ------------------------------------------
    local function getNPCList()
        local list = {}
        local npcFolder = workspace:FindFirstChild("NPC")
        if npcFolder then
            for _, v in ipairs(npcFolder:GetChildren()) do
                table.insert(list, v.Name)
            end
        end
        if #list == 0 then table.insert(list, "None") end
        return list
    end

    HubTabs.Teleport:AddSection(t.InstantTeleport)
    HubTabs.Teleport:AddInput(t.SearchWorld, "", function(Value) Config.SearchTeleportName = Value:lower() end)
    HubTabs.Teleport:AddDropdown(t.SelectMap, nil, StaticMonsterList, Config.SelectedTeleportTarget, function(Value) Config.SelectedTeleportTarget = Value end)
    HubTabs.Teleport:AddButton(t.ActivateTeleport, function()
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
    end)

    HubTabs.Teleport:AddSection(t.NPCTeleport)
    HubTabs.Teleport:AddDropdown(t.SelectNPC, nil, getNPCList(), Config.SelectedNPCTarget or "None", function(Value) Config.SelectedNPCTarget = Value end)
    HubTabs.Teleport:AddButton(t.ActivateTeleport, function()
        local npcFolder = workspace:FindFirstChild("NPC")
        local targetName = Config.SelectedNPCTarget
        if npcFolder and targetName and targetName ~= "None" then
            local npcModel = npcFolder:FindFirstChild(targetName, true)
            local hrp = npcModel and (npcModel:FindFirstChild("HumanoidRootPart", true) or (npcModel:IsA("BasePart") and npcModel))
            if hrp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame
            end
        end
    end)

    -- ------------------------------------------
    -- TAB: SETTINGS
    -- ------------------------------------------
    HubTabs.Settings:AddSection(t.LangInit)
    HubTabs.Settings:AddDropdown(t.LanguageSelect, nil, { "English", "Thai", "Vietnamese" }, Config.SelectedLanguage, function(Value)
        if Config.SelectedLanguage ~= Value then
            Config.SelectedLanguage = Value
            SaveConfig()
            local currentT = Translations[Value] or Translations["English"]
            Window.Notify({
                Title = currentT.LangTitle,
                Description = currentT.LangChangedNotif,
                Duration = 6
            })
        end
    end)

    HubTabs.Settings:AddSection(t.MainConfig)
    HubTabs.Settings:AddButton(t.SaveConfig, function() SaveConfig() end)
    HubTabs.Settings:AddButton(t.ResetSettings, function() ResetEverything() end)

    HubTabs.Settings:AddSection(t.PerfApp)
    HubTabs.Settings:AddToggle(t.AntiAfk, t.AntiAfkDesc, Config.AntiAFKEnabled, function(Value) Config.AntiAFKEnabled = Value end)
    HubTabs.Settings:AddToggle(t.LowLag, t.LowLagDesc, Config.LowLagMode, function(Value) Config.LowLagMode = Value UpdateLowLag() end)

    HubTabs.Settings:AddSection(t.AfkSystem)
    HubTabs.Settings:AddToggle(t.BlackScreen, t.BlackScreenDesc, Config.BlackScreenEnabled, function(Value)
        Config.BlackScreenEnabled = Value
        if BlackScreenGui then BlackScreenGui.Enabled = Value end
    end)

    -- ------------------------------------------
    -- TAB: APPEARANCE / ปรับสี (Theme + Save/Delete script)
    -- ------------------------------------------
    HubTabs.Appearance:AddSection(t.PerfApp)
    HubTabs.Appearance:AddDropdown(t.SelectGuiTheme, nil, { "Slate", "Cloud", "DarkGray", "SoftGreen", "Lavender" }, SelectedSolarTheme, function(Value)
        Config.SelectedTheme = Value
        SaveConfig()
        pcall(function() Window.SetTheme(Value) end)
    end)

    HubTabs.Appearance:AddSection(t.MainConfig)
    HubTabs.Appearance:AddButton(t.SaveConfig, function() SaveConfig() end)
    HubTabs.Appearance:AddButton(t.ResetSettings, function() ResetEverything() end)
    HubTabs.Appearance:AddButton(t.RemoveScript, function()
        if _G.ZenithSoulCleanup then pcall(_G.ZenithSoulCleanup) end
    end)

    -- ------------------------------------------
    -- COLLAPSE ALL SIDEBAR CATEGORIES (รอ Solar render เสร็จก่อน แล้วปิดทุก category)
    -- ------------------------------------------
    task.spawn(function()
        -- รอให้ Solar Engine สร้าง GUI เสร็จ
        local navScroll = nil
        for _ = 1, 30 do
            task.wait(0.2)
            pcall(function()
                local coreGui = game:GetService("CoreGui")
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                local solarGui = (coreGui and coreGui:FindFirstChild("ZenithSoul_Engine")) or (playerGui and playerGui:FindFirstChild("ZenithSoul_Engine"))
                if solarGui then
                    local mainFrame = solarGui:FindFirstChild("Main")
                    local sidebar = mainFrame and mainFrame:FindFirstChild("Sidebar")
                    local scroll = sidebar and sidebar:FindFirstChildOfClass("ScrollingFrame")
                    if scroll and #scroll:GetChildren() > 0 then
                        navScroll = scroll
                    end
                end
            end)
            if navScroll then break end
        end

        if not navScroll then return end
        task.wait(0.3)

        -- ปิดทุก category: กด TextButton ที่เป็น header ของ Solar sidebar
        -- Solar ใช้ TextButton ตัวใหญ่เป็น category header แล้วมี list ของ tab อยู่ข้างใน frame
        for _, child in ipairs(navScroll:GetChildren()) do
            -- category container มักเป็น Frame ที่มี TextButton header อยู่ข้างใน
            if child:IsA("Frame") then
                local header = child:FindFirstChildOfClass("TextButton")
                if header then
                    -- ถ้า expanded (frame ลูกที่ไม่ใช่ header visible อยู่) ให้ collapse
                    local expanded = false
                    for _, sub in ipairs(child:GetChildren()) do
                        if sub:IsA("Frame") and sub.Visible then
                            expanded = true
                            break
                        end
                    end
                    if expanded then
                        pcall(function() header:Activate() end)
                        task.wait(0.05)
                    end
                end
            elseif child:IsA("TextButton") then
                -- Solar บาง version ใช้ TextButton โดยตรงเป็น header
                pcall(function() child:Activate() end)
                task.wait(0.05)
            end
        end
    end)


    -- ------------------------------------------
    -- BLACK SCREEN SYSTEM SETUP
    -- ------------------------------------------
    local SafeParent = LocalPlayer:FindFirstChild("PlayerGui")
    pcall(function() if game:GetService("CoreGui") then SafeParent = game:GetService("CoreGui") end end)

    BlackScreenGui = Instance.new("ScreenGui")
    BlackScreenGui.Name = "ZenithBlackScreen"
    BlackScreenGui.IgnoreGuiInset = true
    BlackScreenGui.ResetOnSpawn = false
    BlackScreenGui.Parent = SafeParent

    local BlackFrame = Instance.new("Frame", BlackScreenGui)
    BlackFrame.Size = UDim2.new(1, 0, 1, 0)
    BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

    local CloseBSBtn = Instance.new("TextButton", BlackFrame)
    CloseBSBtn.Size = UDim2.new(0, 200, 0, 50)
    CloseBSBtn.Position = UDim2.new(0.5, -100, 0.1, 0)
    CloseBSBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    CloseBSBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBSBtn.Text = t.BlackScreen .. " (Close)"
    CloseBSBtn.Font = Enum.Font.GothamBold
    CloseBSBtn.TextSize = 14
    local UICornerBS = Instance.new("UICorner", CloseBSBtn)
    UICornerBS.CornerRadius = UDim.new(0, 8)

    BlackScreenGui.Enabled = Config.BlackScreenEnabled

    CloseBSBtn.MouseButton1Click:Connect(function()
        Config.BlackScreenEnabled = false
        BlackScreenGui.Enabled = false
    end)

    -- ------------------------------------------
    -- UTILITY BACKGROUND LOOPS (Tied to Session)
    -- ------------------------------------------
    task.spawn(function()
        local LastSavedConfig = HttpService:JSONEncode(Config)
        while _G.ZenithCurrentSession == currentSessionToken and task.wait(5) do
            local currentConfigStr = HttpService:JSONEncode(Config)
            if currentConfigStr ~= LastSavedConfig then
                SaveConfig()
                LastSavedConfig = currentConfigStr
            end
        end
    end)

    local VirtualUser = game:GetService("VirtualUser")
    local idledConn = LocalPlayer.Idled:Connect(function()
        if Config.AntiAFKEnabled then
            pcall(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        end
    end)
    registerConnection(idledConn)

    task.spawn(function()
        while _G.ZenithCurrentSession == currentSessionToken and task.wait(0.8) do
            if Config.AutoStatsEnabled then pcall(function() allocateStat(Config.SelectedStat, Config.StatsAmount) end) end
        end
    end)

    task.spawn(function()
        while _G.ZenithCurrentSession == currentSessionToken and task.wait(1.5) do
            if Config.AutoKillTower then
                 pcall(function()
                      game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/TowerEvent"):FireServer("Play")
                end)
                 pcall(function()
                      game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/TowerEvent"):FireServer("Start")
                end)
            end
        end
    end)

    task.spawn(function()
        while _G.ZenithCurrentSession == currentSessionToken and task.wait(2.0) do
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    local portalGui = playerGui:FindFirstChild("PortalGui")
                    local screenGui = playerGui:FindFirstChild("ScreenGui")
                    
                    local shouldLeave = false
                    
                    if portalGui then
                        local finish = portalGui:FindFirstChild("Finish")
                        local result = portalGui:FindFirstChild("Result")
                        local gameover = portalGui:FindFirstChild("GameOver")
                        local leaveCanvas = portalGui:FindFirstChild("LeaveCanvas")
                        
                        if (finish and finish.Visible) or (result and result.Visible) or (gameover and gameover.Visible) then
                            shouldLeave = true
                        elseif leaveCanvas and leaveCanvas.Visible then
                            shouldLeave = true
                        end
                    end
                    
                    if screenGui and not shouldLeave then
                        local finish = screenGui:FindFirstChild("Finish")
                        local result = screenGui:FindFirstChild("Result")
                        local gameover = screenGui:FindFirstChild("GameOver")
                        
                        if (finish and finish.Visible) or (result and result.Visible) or (gameover and gameover.Visible) then
                            shouldLeave = true
                        end
                    end
                    
                    if shouldLeave then
                        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/PortalEvent"):FireServer("Lobby")
                        task.wait(1.0)
                    end
                end
            end)

            local allowPortalRun = Config.AutoStartPortal
            local currentPity = getCurrentPity()
            
            if Config.AutoPitySystem and not isInDungeon() then
                if currentPity >= Config.PityTargetValue then
                    if not PityReachedTime then PityReachedTime = tick() end
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
                if isInDungeon() then allowPortalRun = false end
            end

            if allowPortalRun and not isInDungeon() then
                pcall(function()
                    local keyToUse = "Cid's Key"
                    if Config.SelectedPortalName == "SHADOW" then keyToUse = "Cid's Key"
                    elseif Config.SelectedPortalName == "RAIDEN" then keyToUse = "Shrine Key"
                    elseif Config.SelectedPortalName == "ARTIFACT_01" then keyToUse = "Trial's Key"
                    elseif Config.SelectedPortalName == "ARTIFACT_02" then keyToUse = "Trial's Key"
                    elseif Config.SelectedPortalName == "ARTIFACT_03" then keyToUse = "Trial's Key"
                    elseif Config.SelectedPortalName == "SUNG" then keyToUse = "Cartenon Key" end
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
                pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/PortalEvent"):FireServer("Start") end)
            end
        end
    end)

    task.spawn(function()
        while _G.ZenithCurrentSession == currentSessionToken and task.wait(0.1) do 
            local blockOtherSummons = false
            if isInDungeon() then continue end

            if Config.AutoPitySystem and not isInDungeon() then
                local currentPity = getCurrentPity()
                if currentPity >= Config.PityTargetValue then
                    if not PityReachedTime then PityReachedTime = tick() end
                    blockOtherSummons = false
                else
                    PityReachedTime = nil 
                    blockOtherSummons = true 
                    if not checkSpecificBossExists("Verdant Hero") then
                        if (tick() - LastPitySummonTime) >= 0.5 then
                            summonBoss("Verdant Hero")
                            LastPitySummonTime = tick()
                        end
                    end
                end
            end

            if not blockOtherSummons and not isInDungeon() then
                if Config.AutoGodSummonEnabled then
                    if not checkSpecificBossExists(Config.SelectedGodBoss) then
                        if (tick() - LastGodSummonTime) >= 20 then
                            pcall(function()
                                local isShinjuku = (Config.SelectedGodBoss == "Sukuna Shinjuku" or Config.SelectedGodBoss == "Gojo Shinjuku")
                                local summonAction = isShinjuku and "AutoSummon" or "Summon"
                                local args = { summonAction, { Difficult = Config.SelectedGodDifficulty, Boss = Config.SelectedGodBoss } }
                                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/SummonEvent"):FireServer(unpack(args))
                            end)
                            LastGodSummonTime = tick()
                        end
                    end
                end

                if Config.SummonBossEnabled and not checkSpecificBossExists(Config.SelectedSummonBoss) then 
                    if (tick() - LastSummonBossTime) >= 1.0 then 
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
                
                -- โค้ดส่วนเสกซงจินวู v2 ทุกๆ 1.3 นาที
                if Config.SummonJinwooV2Enabled then
                    if (tick() - LastJinwooV2SummonTime) >= 78 then -- 78 วินาที = 1.3 นาที
                        pcall(function()
                            local args = {
                                "SummonClone",
                                {}
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/MonarchCloneRE"):FireServer(unpack(args))
                        end)
                        LastJinwooV2SummonTime = tick()
                    end
                end

                AutoAizenSystem()
            end
        end
    end)

    task.spawn(function()
        local CurrentlyOn = {} 
        while _G.ZenithCurrentSession == currentSessionToken and task.wait(0.5) do
            local shouldUseSkill = false
            
            if Config.AutoSkillEnabled and IsFarmingActive then
                shouldUseSkill = true
                if Config.AutoPitySystem and not isInDungeon() then
                    local currentPity = getCurrentPity()
                    if currentPity < Config.PityTargetValue then
                        shouldUseSkill = false
                    elseif PityReachedTime and (tick() - PityReachedTime) < 6 then
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

    task.spawn(function()
        while _G.ZenithCurrentSession == currentSessionToken and task.wait(0.3) do 
            IsFarmingActive = (Config.FarmEnabled or Config.AutoFarmNoQuest or Config.SummonBossEnabled or Config.BattleBossEnabled or Config.PriorityBossEnabled or Config.AutoKillTower or Config.AutoStartGameInPortal or Config.AutoAizenEnabled or Config.AutoStoneEnabled or Config.AutoPitySystem or Config.AutoGodSummonEnabled or Config.AutoFarmBossAll)
            
            if IsFarmingActive and not IsSwitchingTarget then
                local bestTarget, isQuest, priorityLevel = findTarget(CurrentFarmTarget)

                if bestTarget == nil then
                    if CurrentFarmTarget ~= nil then
                        CurrentFarmTarget = nil
                        PendingBossTarget = nil
                    end
                    continue
                end

                if bestTarget ~= CurrentFarmTarget then
                    local waitDelay = 0.5 
                    if bestTarget and bestTarget:FindFirstChild("Humanoid") and bestTarget.Humanoid.MaxHealth >= 1000000 then waitDelay = 1.5 end
                     
                    if PendingBossTarget ~= bestTarget then
                        PendingBossTarget = bestTarget
                        BossDetectionTime = tick()
                    end

                    if (tick() - BossDetectionTime) < waitDelay then continue end
                    
                    IsSwitchingTarget = true
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        hrp.RotVelocity = Vector3.new(0, 0, 0)
                        if LastSafePosition then hrp.CFrame = LastSafePosition end
                    end
                    task.wait(0.1)

                    CurrentFarmTarget = bestTarget
                    PendingBossTarget = nil
                    IsSwitchingTarget = false
                    
                    if CurrentFarmTarget and isQuest then
                        if not Config.AutoFarmNoQuest then
                            local cleanName = getCleanName(CurrentFarmTarget.Name)
                            if cleanName ~= LastTargetQuest then
                                LastTargetQuest = cleanName
                                task.spawn(function() switchQuest(cleanName) end)
                            end
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

    local heartbeatConn = RunService.Heartbeat:Connect(function()
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
                    if LastSafePosition then hrp.CFrame = LastSafePosition end
                end
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)
    registerConnection(heartbeatConn)

    local steppedConn = RunService.Stepped:Connect(function()
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
    
    registerConnection(steppedConn)
    local charAddedConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(1.5)
        CurrentFarmTarget = nil
        LastSafePosition = nil
        PendingBossTarget = nil
        if Config.AutoEquip and Config.SelectedWeapon ~= "None" then
            task.wait(0.5)
            local tool = LocalPlayer.Backpack:FindFirstChild(Config.SelectedWeapon)
            local hum = newChar:FindFirstChildOfClass("Humanoid")
            if tool and hum and hum.Health > 0 then
                hum:EquipTool(tool)
            end
        end
    end)
    registerConnection(charAddedConn)

    task.spawn(function()
        while _G.ZenithCurrentSession == currentSessionToken and task.wait(0.15) do
            if IsFarmingActive and Config.SelectedWeapon ~= "None" and not IsSwitchingTarget then
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local tool = char:FindFirstChild(Config.SelectedWeapon) or LocalPlayer.Backpack:FindFirstChild(Config.SelectedWeapon)
                        if tool then
                            if Config.AutoEquip and tool.Parent ~= char then
                                hum:EquipTool(tool)
                            end
                            if tool.Parent == char and CurrentFarmTarget and isAlive(CurrentFarmTarget) then
                                tool:Activate()
                            end
                        end
                    end
                end
            end
        end
    end)
    
    if Config.LowLagMode then UpdateLowLag() end

    -- ------------------------------------------
    -- DRAGGABLE TOGGLE BUTTON SYSTEM
    -- ------------------------------------------
    ToggleGui = Instance.new("ScreenGui")
    local ToggleButton = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")

    ToggleGui.Name = "ZenithSoulToggle"
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

    local c1 = ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ToggleButton.Position
              
            input.Changed:Connect(function()
                 if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    registerConnection(c1)

    local c2 = ToggleButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    registerConnection(c2)

    local c3 = UserInputService.InputChanged:Connect(function(input)
         if input == dragInput and dragging then update(input) end
    end)
    registerConnection(c3)

    local c4 = ToggleButton.MouseButton1Click:Connect(function()
        local coreGui = game:GetService("CoreGui")
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local solarGui = (coreGui and coreGui:FindFirstChild("ZenithSoul_Engine")) or (playerGui and playerGui:FindFirstChild("ZenithSoul_Engine"))
        if solarGui then solarGui.Enabled = not solarGui.Enabled end
    end)
    registerConnection(c4)

    -- ------------------------------------------
    -- CLEANUP ENVIRONMENT REGISTRATION
    -- ------------------------------------------
    _G.ZenithSoulCleanup = function()
        _G.ZenithCurrentSession = nil 
        for _, conn in ipairs(currentConnections) do
            if conn and conn.Disconnect then pcall(function() conn:Disconnect() end) end
        end
        pcall(function()
            local coreGui = game:GetService("CoreGui")
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            local solarGui = (coreGui and coreGui:FindFirstChild("ZenithSoul_Engine")) or (playerGui and playerGui:FindFirstChild("ZenithSoul_Engine"))
            if solarGui then solarGui:Destroy() end
        end)
        if BlackScreenGui then pcall(function() BlackScreenGui:Destroy() end) end
        if ToggleGui then pcall(function() ToggleGui:Destroy() end) end
        if TeleportTween then TeleportTween:Cancel() end
    end

    if isReload then
        Window.Notify({
            Title = t.Welcome,
            Description = t.ReloadNotif,
            Duration = 5
        })
    end
end

StartHub(false)
