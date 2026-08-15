--[[
========================================================================
 Zentih UI Library — คู่มือการใช้งาน (ภาษาไทย)
========================================================================

นี่คือ "ไลบรารี" ไม่ใช่สคริปต์ที่รันแล้วมี GUI ขึ้นมาเลย ต้องดึงไปใช้ก่อน
แล้วค่อยเขียนสคริปต์ของตัวเองเรียกมันอีกที (ดูตัวอย่างเต็มใน ZentihExample.lua)

------------------------------------------------------------------------
1) วิธีโหลดไลบรารีเข้ามาใช้
------------------------------------------------------------------------

-- ก. ถ้ามี 2 ไฟล์อยู่ในโฟลเดอร์เดียวกัน (ง่ายสุด ใช้ได้กับทุก executor):
local Zentih = loadstring(readfile("ZentihLibrary.lua"))()

-- ข. ถ้าทำเป็น ModuleScript ใน Roblox Studio:
local Zentih = require(script.Parent.ZentihLibrary)

-- ค. ถ้าโหลดจากลิงก์ออนไลน์ (เช่น GitHub):
local Zentih = loadstring(game:HttpGet("ลิงก์ raw ของไฟล์นี้"))()

------------------------------------------------------------------------
2) สร้างหน้าต่างหลัก (Window) — ต้องทำก่อนเสมอ
------------------------------------------------------------------------

local Window = Zentih:CreateWindow({
    Title = "ชื่อสคริปต์ของคุณ",       -- ขึ้นมุมซ้ายบน
    Subtitle = "อะไรก็ได้ เช่น v1.0", -- ตัวเล็กใต้ชื่อ
    ConfigFolder = "MyScript",         -- ชื่อโฟลเดอร์เก็บไฟล์เซฟค่า
    ToggleIcon = "rbxassetid://123456", -- (ไม่ใส่ก็ได้) รูปในปุ่มลอยวงกลม
                                         -- ถ้าไม่ใส่ จะใช้ไอคอนตาที่วาดเองแทน
                                         -- ถ้าใส่ Asset ID ผิด/โหลดไม่ได้ จะ
                                         -- สลับกลับไปใช้ไอคอนตาให้อัตโนมัติ
})

พอสร้าง Window แล้ว จะมี "ปุ่มลอยวงกลม" โผล่ที่ขอบขวาจอให้อัตโนมัติ
กดปุ่มนั้นเพื่อซ่อน/เปิด GUI ทั้งหมด ลากปุ่มไปวางตรงไหนของจอก็ได้

ที่มุมซ้ายล่างของหน้าต่างหลัก มีจุดลาก (เส้นทแยงเล็กๆ) ให้ผู้เล่นกดค้าง
แล้วลากเพื่อ**ย่อ/ขยายขนาด GUI เองได้เลย** ไม่ต้องเขียนโค้ดเพิ่ม

------------------------------------------------------------------------
3) สร้างแท็บ (Tab) — 1 หน้าต่างมีได้หลายแท็บ
------------------------------------------------------------------------

local Main = Window:CreateTab({
    Name = "หน้าหลัก",   -- ชื่อโชว์ในแถบข้างซ้าย
    Icon = "home",       -- ไอคอนหน้าชื่อแท็บ มี 18 แบบให้เลือก:
                          -- home, sword, save, settings, input, dungeon,
                          -- status, eye, star, gamepad, macro, map, script,
                          -- config, debug, tower, enemy, wave
    Badge = "3",          -- (ไม่ใส่ก็ได้) ป้ายตัวเลขเล็กๆ ข้างชื่อแท็บ
})

จากนั้นเอา "Main" (ตัวแปรที่ได้จาก CreateTab) ไปใส่ปุ่ม/ช่องต่างๆ ต่อ

------------------------------------------------------------------------
4) ใส่ปุ่ม/ช่องต่างๆ เข้าไปในแท็บ — เรียกผ่านตัวแปร Tab (เช่น Main)
------------------------------------------------------------------------

-- หัวข้อ/ตัวอักษร (ไม่มีอะไรให้กด)
Main:CreateSection("หมวดหมู่นี้ชื่อ")
Main:CreateLabel("ข้อความสั้นๆ บรรทัดเดียว")
Main:CreateDivider()  -- เส้นคั่น
Main:CreateParagraph({ Title = "หัวข้อ", Content = "เนื้อหายาวๆ ตัดบรรทัดเอง" })

-- ปุ่มกด
Main:CreateButton({
    Title = "กดฉันสิ",
    Callback = function() print("โดนกดแล้ว") end,
})

-- สวิตช์เปิด/ปิด (true/false)
Main:CreateToggle({
    Title = "เปิด/ปิดอะไรสักอย่าง",
    Default = false,
    Flag = "MyToggle",              -- ตั้งชื่อไว้ = เซฟ/โหลดค่าได้ (ดูข้อ 6)
    Callback = function(state) print(state) end,
})

-- แถบเลื่อนเลือกตัวเลข
Main:CreateSlider({
    Title = "ความเร็ว",
    Min = 0, Max = 100, Default = 16,
    Flag = "SpeedSlider",
    Callback = function(value) print(value) end,
})

-- เลือก 1 อย่างจากลิสต์
Main:CreateDropdown({
    Title = "เลือกโหมด",
    Options = { "โหมด1", "โหมด2", "โหมด3" },
    Default = "โหมด1",
    Flag = "ModeSelect",
    Callback = function(picked) print(picked) end,
})

-- เลือกได้หลายอย่างจากลิสต์
Main:CreateMultiDropdown({
    Title = "เลือกได้หลายอัน",
    Options = { "A", "B", "C" },
    Default = { "A" },
    Callback = function(pickedList) print(#pickedList) end,
})

-- ช่องพิมพ์ข้อความ
Main:CreateInput({
    Title = "ใส่ชื่อ",
    Placeholder = "พิมพ์ตรงนี้...",
    Callback = function(text) print(text) end,
})

-- ปุ่มตั้งค่าคีย์ลัด (กดปุ่มแล้วกดคีย์บอร์ดเพื่อตั้งใหม่)
Main:CreateKeybind({
    Title = "คีย์เปิดเมนู",
    Default = Enum.KeyCode.RightShift,
    Callback = function(key) print(key) end,
})

-- เลือกสี
Main:CreateColorPicker({
    Title = "เลือกสี",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color) print(color) end,
})

-- แถบ progress (โชว์ค่า/max) — สั่งอัปเดตด้วย handle:Set(ตัวเลข)
local Bar = Main:CreateProgressBar({ Title = "ความคืบหน้า", Max = 100 })
Bar:Set(72)

-- ตัวเลขที่อัปเดตสดๆ (เช่น เงิน, kill count, สถานะบอส) — โชว์ +/- ตอนค่าเปลี่ยน
-- ออกแบบมาให้เรียก :Set() รัวๆ ได้ (เช่นทุกเฟรม หรือทุกครั้งที่ RemoteEvent
-- ยิงมา) โดยไม่มีวันทำให้สคริปต์คุณ error แม้ element จะถูกลบไปแล้วก็ตาม
local Kills = Main:CreateStat({ Title = "จำนวนคิล", Default = 0 })
Kills:Set(5)
print(Kills:Get())   -- อ่านค่าปัจจุบันกลับมาได้ด้วย

-- ตัวอย่างเอาไปต่อกับสถานะเกมจริงๆ (เช่นบอส/ด่าน ที่เปลี่ยนบ่อย):
local BossStatus = Main:CreateStat({ Title = "สถานะบอส", Default = "รอ..." })
game.ReplicatedStorage.BossStatusChanged.OnClientEvent:Connect(function(status)
    BossStatus:Set(status)  -- เรียกกี่ครั้งก็ได้ ปลอดภัยเสมอ
end)

------------------------------------------------------------------------
5) แจ้งเตือน / ป็อปอัพยืนยัน
------------------------------------------------------------------------

Window:Notify({ Title = "หัวข้อ", Content = "ข้อความ", Duration = 3 })

Window:CreatePopup({
    Title = "ยืนยันไหม?",
    Content = "กดยืนยันเพื่อดำเนินการต่อ",
    Buttons = {
        { Title = "ยกเลิก" },
        { Title = "ยืนยัน", Callback = function() print("ยืนยันแล้ว") end },
    },
})

------------------------------------------------------------------------
6) เซฟ/โหลดค่าที่ตั้งไว้ (ต้องใส่ Flag ให้ element นั้นๆ ก่อน — ดูข้อ 4)
------------------------------------------------------------------------

Window:SaveConfig("default")     -- เซฟทุกค่าที่มี Flag ไว้เป็นไฟล์ชื่อ default
Window:LoadConfig("default")     -- โหลดกลับมา
local v = Window:GetFlag("MyToggle")  -- ดึงค่าปัจจุบันของ Flag ตรงๆ

ตั้งชื่อไฟล์ (name) ต่างกันได้หลายไฟล์ เช่น SaveConfig("build1"),
SaveConfig("build2") — เก็บแยกกันได้ ไม่ทับกัน

------------------------------------------------------------------------
7) เปลี่ยนธีมสี ทั้ง GUI แบบสดๆ (ไม่ต้องรีสตาร์ทสคริปต์)
------------------------------------------------------------------------

Window:SetTheme("ชื่อธีม")

มี 4 ธีมให้เลือก:
  "Original"     -- ธีมต้นฉบับ (ฟ้าเข้ม เป็นค่าเริ่มต้น)
  "Black"        -- ดำสุด แทบไม่มีสีอื่นเลย
  "CrimsonNight" -- แดงเลือดหมูผสมดำ
  "OceanTeal"    -- ฟ้าอมเขียวผสมดำ โทนเย็น

ตัวอย่างทำเป็นเมนูให้ผู้เล่นเลือกเองได้:
Main:CreateDropdown({
    Title = "ธีมสี",
    Options = { "Original", "Black", "CrimsonNight", "OceanTeal" },
    Default = "Original",
    Callback = function(name) Window:SetTheme(name) end,
})

------------------------------------------------------------------------
8) ปรับความโปร่งใส (โปร่งใส/ทึบ ของตัว GUI เอง) แบบสดๆ
------------------------------------------------------------------------

Window:SetTransparency(windowAlpha, cardAlpha, panelAlpha)
-- ตัวเลข 0 = ทึบสุด, 1 = โปร่งใสหมด, ใส่ nil ตัวไหนไว้ = ไม่แตะค่านั้น
Window:SetTransparency(0.15, 0.06, 0)

------------------------------------------------------------------------
9) ระบบหลังบ้าน (Core Managers) — เก็บ/แชร์ค่าระหว่างส่วนต่างๆ ของสคริปต์
------------------------------------------------------------------------

-- State: เก็บค่าอะไรก็ได้ระหว่างการรัน แล้วให้ที่อื่น "subscribe" ฟังการ
-- เปลี่ยนแปลงได้ (ไม่ต้องเขียนระบบแจ้งเตือนเอง) ใช้ Window.State หรือ
-- Zentih.State (ตัวกลาง ใช้ร่วมกันได้ทั้งสคริปต์) ก็ได้
Window.State.Set("wave", 1)
Window.State.Increment("wave")            -- +1 อัตโนมัติ
print(Window.State.Get("wave", 0))        -- อ่านค่า (0 ถ้ายังไม่เคย Set)
Window.State.Subscribe("wave", function(new, old)
    print("wave เปลี่ยนจาก", old, "เป็น", new)
end)

-- Debug: console จริง มี 4 ระดับ (Info/Debug/Warning/Error)
Window.Debug.Info("บอทเริ่มทำงานแล้ว")
Window.Debug.Error("โหลดค่าไม่สำเร็จ:", errMsg)
print(Window.Debug.Export())              -- เอาทั้ง log ออกมาเป็น string เดียว

-- Performance: เช็คสถิติจริงของ GUI (ไม่ใช่เลขปลอม)
local stats = Window.Performance.GetStats()
print(stats.fps, stats.instances, stats.connections, stats.uptimeSeconds)

-- ErrorHandler: เรียกฟังก์ชันแบบป้องกัน error ไม่ให้พังทั้งสคริปต์
local ok, result = Window.ErrorHandler.Guard("MyFeature", function()
    return 1 / 0  -- ตัวอย่างโค้ดที่อาจพัง
end)

-- Input: ตั้งปุ่มลัด global แยกจาก Keybind element (เช่น ปุ่มเปิด/ปิด GUI)
Window.Input.Bind(Enum.KeyCode.RightShift, function()
    Window.Main.Visible = not Window.Main.Visible
end)

------------------------------------------------------------------------
10) Script State — เซฟ/โหลดสถานะเกมจริงลงไฟล์ (คนละอย่างกับ SaveConfig)
------------------------------------------------------------------------

-- SaveConfig/LoadConfig (ข้อ 6) เซฟแค่ค่าปุ่ม/toggle ที่ตั้ง Flag ไว้
-- ส่วน Script State เซฟข้อมูลเกมจริง (wave, coins, ด่านปัจจุบัน ฯลฯ) ที่
-- เก็บอยู่ใน Window.State — ต้องสร้างไฟล์ก่อนถึงจะเซฟได้

Window:CreateStateFile("save1")              -- ต้องสร้างก่อนเสมอ
Window:SaveState("save1")                     -- เซฟค่าปัจจุบันทั้งหมดใน Window.State
Window:LoadState("save1")                     -- โหลดกลับมา (กันโหลดซ้ำอัตโนมัติ)
Window:LoadStateOnce("save1")                 -- โหลดแค่ครั้งเดียวต่อเซสชัน เรียกกี่รอบก็ได้
Window:SetAutoLoad("save1", true)             -- ตั้งให้โหลดอัตโนมัติทุกครั้งที่เข้าเกม
Window:ApplyAutoLoads()                        -- เรียกครั้งเดียวตอนเริ่มสคริปต์ เพื่อให้ AutoLoad ทำงานจริง
Window:DeleteStateFile("save1")               -- ขึ้น popup ให้ยืนยันก่อนลบเสมอ
Window:ClearAllStateFiles()                    -- ลบทั้งหมด ก็ขึ้น popup ยืนยันเหมือนกัน
print(Window:ListStateFiles())                 -- ดูไฟล์ที่มีอยู่จริงบนดิสก์
print(Window:SearchStateFiles("save"))         -- ค้นหาไฟล์
local status = Window:GetStateFileStatus("save1")
print(status.exists, status.lastSave, status.lastLoad, status.autoLoad)

------------------------------------------------------------------------
11) Config เพิ่มเติม — Import/Export/Duplicate/Rename/Reset/AutoSave
------------------------------------------------------------------------

print(Window:ListConfigs())                    -- ดูไฟล์ config ที่มีอยู่จริง
Window:RenameConfig("old", "new")
Window:DuplicateConfig("default", "backup")
Window:ResetConfig("default")                  -- รีเซ็ตปุ่ม/toggle กลับค่าเริ่มต้น (element ไหนรีเซ็ตไม่ได้จะบอกตรงๆ)
local json = Window:ExportConfig("default")    -- เอาไปโชว์/copy ให้ผู้เล่นได้
Window:ImportConfig("imported", json, true)    -- โหลดกลับจาก JSON string
Window:AutoSaveConfig("default", 30)           -- เซฟอัตโนมัติทุก 30 วิ
Window:StopAutoSaveConfig()

------------------------------------------------------------------------
12) Game/Place Detector — รู้ว่ากำลังรันอยู่เกม/แมพไหน
------------------------------------------------------------------------

local info = Zentih.Game.GetInfo()
print(info.GameId, info.PlaceId, info.UniverseId, info.JobId, info.GameName)

-- ผูกโค้ดเฉพาะแมพ/เกม ไว้ล่วงหน้า แล้วให้โหลดเองอัตโนมัติถ้าตรงกับที่รันอยู่
Zentih.Game.RegisterGame(123456789, function()
    print("นี่คือแมพ/เกมที่ลงทะเบียนไว้ โหลดของเฉพาะแมพนี้ได้เลย")
end)
Zentih.Game.LoadForCurrentGame()               -- เรียกครั้งเดียวตอนเริ่ม จะรันของแมพที่ตรงให้เอง

------------------------------------------------------------------------
13) TD / Dungeon Backend — โครง generic ให้ต่อยอด (ไม่ใช่เกมสำเร็จรูป)
------------------------------------------------------------------------

-- Tower Defense: ลงทะเบียนทาวเวอร์/ศัตรู/แมพของคุณเอง Zentih แค่เก็บและ
-- จัดการสถานะ (wave, เงิน, เลือด) ให้ ไม่รู้จักเกมของคุณโดยตรง
Zentih.TD.RegisterTower("Archer", { Damage = 10, Range = 20, Cooldown = 1 })
Zentih.TD.PlaceTower("tower_001", "Archer", Vector3.new(0, 0, 0))
Zentih.TD.UpgradeTower("tower_001")
Zentih.TD.SellTower("tower_001")

-- เลือกเป้าหมายให้ทาวเวอร์ยิง (Nearest/Farthest/Strongest/Weakest/First/
-- Last/Boss/Custom) — ส่งลิสต์ศัตรูที่มี .Position กับ .Health เข้าไป
local target = Zentih.TD.SelectTarget("Nearest", towerPos, 20, enemyList)

Zentih.TD.StartWave()
Zentih.TD.AddCoins(100)
Zentih.TD.SpendCoins(50)
Zentih.TD.DamageBase(10)
print(Zentih.TD.GetWave(), Zentih.TD.GetCoins(), Zentih.TD.GetLives())
Zentih.TD.State.Subscribe("Wave", function(new, old) print("wave:", old, "->", new) end)

-- Dungeon: ห้อง/ด่าน/checkpoint แบบเดียวกัน
Zentih.Dungeon.RegisterDungeon("Cave1", { Rooms = 5, Boss = "CaveTroll" })
Zentih.Dungeon.Enter("Cave1")
Zentih.Dungeon.NextStage()
Zentih.Dungeon.SetCheckpoint({ room = 3 })

------------------------------------------------------------------------
14) Macro — บันทึก/เล่นซ้ำการกดปุ่ม (ทำท้ายสุด เสี่ยง error สูงสุด)
------------------------------------------------------------------------

-- บันทึกได้แค่ "กดปุ่มไหนตอนไหน" ไม่ใช่บันทึกทุกอย่างในเกม (Roblox ไม่มี
-- API แบบนั้น) ถ้าอยากบันทึกเหตุการณ์เกมด้วย ใช้ RecordCustomEvent คู่กัน
Zentih.Macro.Record("combo1")
Zentih.Macro.RecordCustomEvent("UseSkill", { skillId = 3 })  -- เรียกตอนกำลังอัดอยู่
Zentih.Macro.Stop()
Zentih.Macro.Play("combo1", {
    Speed = 1, Loop = false,
    OnKeyEvent = function(keyCode) print("จำลองกด", keyCode) end,
    OnCustomEvent = function(name, data) print("event:", name) end,
})
Zentih.Macro.Pause()
Zentih.Macro.Resume()
Zentih.Macro.SaveToFile("combo1", "MyScript/macros")
Zentih.Macro.LoadFromFile("combo1", "MyScript/macros")
Zentih.Macro.BindHotkey(Enum.KeyCode.F1, "Play", "combo1")

------------------------------------------------------------------------
15) Script Manager — ลงทะเบียน/รัน/หยุด สคริปต์ย่อยของคุณเอง
------------------------------------------------------------------------

Zentih.ScriptManager.Register("AutoFarm", function(stopSignal)
    while not stopSignal.Stopped do
        -- ทำงานฟาร์มของคุณที่นี่
        task.wait(1)
    end
end, "TD") -- หมวด: Universal, TD, Dungeon, Combat, Utility, Map

Zentih.ScriptManager.Execute("AutoFarm")
Zentih.ScriptManager.Stop("AutoFarm")
Zentih.ScriptManager.Restart("AutoFarm")
Zentih.ScriptManager.Disable("AutoFarm")
Zentih.ScriptManager.SetFavorite("AutoFarm", true)
print(Zentih.ScriptManager.Search("farm", "TD"))
print(Zentih.ScriptManager.IsRunning("AutoFarm"))

------------------------------------------------------------------------
16) ปิดโปรแกรม / ทำลาย GUI ทิ้งทั้งหมด
------------------------------------------------------------------------

Window:Destroy()   -- ปิด GUI และเลิกใช้ connection ทั้งหมดให้เรียบร้อย

------------------------------------------------------------------------
ข้อควรระวัง
------------------------------------------------------------------------

- ห้ามพิมพ์ตัวอักษรพิเศษ/สัญลักษณ์ (✓ ⚙ ▾ ✎ ฯลฯ) ใส่ใน Title/Text เอง —
  font ของ Roblox ไม่รองรับ จะกลายเป็นกล่องว่างหรือไม่ขึ้นเลย ใช้ตัวอักษร
  ปกติ (ก-ฮ, a-z, ตัวเลข) เท่านั้น
- ถ้ารันสคริปต์ตัวเองซ้ำหลายรอบ (เช่น ทดสอบไปเรื่อยๆ) ไม่ต้องกังวล —
  ไลบรารีจะเคลียร์ของรอบเก่าให้อัตโนมัติทุกครั้งที่เรียก CreateWindow ใหม่
- Dropdown/MultiDropdown/Combo Box/Color Picker ทุกตัว: กดเลือกก็ปิดเอง,
  เปลี่ยนแท็บก็ปิดเอง, เลื่อนหน้าก็ปิดเอง, และ**คลิกที่ไหนก็ได้นอกกรอบ
  popout ก็ปิดทันที** ไม่ต้องกลัวมันค้างบังจอ
- ResetConfig ไม่สามารถรีเซ็ตทุก element กลับ default ได้ 100% เสมอไป —
  จะรายงานตามจริงว่า element ไหนรีเซ็ตได้/ไม่ได้ ไม่ได้โกหกว่าสำเร็จหมด
- Zentih.Macro บันทึกได้แค่ "กดปุ่มไหนตอนไหน" ไม่ใช่บันทึกทุกอย่างในเกม
  (Roblox ไม่มี API แบบนั้น) ถ้าอยากบันทึกเหตุการณ์เกมด้วยให้เรียก
  RecordCustomEvent คู่กันตอนอัดอยู่
- Zentih.TD / Zentih.Dungeon เป็นแค่ "โครง" ให้ต่อยอด ต้องลงทะเบียน
  Tower/Enemy/Map/Dungeon ของเกมคุณเองก่อนถึงจะใช้งานได้จริง
- ดูรายละเอียดพารามิเตอร์ครบทุกฟังก์ชันได้ในไฟล์ API.md (ภาษาอังกฤษ)

========================================================================
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- LocalPlayer can briefly be nil if this script runs before the client has
-- fully joined; wait for it instead of erroring immediately. PlayerGui is
-- waited for with a timeout rather than indefinitely, so a rare edge case
-- (unusual account/client state) can't silently hang the whole script
-- forever with no error and no way to recover.
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    or LocalPlayer:FindFirstChildOfClass("PlayerGui")
    or error("Zentih: PlayerGui did not become available within 10 seconds")

local ThemePresets = {
    Original = {
        Background    = Color3.fromRGB(18, 21, 29),
        Sidebar       = Color3.fromRGB(14, 17, 24),
        TopBar        = Color3.fromRGB(14, 17, 24),
        Card          = Color3.fromRGB(25, 29, 39),
        CardHover     = Color3.fromRGB(30, 35, 46),
        Stroke        = Color3.fromRGB(34, 38, 50),
        Accent        = Color3.fromRGB(64, 132, 245),
        TextPrimary   = Color3.fromRGB(238, 239, 243),
        TextSecondary = Color3.fromRGB(142, 148, 163),
        TextTab       = Color3.fromRGB(150, 156, 170),
        TextTabActive = Color3.fromRGB(240, 241, 245),
        ToggleOff     = Color3.fromRGB(52, 57, 70),
        ToggleKnob    = Color3.fromRGB(255, 255, 255),
        SliderTrack   = Color3.fromRGB(46, 51, 64),
        Success       = Color3.fromRGB(72, 187, 120),
        Error         = Color3.fromRGB(224, 92, 92),
    },
    Black = { -- ดำสุด — near-pure black, minimal color anywhere
        Background    = Color3.fromRGB(6, 6, 7),
        Sidebar       = Color3.fromRGB(3, 3, 4),
        TopBar        = Color3.fromRGB(3, 3, 4),
        Card          = Color3.fromRGB(12, 12, 14),
        CardHover     = Color3.fromRGB(18, 18, 20),
        Stroke        = Color3.fromRGB(26, 26, 29),
        Accent        = Color3.fromRGB(120, 120, 128),
        TextPrimary   = Color3.fromRGB(235, 235, 237),
        TextSecondary = Color3.fromRGB(130, 130, 135),
        TextTab       = Color3.fromRGB(120, 120, 125),
        TextTabActive = Color3.fromRGB(245, 245, 246),
        ToggleOff     = Color3.fromRGB(30, 30, 33),
        ToggleKnob    = Color3.fromRGB(255, 255, 255),
        SliderTrack   = Color3.fromRGB(22, 22, 25),
        Success       = Color3.fromRGB(72, 187, 120),
        Error         = Color3.fromRGB(224, 92, 92),
    },
    CrimsonNight = { -- แดงเลือดหมูผสมดำ เน้นสีแดงเป็นจุดเด่น
        Background    = Color3.fromRGB(20, 14, 15),
        Sidebar       = Color3.fromRGB(15, 10, 11),
        TopBar        = Color3.fromRGB(15, 10, 11),
        Card          = Color3.fromRGB(28, 19, 20),
        CardHover     = Color3.fromRGB(35, 24, 25),
        Stroke        = Color3.fromRGB(50, 32, 34),
        Accent        = Color3.fromRGB(230, 70, 80),
        TextPrimary   = Color3.fromRGB(245, 235, 236),
        TextSecondary = Color3.fromRGB(180, 155, 157),
        TextTab       = Color3.fromRGB(160, 135, 137),
        TextTabActive = Color3.fromRGB(250, 240, 241),
        ToggleOff     = Color3.fromRGB(55, 36, 38),
        ToggleKnob    = Color3.fromRGB(255, 255, 255),
        SliderTrack   = Color3.fromRGB(45, 29, 31),
        Success       = Color3.fromRGB(72, 187, 120),
        Error         = Color3.fromRGB(255, 100, 100),
    },
    OceanTeal = { -- ฟ้าอมเขียวผสมดำ โทนเย็น
        Background    = Color3.fromRGB(12, 20, 22),
        Sidebar       = Color3.fromRGB(8, 15, 17),
        TopBar        = Color3.fromRGB(8, 15, 17),
        Card          = Color3.fromRGB(16, 28, 31),
        CardHover     = Color3.fromRGB(21, 36, 40),
        Stroke        = Color3.fromRGB(28, 48, 52),
        Accent        = Color3.fromRGB(60, 210, 195),
        TextPrimary   = Color3.fromRGB(230, 245, 244),
        TextSecondary = Color3.fromRGB(145, 180, 178),
        TextTab       = Color3.fromRGB(130, 165, 163),
        TextTabActive = Color3.fromRGB(240, 250, 249),
        ToggleOff     = Color3.fromRGB(32, 54, 58),
        ToggleKnob    = Color3.fromRGB(255, 255, 255),
        SliderTrack   = Color3.fromRGB(25, 44, 48),
        Success       = Color3.fromRGB(72, 187, 120),
        Error         = Color3.fromRGB(224, 92, 92),
    },
}

local Theme = {}
for k, v in pairs(ThemePresets.Original) do Theme[k] = v end

local R = { Window = 10, TopChip = 7, CtrlBtn = 6, Card = 7, Control = 6, Knob = 999 }
-- Global see-through look: every layer (window, topbar, sidebar, content,
-- cards, popout panels) shares one transparency value so the whole GUI
-- reads as one consistent glass sheet instead of opaque blocks stacked
-- on a transparent window.
local WINDOW_TRANSPARENCY = 0.15 -- 85% opacity, matches Settings > Window Opacity default
local CARD_TRANSPARENCY   = 0.06 -- 94% opacity, matches Settings > Card Opacity default
local PANEL_TRANSPARENCY  = 0    -- 100% opacity, matches Settings > Popout Opacity default

-- Fixed on-screen anchor for all Dropdown/MultiDropdown/ComboBox popouts.
-- Per user request, popouts open at this single fixed spot every time,
-- regardless of which row's select button was clicked (no per-button
-- anchoring). Coordinates are Main-local (Overlay covers Main 1:1).
local POPOUT_FIXED_X, POPOUT_FIXED_Y = 202, 108

-- Reverse lookup: Color3 value -> theme key name, rebuilt whenever the
-- active theme changes. Lets create() figure out which Theme.X a Color3
-- value came from without touching any of the ~110 element call sites
-- that already read Theme.Card / Theme.Accent / etc. directly.
local ColorKeyOf = {}
local function rebuildColorKeyOf()
    ColorKeyOf = {}
    for key, value in pairs(Theme) do
        if typeof(value) == "Color3" then
            ColorKeyOf[value] = key
        end
    end
end
rebuildColorKeyOf()

-- Every (instance, property, themeKey) triple currently live on screen,
-- so a theme switch can walk this and update everything at once.
local ThemedInstances = {}

local THEMED_PROPS = {
    BackgroundColor3 = true, TextColor3 = true, Color = true,
    PlaceholderColor3 = true, ScrollBarImageColor3 = true,
}

--// ==========================================================================
--   CORE MANAGERS — State / Debug / Performance / ErrorHandler / Input
--   These are real, working systems (not placeholders): every method here
--   does something and can be inspected/tested on its own, independent of
--   any GUI element. ThemeManager and ConfigManager build on top of the
--   existing Theme/SaveConfig code further down rather than duplicating it.
-- ==========================================================================

--// ErrorHandler -------------------------------------------------------------
-- Central place every pcall in this library reports through, instead of
-- silently swallowing errors. Keeps a rolling log and lets the host script
-- listen for errors (e.g. to show its own notification) via Subscribe.
local ErrorHandler = {}
do
    local log = {}
    local MAX_LOG = 200
    local listeners = {}

    function ErrorHandler.Report(context, err)
        local entry = { context = tostring(context), message = tostring(err), time = os.time() }
        log[#log + 1] = entry
        if #log > MAX_LOG then table.remove(log, 1) end
        for _, fn in ipairs(listeners) do pcall(fn, entry) end
        return entry
    end

    function ErrorHandler.Subscribe(fn)
        listeners[#listeners + 1] = fn
        return function()
            for i, f in ipairs(listeners) do
                if f == fn then table.remove(listeners, i) break end
            end
        end
    end

    function ErrorHandler.GetLog() return log end
    function ErrorHandler.Clear() log = {} end

    -- Guarded call: runs fn(...), and on failure reports through
    -- ErrorHandler instead of throwing. Returns (true, result) or (false, nil).
    function ErrorHandler.Guard(context, fn, ...)
        local args = { ... }
        local ok, result = pcall(function() return fn(table.unpack(args)) end)
        if not ok then
            ErrorHandler.Report(context, result)
            return false, nil
        end
        return true, result
    end
end

--// DebugManager -------------------------------------------------------------
-- A real console: 4 levels (Info/Debug/Warning/Error), timestamps, an
-- in-memory ring buffer, filtering by level or a text search, and
-- Export() to get the whole thing as one copyable string. Does not depend
-- on any GUI — usable headless (e.g. print to output) or wired into a
-- Debug tab's UI by the host script.
local DebugManager = {}
do
    local entries = {}
    local MAX_ENTRIES = 500
    local listeners = {}
    local LEVELS = { Info = 1, Debug = 2, Warning = 3, Error = 4 }

    local function push(level, ...)
        local parts = { ... }
        for i, v in ipairs(parts) do parts[i] = tostring(v) end
        local message = table.concat(parts, " ")
        local entry = { level = level, message = message, time = os.date("%H:%M:%S") }
        entries[#entries + 1] = entry
        if #entries > MAX_ENTRIES then table.remove(entries, 1) end
        for _, fn in ipairs(listeners) do pcall(fn, entry) end
        return entry
    end

    function DebugManager.Info(...) return push("Info", ...) end
    function DebugManager.Debug(...) return push("Debug", ...) end
    function DebugManager.Warning(...) return push("Warning", ...) end
    function DebugManager.Error(...) return push("Error", ...) end

    function DebugManager.Subscribe(fn)
        listeners[#listeners + 1] = fn
        return function()
            for i, f in ipairs(listeners) do
                if f == fn then table.remove(listeners, i) break end
            end
        end
    end

    -- Filter(levelOrNil, searchTextOrNil) -> array of matching entries
    function DebugManager.Filter(level, searchText)
        local out = {}
        local needle = searchText and string.lower(searchText) or nil
        for _, e in ipairs(entries) do
            local levelOk = (not level) or e.level == level
            local textOk = (not needle) or string.find(string.lower(e.message), needle, 1, true)
            if levelOk and textOk then out[#out + 1] = e end
        end
        return out
    end

    function DebugManager.Clear() entries = {} end

    function DebugManager.Export()
        local lines = {}
        for _, e in ipairs(entries) do
            lines[#lines + 1] = string.format("[%s] %s: %s", e.time, e.level, e.message)
        end
        return table.concat(lines, "\n")
    end

    function DebugManager.GetAll() return entries end
end

--// PerformanceManager -------------------------------------------------------
-- Tracks live counts of connections/instances this library has created, so
-- the host script (or a Debug/Status dashboard) can see real numbers
-- instead of guessing whether something is leaking. Counts only what
-- actually goes through create()/track() — see the Window's own
-- _connections table for the authoritative per-window connection list.
local PerformanceManager = {}
do
    local instanceCount = 0
    local connectionCount = 0
    local startClock = os.clock()

    -- Rolling FPS: a lightweight RenderStepped connection updates this
    -- once per frame. GetStats() reads the last computed value instead of
    -- yielding — a yield inside a stat-reporting function is a common
    -- source of subtle bugs (callers not expecting to pause), so this
    -- avoids that entirely.
    local currentFps = 0
    local lastTick = os.clock()
    local fpsConn = nil
    local function ensureFpsTracking()
        if fpsConn then return end
        local ok = pcall(function()
            fpsConn = RunService.RenderStepped:Connect(function()
                local now = os.clock()
                local dt = now - lastTick
                lastTick = now
                if dt > 0 then currentFps = math.floor(1 / dt) end
            end)
        end)
        if not ok then fpsConn = nil end -- e.g. running headless/server-side
    end

    function PerformanceManager.InstanceCreated() instanceCount += 1 end
    function PerformanceManager.ConnectionCreated() connectionCount += 1 end
    function PerformanceManager.ConnectionDestroyed()
        connectionCount = math.max(0, connectionCount - 1)
    end

    -- Does not yield. Safe to call from a Stat element's Set callback,
    -- a tight loop, or anywhere else that can't afford to pause a frame.
    function PerformanceManager.GetStats()
        ensureFpsTracking()
        return {
            instances = instanceCount,
            connections = connectionCount,
            uptimeSeconds = os.clock() - startClock,
            fps = currentFps,
        }
    end

    function PerformanceManager.StopFpsTracking()
        if fpsConn then fpsConn:Disconnect(); fpsConn = nil end
    end
end

--// StateManager --------------------------------------------------------------
-- A small reactive key/value store, independent of Config (which is for
-- element Flags saved to disk). State is for in-memory data your game code
-- wants to read/write/react-to from multiple places without wiring up your
-- own signal system — e.g. current wave number, selected tower, game phase.
-- StateManager.New() returns a fresh store; Zentih.State is a shared
-- default instance so simple scripts don't need to create their own.
local function newStateManager()
    local store = {}
    local subscribers = {} -- key -> array of fn(newValue, oldValue)

    local Manager = {}

    function Manager.Set(key, value)
        local old = store[key]
        store[key] = value
        if subscribers[key] then
            for _, fn in ipairs(subscribers[key]) do
                pcall(fn, value, old)
            end
        end
        return value
    end

    function Manager.Get(key, default)
        local v = store[key]
        if v == nil then return default end
        return v
    end

    -- Increment/decrement a numeric state value by delta (default 1) and
    -- return the new value. Useful for counters (kills, wave number) that
    -- would otherwise need a manual Get-then-Set every call site.
    function Manager.Increment(key, delta)
        local current = store[key]
        if type(current) ~= "number" then current = 0 end
        return Manager.Set(key, current + (delta or 1))
    end

    -- Subscribe(key, fn) -> unsubscribe(). fn(newValue, oldValue) fires
    -- every time Set(key, ...) is called, even if the value didn't change.
    function Manager.Subscribe(key, fn)
        subscribers[key] = subscribers[key] or {}
        local list = subscribers[key]
        list[#list + 1] = fn
        return function()
            for i, f in ipairs(list) do
                if f == fn then table.remove(list, i) break end
            end
        end
    end

    function Manager.GetAll()
        local copy = {}
        for k, v in pairs(store) do copy[k] = v end
        return copy
    end

    function Manager.Clear() store = {} end

    return Manager
end

--// InputManager --------------------------------------------------------------
-- Centralized global hotkey registration, separate from any single
-- Keybind GUI element. Use this for things like "press RightShift to
-- toggle the whole GUI" that aren't tied to one element's Flag/Callback.
-- Every window's ToggleBubble-adjacent hotkey, and any hotkey your own
-- game code registers, all share this one InputBegan connection instead
-- of each stacking a separate one.
local InputManager = {}
do
    local bindings = {} -- Enum.KeyCode -> array of { id, callback }
    local nextId = 0
    local connected = false

    local function ensureConnected()
        if connected then return end
        connected = true
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            local list = bindings[input.KeyCode]
            if not list then return end
            for _, entry in ipairs(list) do
                pcall(entry.callback, input)
            end
        end)
    end

    -- Bind(keyCode, callback) -> id. Call Unbind(id) to remove it later.
    function InputManager.Bind(keyCode, callback)
        ensureConnected()
        bindings[keyCode] = bindings[keyCode] or {}
        nextId += 1
        local id = nextId
        table.insert(bindings[keyCode], { id = id, callback = callback })
        return id
    end

    function InputManager.Unbind(id)
        for keyCode, list in pairs(bindings) do
            for i, entry in ipairs(list) do
                if entry.id == id then
                    table.remove(list, i)
                    return true
                end
            end
        end
        return false
    end

    function InputManager.UnbindAll(keyCode)
        bindings[keyCode] = nil
    end
end

-- Shared default instances are attached to Zentih further below, right
-- after `local Zentih = {}` is declared — see "Zentih.State = ..." near
-- the OpenPanels/registerPanel setup. (Referencing Zentih up here would be
-- the same forward-reference bug this codebase has already hit twice:
-- Zentih doesn't exist as a local yet at this point in the file.)


local function create(class, props, children)
    local inst = Instance.new(class)
    PerformanceManager.InstanceCreated()
    for k, v in pairs(props or {}) do
        inst[k] = v
        if THEMED_PROPS[k] and typeof(v) == "Color3" then
            local key = ColorKeyOf[v]
            if key then
                ThemedInstances[#ThemedInstances + 1] = { inst = inst, prop = k, key = key }
            end
        end
    end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    return inst
end
local function corner(r) return create("UICorner", { CornerRadius = UDim.new(0, r or R.Card) }) end
local function stroke(color, t) return create("UIStroke", { Color = color or Theme.Stroke, Thickness = t or 1 }) end
local function tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end
local function safeWritefile(path, data) return (pcall(function() writefile(path, data) end)) end
local function safeReadfile(path)
    local ok, data = pcall(function() return readfile(path) end)
    if ok then return data end
    return nil
end
local function safeMakeFolder(path)
    pcall(function() if not isfolder(path) then makefolder(path) end end)
end
local function safeListFiles(path)
    local ok, files = pcall(function() return listfiles(path) end)
    if ok and files then return files end
    return {}
end
local function safeDeleteFile(path)
    return (pcall(function() delfile(path) end))
end
local function safeIsFile(path)
    local ok, result = pcall(function() return isfile(path) end)
    return ok and result or false
end

local Zentih = {}
Zentih.__index = Zentih

-- Shared default instances — simple scripts can use these directly
-- (Zentih.State.Set(...), Zentih.Debug.Info(...)) without constructing
-- their own. CreateWindow also stamps a State manager onto each Window
-- for per-window isolation if the host script wants that instead.
Zentih.State = newStateManager()
Zentih.Debug = DebugManager
Zentih.Performance = PerformanceManager
Zentih.ErrorHandler = ErrorHandler
Zentih.Input = InputManager
Zentih.NewStateManager = newStateManager

--// Game/Place Detector ------------------------------------------------------
-- Real detection using actual game/game:GetService() values — no guessing.
-- GameName/PlaceName require MarketplaceService, which can fail (rate
-- limits, API outage) — those two fields are nil if the lookup fails
-- rather than throwing, everything else (IDs, JobId) is always available
-- instantly with no network call.
Zentih.Game = (function()
    local MarketplaceService = game:GetService("MarketplaceService")
    local Detector = {}
    local registeredModules = {} -- placeId (number) -> loader function

    function Detector.GetInfo()
        local info = {
            GameId = game.GameId,
            PlaceId = game.PlaceId,
            UniverseId = game.GameId, -- Roblox: GameId IS the universe id
            JobId = game.JobId,
            GameName = nil,
            PlaceName = nil,
        }
        pcall(function()
            local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
            info.GameName = productInfo.Name
            info.PlaceName = productInfo.Name
        end)
        return info
    end

    -- Register a loader function for a specific PlaceId. LoadForCurrentGame()
    -- calls whichever loader matches the place the script is currently
    -- running in, if any was registered. Typical use: register one loader
    -- per TD map, each building that map's tower/enemy/wave config.
    function Detector.RegisterGame(placeId, loaderFn)
        registeredModules[placeId] = loaderFn
    end

    -- Returns (true, result) if a loader was registered and ran
    -- successfully, (false, nil) if no loader matched or it errored (the
    -- error is reported through Zentih.ErrorHandler rather than thrown).
    function Detector.LoadForCurrentGame(...)
        local loader = registeredModules[game.PlaceId]
        if not loader then return false, nil end
        return ErrorHandler.Guard("Game.LoadForCurrentGame", loader, ...)
    end

    function Detector.IsRegistered(placeId)
        return registeredModules[placeId or game.PlaceId] ~= nil
    end

    return Detector
end)()

--// TD Backend (generic scaffold) --------------------------------------------
-- A generic framework for Tower Defense-style games: Tower/Enemy/Wave/Map
-- registries plus economy/lives/base-HP tracking. This is NOT a working
-- game by itself — Zentih doesn't know your towers' stats, your enemies'
-- pathing, or your map layout. What it provides is a consistent, tested
-- place to register that data and react to it (targeting logic, wave
-- timers, economy math) so you don't have to build that plumbing yourself
-- for every map. Every piece is built on StateManager, so anything here
-- is also visible/subscribable through Window.State.
Zentih.TD = (function()
    local TD = {}
    local towers = {}    -- id -> definition table (Stats, Level, Range, ...)
    local enemies = {}   -- id -> definition table
    local maps = {}       -- id -> { Path, Waypoints, Spawn, Base, PlacementZones, RestrictedZones }
    local placedTowers = {} -- instanceId -> { defId, level, position, ... }
    local state = newStateManager()
    TD.State = state

    -- Seed the usual TD state keys so Subscribe() works from the very
    -- first frame even before your game code calls Set() on them.
    state.Set("Wave", 0)
    state.Set("MaxWave", 0)
    state.Set("Coins", 0)
    state.Set("Lives", 0)
    state.Set("BaseHP", 0)
    state.Set("WaveActive", false)
    state.Set("CurrentMap", nil)

    -- Tower ------------------------------------------------------------
    -- RegisterTower(id, definition): definition is any table — Stats,
    -- Level, Damage, Range, Cooldown, UpgradePaths, SellValue, whatever
    -- your game needs. Zentih just stores and returns it; it doesn't
    -- interpret the fields, so any tower "shape" works.
    function TD.RegisterTower(id, definition)
        towers[id] = definition
    end
    function TD.GetTower(id) return towers[id] end
    function TD.GetAllTowers() return towers end

    -- PlaceTower(instanceId, towerDefId, position) tracks a placed
    -- instance separately from the tower's static definition, so the same
    -- definition can be placed many times with independent level/state.
    function TD.PlaceTower(instanceId, towerDefId, position, extra)
        local def = towers[towerDefId]
        if not def then return false, "unknown tower id: " .. tostring(towerDefId) end
        local placed = { defId = towerDefId, level = 1, position = position }
        if extra then for k, v in pairs(extra) do placed[k] = v end end
        placedTowers[instanceId] = placed
        return true, placed
    end
    function TD.SellTower(instanceId)
        local placed = placedTowers[instanceId]
        placedTowers[instanceId] = nil
        return placed
    end
    function TD.UpgradeTower(instanceId)
        local placed = placedTowers[instanceId]
        if not placed then return false end
        placed.level += 1
        return true, placed.level
    end
    function TD.GetPlacedTower(instanceId) return placedTowers[instanceId] end
    function TD.GetAllPlacedTowers() return placedTowers end

    -- TargetMode: given a list of enemy position/health tables and a
    -- tower's position+range, returns the index of the enemy that
    -- matches the requested mode. Pure function — no Roblox-specific
    -- pathing knowledge required, so it works with any enemy shape as
    -- long as each entry has .Position (Vector3) and .Health (number).
    local TARGET_MODES = { "First", "Last", "Nearest", "Farthest", "Strongest", "Weakest", "Boss", "Custom" }
    TD.TargetModes = TARGET_MODES
    function TD.SelectTarget(mode, towerPosition, range, candidateEnemies, customFn)
        local inRange = {}
        for i, e in ipairs(candidateEnemies) do
            if not e.Position or (towerPosition - e.Position).Magnitude <= (range or math.huge) then
                inRange[#inRange + 1] = { index = i, enemy = e }
            end
        end
        if #inRange == 0 then return nil end

        if mode == "Custom" and customFn then
            return customFn(inRange)
        elseif mode == "First" then
            return inRange[1].enemy, inRange[1].index
        elseif mode == "Last" then
            return inRange[#inRange].enemy, inRange[#inRange].index
        elseif mode == "Boss" then
            for _, entry in ipairs(inRange) do
                if entry.enemy.IsBoss then return entry.enemy, entry.index end
            end
            return nil
        elseif mode == "Nearest" or mode == "Farthest" then
            local best, bestDist = nil, nil
            for _, entry in ipairs(inRange) do
                local dist = (towerPosition - entry.enemy.Position).Magnitude
                if not bestDist or (mode == "Nearest" and dist < bestDist) or (mode == "Farthest" and dist > bestDist) then
                    best, bestDist = entry, dist
                end
            end
            return best and best.enemy, best and best.index
        elseif mode == "Strongest" or mode == "Weakest" then
            local best, bestHp = nil, nil
            for _, entry in ipairs(inRange) do
                local hp = entry.enemy.Health or 0
                if not bestHp or (mode == "Strongest" and hp > bestHp) or (mode == "Weakest" and hp < bestHp) then
                    best, bestHp = entry, hp
                end
            end
            return best and best.enemy, best and best.index
        end
        return inRange[1].enemy, inRange[1].index -- unknown mode: fall back to First
    end

    -- Enemy --------------------------------------------------------------
    function TD.RegisterEnemy(id, definition)
        enemies[id] = definition
    end
    function TD.GetEnemy(id) return enemies[id] end
    function TD.GetAllEnemies() return enemies end

    -- Map ------------------------------------------------------------
    -- definition: { Path = {Vector3, ...} or Waypoints, Spawn, Base,
    -- PlacementZones = {...}, RestrictedZones = {...} } — every field
    -- optional, stored as-is.
    function TD.RegisterMap(id, definition)
        maps[id] = definition
    end
    function TD.GetMap(id) return maps[id] end
    function TD.SetCurrentMap(id)
        state.Set("CurrentMap", id)
        return maps[id]
    end
    function TD.GetCurrentMap()
        return maps[state.Get("CurrentMap")]
    end

    -- IsInPlacementZone/IsInRestrictedZone: a zone is any table exposing
    -- either a Roblox Region3/BasePart-like :IsPointInside(pos) OR simple
    -- Center+Size fields (axis-aligned box check) — supports both without
    -- forcing one representation.
    local function pointInZone(pos, zone)
        if zone.IsPointInside then
            local ok, result = pcall(function() return zone:IsPointInside(pos) end)
            if ok then return result end
        end
        if zone.Center and zone.Size then
            local halfSize = zone.Size / 2
            local diff = pos - zone.Center
            return math.abs(diff.X) <= halfSize.X and math.abs(diff.Y) <= halfSize.Y and math.abs(diff.Z) <= halfSize.Z
        end
        return false
    end
    function TD.IsInPlacementZone(pos, mapId)
        local map = maps[mapId or state.Get("CurrentMap")]
        if not map or not map.PlacementZones then return false end
        for _, zone in ipairs(map.PlacementZones) do
            if pointInZone(pos, zone) then return true end
        end
        return false
    end
    function TD.IsInRestrictedZone(pos, mapId)
        local map = maps[mapId or state.Get("CurrentMap")]
        if not map or not map.RestrictedZones then return false end
        for _, zone in ipairs(map.RestrictedZones) do
            if pointInZone(pos, zone) then return true end
        end
        return false
    end

    -- Wave / Economy / Lives ------------------------------------------
    -- These just wrap the seeded State keys with clearer names + the
    -- occasional bit of math (economy), rather than reimplementing a
    -- timer system Zentih can't know the right pacing for.
    function TD.StartWave()
        state.Increment("Wave")
        state.Set("WaveActive", true)
    end
    function TD.EndWave()
        state.Set("WaveActive", false)
    end
    function TD.SkipWave()
        TD.EndWave()
        state.Increment("Wave")
    end
    function TD.GetWave() return state.Get("Wave", 0) end
    function TD.IsWaveActive() return state.Get("WaveActive", false) end

    function TD.AddCoins(amount) return state.Increment("Coins", amount) end
    function TD.SpendCoins(amount)
        local current = state.Get("Coins", 0)
        if current < amount then return false, current end
        state.Set("Coins", current - amount)
        return true, current - amount
    end
    function TD.GetCoins() return state.Get("Coins", 0) end

    function TD.DamageBase(amount)
        local hp = math.max(0, state.Get("BaseHP", 0) - amount)
        state.Set("BaseHP", hp)
        if hp <= 0 then state.Set("Lives", math.max(0, state.Get("Lives", 0) - 1)) end
        return hp
    end
    function TD.GetLives() return state.Get("Lives", 0) end
    function TD.IsGameOver() return state.Get("Lives", 0) <= 0 end

    return TD
end)()

--// Dungeon Backend (generic scaffold) ---------------------------------------
-- Same philosophy as TD above: generic room/stage/objective tracking, no
-- game-specific content baked in.
Zentih.Dungeon = (function()
    local Dungeon = {}
    local dungeons = {} -- id -> { Rooms, Stages, Boss, Difficulty, ... }
    local state = newStateManager()
    Dungeon.State = state
    state.Set("CurrentDungeon", nil)
    state.Set("CurrentStage", 0)
    state.Set("Checkpoint", nil)
    state.Set("Timer", 0)

    function Dungeon.RegisterDungeon(id, definition)
        dungeons[id] = definition
    end
    function Dungeon.GetDungeon(id) return dungeons[id] end
    function Dungeon.Enter(id)
        state.Set("CurrentDungeon", id)
        state.Set("CurrentStage", 1)
        return dungeons[id]
    end
    function Dungeon.NextStage()
        return state.Increment("CurrentStage")
    end
    function Dungeon.SetCheckpoint(data)
        state.Set("Checkpoint", data)
    end
    function Dungeon.GetCheckpoint()
        return state.Get("Checkpoint")
    end
    function Dungeon.Complete(reward)
        state.Set("CurrentDungeon", nil)
        return reward
    end

    return Dungeon
end)()

--// Macro ---------------------------------------------------------------
-- Records key press/release events (via InputManager-style timestamps)
-- and can play them back later. This is an input-timing recorder, not a
-- game-action recorder — it captures which keys were pressed and when,
-- and replaying it re-fires those same key events through
-- Zentih.Input's bindings. It does NOT capture mouse movement, camera,
-- or arbitrary game state, since Roblox has no generic API for "record
-- everything that happened" — anything scripted around specific
-- RemoteEvents needs to be recorded by your own game code calling
-- Zentih.Macro.RecordCustomEvent(name, data) at the right moments, which
-- this system supports and will replay in-order alongside key events.
Zentih.Macro = (function()
    local Macro = {}
    local recordings = {} -- name -> { events = {...}, speed = 1 }
    local recording = nil -- currently-recording table, or nil
    local recordStart = 0
    local playState = "Stopped" -- Stopped | Recording | Playing | Paused
    local playToken = 0 -- incremented to cancel an in-progress Play()
    local inputConn = nil

    function Macro.GetState() return playState end

    function Macro.Record(name)
        if playState == "Recording" then Macro.Stop() end
        recording = { name = name, events = {} }
        recordStart = os.clock()
        playState = "Recording"

        local ok = pcall(function()
            inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed or not recording then return end
                if input.KeyCode and input.KeyCode ~= Enum.KeyCode.Unknown then
                    table.insert(recording.events, {
                        t = os.clock() - recordStart, type = "KeyDown", key = input.KeyCode,
                    })
                end
            end)
        end)
        if not ok then
            playState = "Stopped"
            recording = nil
            return false, "InputBegan unavailable in this environment"
        end
        return true
    end

    -- Lets your own game code fold a custom event (a RemoteEvent fire, a
    -- state change, anything) into the recording, timestamped the same
    -- way key events are, so Play() replays everything in the right order.
    function Macro.RecordCustomEvent(eventName, data)
        if playState ~= "Recording" or not recording then return false end
        table.insert(recording.events, {
            t = os.clock() - recordStart, type = "Custom", name = eventName, data = data,
        })
        return true
    end

    function Macro.Stop()
        if inputConn then pcall(function() inputConn:Disconnect() end); inputConn = nil end
        if playState == "Recording" and recording then
            recordings[recording.name] = recording
        end
        recording = nil
        playState = "Stopped"
        playToken += 1 -- also cancels any in-progress Play()
    end

    function Macro.Pause()
        if playState == "Playing" then playState = "Paused" end
    end
    function Macro.Resume()
        if playState == "Paused" then playState = "Playing" end
    end

    -- Play(name, opts): opts = { Speed = 1, Loop = false, OnCustomEvent =
    -- function(name, data) end }. Key events replay by firing whatever
    -- was Bind()'d on that KeyCode via Zentih.Input; custom events call
    -- OnCustomEvent if provided. Any single event that errors is skipped
    -- (per spec: one bad event must not break the whole playback) — it's
    -- reported through ErrorHandler instead of stopping playback.
    function Macro.Play(name, opts)
        opts = opts or {}
        local rec = recordings[name]
        if not rec then return false, "no recording named " .. tostring(name) end
        local speed = opts.Speed or 1
        local myToken = playToken + 1
        playToken = myToken
        playState = "Playing"

        task.spawn(function()
            repeat
                local startClock = os.clock()
                for _, event in ipairs(rec.events) do
                    while playState == "Paused" and playToken == myToken do task.wait(0.05) end
                    if playToken ~= myToken then return end -- Stop() was called
                    local targetTime = event.t / speed
                    local elapsed = os.clock() - startClock
                    if targetTime > elapsed then task.wait(targetTime - elapsed) end
                    if playToken ~= myToken then return end

                    ErrorHandler.Guard("Macro.Play:" .. tostring(name), function()
                        if event.type == "KeyDown" then
                            -- Replays by calling the host script's OnKeyEvent
                            -- hook rather than reaching into InputManager's
                            -- internals — keeps InputManager's binding table
                            -- private and lets the host decide what "replay
                            -- this key" actually means for their game.
                            if opts.OnKeyEvent then opts.OnKeyEvent(event.key) end
                        elseif event.type == "Custom" and opts.OnCustomEvent then
                            opts.OnCustomEvent(event.name, event.data)
                        end
                    end)
                end
                if playToken ~= myToken then return end
            until not opts.Loop or playToken ~= myToken
            if playToken == myToken then playState = "Stopped" end
        end)
        return true
    end

    function Macro.SaveToFile(name, folder)
        local rec = recordings[name]
        if not rec then return false, "no recording named " .. tostring(name) end
        safeMakeFolder(folder)
        return safeWritefile(folder .. "/" .. name .. ".json", HttpService:JSONEncode(rec))
    end

    function Macro.LoadFromFile(name, folder)
        local raw = safeReadfile(folder .. "/" .. name .. ".json")
        if not raw then return false, "file not found" end
        local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if not ok then return false, "corrupted macro file" end
        recordings[name] = data
        return true
    end

    function Macro.Rename(oldName, newName)
        if not recordings[oldName] then return false end
        recordings[newName] = recordings[oldName]
        recordings[newName].name = newName
        recordings[oldName] = nil
        return true
    end

    function Macro.Delete(name)
        local existed = recordings[name] ~= nil
        recordings[name] = nil
        return existed
    end

    function Macro.List()
        local out = {}
        for name in pairs(recordings) do out[#out + 1] = name end
        table.sort(out)
        return out
    end

    -- BindHotkey(keyCode, action, macroName): action is "Play"/"Stop"/
    -- "Pause"/"Resume". Wraps Zentih.Input.Bind so a macro can be
    -- triggered by a key without the host script wiring that up by hand.
    function Macro.BindHotkey(keyCode, action, macroName, opts)
        return InputManager.Bind(keyCode, function()
            if action == "Play" then Macro.Play(macroName, opts)
            elseif action == "Stop" then Macro.Stop()
            elseif action == "Pause" then Macro.Pause()
            elseif action == "Resume" then Macro.Resume() end
        end)
    end

    return Macro
end)()

--// Script Manager -------------------------------------------------------
-- Registers named "script modules" (any function or ModuleScript-style
-- table with a callable) under a category, and manages their running
-- state (Enable/Disable/Execute/Stop/Restart/Reload). Zentih doesn't ship
-- any scripts itself — this is purely the bookkeeping layer + a safe
-- execution wrapper (every Execute goes through ErrorHandler.Guard, so
-- one broken script module can't take down another or the GUI).
Zentih.ScriptManager = (function()
    local Manager = {}
    local scripts = {} -- id -> { fn, category, enabled, running, favorite, stopFn }
    local VALID_CATEGORIES = { Universal = true, TD = true, Dungeon = true, Combat = true, Utility = true, Map = true }
    Manager.Categories = { "Universal", "TD", "Dungeon", "Combat", "Utility", "Map" }

    -- Register(id, fn, category): fn(stopSignal) is called on Execute().
    -- fn should periodically check stopSignal.Stopped and return if true,
    -- for scripts that run a loop — Stop() only sets that flag, it cannot
    -- forcibly interrupt Lua code that never checks it (Roblox has no
    -- generic "kill this coroutine" primitive that's safe to use here).
    function Manager.Register(id, fn, category)
        category = VALID_CATEGORIES[category] and category or "Utility"
        scripts[id] = {
            fn = fn, category = category, enabled = true,
            running = false, favorite = false, stopSignal = nil,
        }
        return true
    end

    function Manager.Unregister(id)
        if scripts[id] and scripts[id].running then Manager.Stop(id) end
        scripts[id] = nil
    end

    function Manager.Execute(id)
        local entry = scripts[id]
        if not entry then return false, "not registered: " .. tostring(id) end
        if not entry.enabled then return false, "disabled: " .. tostring(id) end
        if entry.running then return false, "already running: " .. tostring(id) end

        local stopSignal = { Stopped = false }
        entry.stopSignal = stopSignal
        entry.running = true
        task.spawn(function()
            local ok, err = ErrorHandler.Guard("ScriptManager.Execute:" .. tostring(id), entry.fn, stopSignal)
            entry.running = false
            if not ok then
                DebugManager.Error("Script", id, "errored:", err)
            end
        end)
        return true
    end

    function Manager.Stop(id)
        local entry = scripts[id]
        if not entry or not entry.stopSignal then return false end
        entry.stopSignal.Stopped = true
        entry.running = false
        return true
    end

    function Manager.Restart(id)
        Manager.Stop(id)
        task.wait()
        return Manager.Execute(id)
    end

    -- Reload(id, newFn): swaps in a new implementation for an already
    -- registered id (e.g. after hot-loading updated code), stopping the
    -- old run first if one was in progress.
    function Manager.Reload(id, newFn)
        local entry = scripts[id]
        if not entry then return false, "not registered: " .. tostring(id) end
        local wasRunning = entry.running
        if wasRunning then Manager.Stop(id) end
        entry.fn = newFn
        if wasRunning then Manager.Execute(id) end
        return true
    end

    function Manager.Enable(id) if scripts[id] then scripts[id].enabled = true end end
    function Manager.Disable(id)
        if scripts[id] then
            scripts[id].enabled = false
            if scripts[id].running then Manager.Stop(id) end
        end
    end
    function Manager.SetFavorite(id, favorite)
        if scripts[id] then scripts[id].favorite = favorite end
    end

    function Manager.IsRunning(id) return scripts[id] and scripts[id].running or false end
    function Manager.Get(id) return scripts[id] end

    -- Search(query, category): substring match on id, optional category
    -- filter. Returns an array of ids (not the full entries) for a UI
    -- list to render.
    function Manager.Search(query, category)
        local out = {}
        local needle = query and query ~= "" and string.lower(query) or nil
        for id, entry in pairs(scripts) do
            local textOk = (not needle) or string.find(string.lower(tostring(id)), needle, 1, true)
            local catOk = (not category) or entry.category == category
            if textOk and catOk then out[#out + 1] = id end
        end
        table.sort(out, function(a, b) return tostring(a) < tostring(b) end)
        return out
    end

    function Manager.ListFavorites()
        local out = {}
        for id, entry in pairs(scripts) do
            if entry.favorite then out[#out + 1] = id end
        end
        table.sort(out, function(a, b) return tostring(a) < tostring(b) end)
        return out
    end

    return Manager
end)()

local OpenPanels = {}
local function registerPanel(closeFn) OpenPanels[#OpenPanels + 1] = closeFn end
local function closeAllPanelsExcept(exceptFn)
    for _, fn in ipairs(OpenPanels) do if fn ~= exceptFn then pcall(fn) end end
end

-- Tracks the previous CreateWindow's connections/state at module scope, so
-- re-running the script (common while iterating, or on a script hot-reload)
-- doesn't stack up duplicate UserInputService connections forever. Without
-- this, every re-run leaks the prior run's drag/slider/colorpicker input
-- listeners permanently, since those live on a global service rather than
-- a destroyable GUI Instance.
local PreviousWindowConnections = nil

--// Drawn tab icons ------------------------------------------------------
-- Defined before CreateWindow/CreateTab (which both call drawIcon) so the
-- local is always in scope by the time either function's body actually
-- runs — a local declared further down the file is NOT visible to a
-- function defined earlier in the file, even though both are top-level.
local function drawIcon(kind, parent, color)
    -- Hand-drawn line icons built from plain Frames/UICorners — no font
    -- glyphs (Gotham can't render most symbols) and no external asset IDs.
    -- Each icon lives in an 18x18 box, centered by the caller.
    local function bar(w, h, x, y, round)
        return create("Frame", {
            Size = UDim2.fromOffset(w, h), Position = UDim2.fromOffset(x, y),
            BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, round and { corner(round) } or nil)
    end

    if kind == "home" then -- บ้าน
        bar(2, 9, 3, 8, 1)          -- left wall
        bar(2, 9, 13, 8, 1)         -- right wall
        bar(12, 2, 3, 8, 1)         -- roof base
        bar(2, 9, 8, 8, 1)          -- door
        create("Frame", {
            Size = UDim2.fromOffset(9, 2), Position = UDim2.fromOffset(1, 5),
            Rotation = 40, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
        create("Frame", {
            Size = UDim2.fromOffset(9, 2), Position = UDim2.fromOffset(8, 5),
            Rotation = -40, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
    elseif kind == "sword" then -- ดาบ
        create("Frame", {
            Size = UDim2.fromOffset(2, 12), Position = UDim2.fromOffset(8, 2),
            Rotation = 45, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
        create("Frame", {
            Size = UDim2.fromOffset(8, 2), Position = UDim2.fromOffset(6, 10),
            Rotation = 45, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
        create("Frame", {
            Size = UDim2.fromOffset(2, 5), Position = UDim2.fromOffset(11, 11),
            Rotation = 45, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
    elseif kind == "save" then -- สมุดเซฟ (floppy disk / save book)
        bar(14, 14, 2, 2, 3)
        bar(8, 5, 5, 2, 1)          -- top notch
        bar(9, 6, 4, 9, 1)          -- bottom label area
    elseif kind == "settings" then -- ตั้งค่า (gear)
        create("Frame", {
            Size = UDim2.fromOffset(11, 11), Position = UDim2.fromOffset(3.5, 3.5),
            BackgroundTransparency = 1, ZIndex = 3, Parent = parent,
        }, { corner(999), stroke(color, 2) })
        for a = 0, 5 do
            create("Frame", {
                Size = UDim2.fromOffset(2, 4), Position = UDim2.fromOffset(8, -1),
                Rotation = a * 60, AnchorPoint = Vector2.new(0.5, 0),
                BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
            }, { corner(1) })
        end
    elseif kind == "input" then -- ช่องกรอกข้อความ / pencil
        create("Frame", {
            Size = UDim2.fromOffset(2, 12), Position = UDim2.fromOffset(8, 2),
            Rotation = 45, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
        bar(3, 3, 2, 13, 1)         -- pencil tip
    elseif kind == "dungeon" then -- ดันเจี้ยน (stone archway/gate)
        bar(2, 12, 2, 5, 1)                             -- left pillar
        bar(2, 12, 14, 5, 1)                             -- right pillar
        create("Frame", {
            Size = UDim2.fromOffset(14, 7), Position = UDim2.fromOffset(2, 2),
            BackgroundTransparency = 1, ZIndex = 3, Parent = parent,
        }, { create("UICorner", { CornerRadius = UDim.new(0.5, 0) }), stroke(color, 2) })
        bar(10, 2, 4, 15, 1)                             -- floor sill
    elseif kind == "status" then -- สเตตัส (heartbeat / pulse line)
        bar(3, 2, 1, 8, 1)
        create("Frame", {
            Size = UDim2.fromOffset(2, 8), Position = UDim2.fromOffset(4, 5),
            Rotation = 20, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
        create("Frame", {
            Size = UDim2.fromOffset(2, 12), Position = UDim2.fromOffset(7, 2),
            Rotation = -18, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
        create("Frame", {
            Size = UDim2.fromOffset(2, 8), Position = UDim2.fromOffset(11, 5),
            Rotation = 20, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
        bar(3, 2, 14, 8, 1)
    elseif kind == "eye" then -- ตา
        create("Frame", {
            Size = UDim2.fromOffset(16, 9), Position = UDim2.fromOffset(1, 4.5),
            BackgroundTransparency = 1, ZIndex = 3, Parent = parent,
        }, { corner(999), stroke(color, 2) })
        bar(5, 5, 6.5, 6.5, 999)                         -- pupil
    elseif kind == "star" then -- ดาว (4-point sparkle style)
        create("Frame", {
            Size = UDim2.fromOffset(3, 18), Position = UDim2.fromOffset(7.5, 0),
            BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
        create("Frame", {
            Size = UDim2.fromOffset(18, 3), Position = UDim2.fromOffset(0, 7.5),
            BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
        create("Frame", {
            Size = UDim2.fromOffset(2, 12), Position = UDim2.fromOffset(8, 3),
            Rotation = 45, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
        create("Frame", {
            Size = UDim2.fromOffset(2, 12), Position = UDim2.fromOffset(8, 3),
            Rotation = -45, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
    elseif kind == "gamepad" then -- Gamepad
        bar(14, 8, 2, 6, 3)                        -- body
        bar(4, 2, 2, 3, 1)                          -- left grip stub
        bar(4, 2, 12, 3, 1)                         -- right grip stub
        bar(4, 1, 4, 9, 1)                          -- d-pad horizontal
        bar(1, 4, 5.5, 7.5, 1)                      -- d-pad vertical
        bar(2, 2, 12, 8, 999)                       -- face button
    elseif kind == "macro" then -- Macro (record dot inside a frame)
        create("Frame", {
            Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(1, 1),
            BackgroundTransparency = 1, ZIndex = 3, Parent = parent,
        }, { corner(4), stroke(color, 2) })
        bar(6, 6, 6, 6, 999)                        -- filled record dot
    elseif kind == "map" then -- Map (folded map with route dashes)
        create("Frame", {
            Size = UDim2.fromOffset(16, 12), Position = UDim2.fromOffset(1, 3),
            BackgroundTransparency = 1, ZIndex = 3, Parent = parent,
        }, { corner(2), stroke(color, 2) })
        bar(1, 12, 6, 3, nil)
        bar(1, 12, 11, 3, nil)
        bar(3, 3, 3, 12, 999)                       -- location pin dot
    elseif kind == "script" then -- Script (document with fold + lines)
        create("Frame", {
            Size = UDim2.fromOffset(12, 16), Position = UDim2.fromOffset(3, 1),
            BackgroundTransparency = 1, ZIndex = 3, Parent = parent,
        }, { corner(2), stroke(color, 2) })
        bar(6, 1.5, 6, 6, 1)
        bar(6, 1.5, 6, 9.5, 1)
        bar(4, 1.5, 6, 13, 1)
    elseif kind == "config" then -- Config (sliders)
        bar(14, 2, 2, 4, 1)
        bar(14, 2, 2, 9, 1)
        bar(14, 2, 2, 14, 1)
        bar(3, 6, 5, 1, 999)                        -- slider knob row 1
        bar(3, 6, 10, 6, 999)                       -- slider knob row 2
        bar(3, 6, 6, 11, 999)                       -- slider knob row 3
    elseif kind == "debug" then -- Debug (bug body + antennae + legs)
        bar(8, 9, 5, 5, 4)                          -- body
        bar(6, 1.5, 6, 2, 1)                        -- antenna base
        create("Frame", {
            Size = UDim2.fromOffset(5, 1.5), Position = UDim2.fromOffset(2, 0),
            Rotation = -30, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
        create("Frame", {
            Size = UDim2.fromOffset(5, 1.5), Position = UDim2.fromOffset(11, 0),
            Rotation = 30, BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 3, Parent = parent,
        }, { corner(1) })
        bar(4, 1.5, 0, 8, 1)                        -- left leg
        bar(4, 1.5, 14, 8, 1)                       -- right leg
        bar(4, 1.5, 0, 12, 1)                       -- left leg 2
        bar(4, 1.5, 14, 12, 1)                      -- right leg 2
    elseif kind == "tower" then -- Tower (TD turret silhouette)
        bar(4, 4, 7, 1, 1)                          -- turret head
        bar(2, 4, 8, -1, 1)                         -- barrel
        bar(8, 3, 5, 5, 1)                          -- upper base
        bar(12, 4, 3, 8, 1)                         -- lower base (wider)
        bar(14, 2, 2, 14, 1)                        -- foundation
    elseif kind == "enemy" then -- Enemy (skull-like silhouette)
        bar(12, 10, 3, 2, 5)                        -- head
        bar(3, 3, 5, 6, 999)                        -- left eye
        bar(3, 3, 10, 6, 999)                       -- right eye
        bar(2, 3, 6, 12, 1)
        bar(2, 3, 8.5, 13, 1)
        bar(2, 3, 11, 12, 1)
    elseif kind == "wave" then -- Wave (signal/ripple lines)
        for i = 0, 2 do
            create("Frame", {
                Size = UDim2.fromOffset(6 + i * 4, 6 + i * 4),
                Position = UDim2.fromOffset(9 - i * 2, 9 - i * 2),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1, ZIndex = 3, Parent = parent,
            }, { corner(999), stroke(color, 1.5) })
        end
        bar(3, 3, 7.5, 7.5, 999)                    -- center dot
    end
end

-- Icon size the drawIcon shapes were authored at — every kind() case above
-- positions its pieces inside this box. createIconButton() below scales
-- the whole thing up/down from here via UIScale, so a bigger/smaller
-- requested size never distorts proportions (no shape-specific math to
-- keep in sync when you add a new icon or change the target size).
local ICON_BASE_SIZE = 18

-- createIconButton(kind, size, colors) -> control
--   kind:  icon name (see the list in drawIcon above)
--   size:  requested pixel size (square); scales the 18x18 artwork via
--          UIScale so nothing distorts at any size
--   colors: { Normal, Hover, Selected, Disabled } — any can be omitted,
--           falls back to Theme.TextTab / Theme.TextTabActive
--
-- Returns a control table: { Frame, SetState(stateName), Destroy() }.
-- SetState animates the icon's color to match Normal/Hover/Selected/
-- Disabled — call it from your own MouseEnter/MouseLeave/click handlers,
-- or let CreateTab's own tab buttons drive it automatically (they already
-- do, via the same Theme colors).
local function createIconButton(kind, size, colors)
    colors = colors or {}
    local stateColors = {
        Normal = colors.Normal or Theme.TextTab,
        Hover = colors.Hover or Theme.TextTabActive,
        Selected = colors.Selected or Theme.Accent,
        Disabled = colors.Disabled or Theme.TextSecondary,
    }

    local Holder = create("Frame", {
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, ClipsDescendants = false,
    })
    local Inner = create("Frame", {
        Size = UDim2.fromOffset(ICON_BASE_SIZE, ICON_BASE_SIZE), BackgroundTransparency = 1,
        Parent = Holder,
    })
    create("UIScale", { Scale = size / ICON_BASE_SIZE, Parent = Inner })

    local currentColor = stateColors.Normal
    drawIcon(kind, Inner, currentColor)

    local currentState = "Normal"
    local function setState(stateName)
        local target = stateColors[stateName] or stateColors.Normal
        currentState = stateName
        for _, child in ipairs(Inner:GetChildren()) do
            if child:IsA("Frame") then tween(child, { BackgroundColor3 = target }, 0.12) end
            if child:IsA("UIStroke") then tween(child, { Color = target }, 0.12) end
        end
    end

    return {
        Frame = Holder,
        Inner = Inner,
        SetState = setState,
        GetState = function() return currentState end,
        Destroy = function() Holder:Destroy() end,
    }
end

Zentih.CreateIconButton = createIconButton
Zentih.IconList = {
    "home", "sword", "save", "settings", "input", "dungeon", "status",
    "eye", "star", "gamepad", "macro", "map", "script", "config", "debug",
    "tower", "enemy", "wave",
}

--// Window ----------------------------------------------------------------
function Zentih:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Zentih"
    local subtitle = config.Subtitle or ""
    local configFolder = config.ConfigFolder or "ZentihUI"

    if PreviousWindowConnections then
        for _, conn in ipairs(PreviousWindowConnections) do pcall(function() conn:Disconnect() end) end
    end
    OpenPanels = {}
    ThemedInstances = {}
    for k, v in pairs(ThemePresets.Original) do Theme[k] = v end
    rebuildColorKeyOf()

    local existing = PlayerGui:FindFirstChild("ZentihUI")
    if existing then existing:Destroy() end
    local coreGuiExisting = pcall(function()
        local core = game:GetService("CoreGui"):FindFirstChild("ZentihUI")
        if core then core:Destroy() end
    end)
    safeMakeFolder(configFolder)

    local ScreenGui = create("ScreenGui", {
        Name = "ZentihUI", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
    })
    -- Prefer CoreGui: it survives character respawns cleanly and isn't
    -- cleared by ResetOnSpawn-style logic some games run on PlayerGui.
    -- Some executors block CoreGui access, so fall back to PlayerGui.
    local parentedToCoreGui = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not parentedToCoreGui then
        ScreenGui.Parent = PlayerGui
    end

    local Main = create("Frame", {
        Name = "Main", Size = UDim2.fromOffset(760, 560),
        Position = UDim2.new(0.5, -380, 0.5, -280),
        BackgroundColor3 = Theme.Background, BackgroundTransparency = WINDOW_TRANSPARENCY, BorderSizePixel = 0,
        ClipsDescendants = true, Visible = true, ZIndex = 1,
        Parent = ScreenGui,
    }, { corner(R.Window), stroke(Theme.Stroke, 1) })

    local Connections = {}
    local function track(conn) Connections[#Connections + 1] = conn; PerformanceManager.ConnectionCreated(); return conn end

    do
        local dragging, dragStart, startPos
        track(Main.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Main.Position
            end
        end))
        track(UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end))
        track(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end))
    end

    --// Resize handle — bottom-left corner grip, drag to resize the whole
    -- window. Sidebar/Content/Overlay are all sized with a Scale component
    -- relative to Main, so they follow automatically; only Main.Size needs
    -- to change here. Min size keeps the sidebar/content usable; max size
    -- keeps it from growing past a sane bound.
    local ResizeGrip = create("TextButton", {
        Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
        Size = UDim2.fromOffset(22, 22), Position = UDim2.new(0, 0, 1, -22),
        ZIndex = 5, Parent = Main,
    })
    create("Frame", {
        Size = UDim2.fromOffset(12, 2), Position = UDim2.fromOffset(5, 15),
        Rotation = 45, BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0,
        ZIndex = 5, Parent = ResizeGrip,
    }, { corner(1) })
    create("Frame", {
        Size = UDim2.fromOffset(7, 2), Position = UDim2.fromOffset(10, 10),
        Rotation = 45, BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0,
        ZIndex = 5, Parent = ResizeGrip,
    }, { corner(1) })
    do
        local MIN_W, MIN_H, MAX_W, MAX_H = 560, 400, 1100, 820
        local resizing, resizeStart, startSize, startPos2
        track(ResizeGrip.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                resizeStart = input.Position
                startSize = Main.Size
                startPos2 = Main.Position
            end
        end))
        track(UserInputService.InputChanged:Connect(function(input)
            if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - resizeStart
                -- Dragging the bottom-LEFT corner: moving left/down grows the
                -- window, so width shrinks with +delta.X and grows with -delta.X;
                -- the left edge (Position.X) has to shift to keep the right
                -- edge pinned in place, same idea Windows/macOS use for corner grips.
                local newW = math.clamp(startSize.X.Offset - delta.X, MIN_W, MAX_W)
                local newH = math.clamp(startSize.Y.Offset + delta.Y, MIN_H, MAX_H)
                local actualDeltaW = startSize.X.Offset - newW
                Main.Size = UDim2.new(startSize.X.Scale, newW, startSize.Y.Scale, newH)
                Main.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + actualDeltaW,
                    startPos2.Y.Scale, startPos2.Y.Offset)
            end
        end))
        track(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = false
            end
        end))
    end

    --// Top bar
    local TopBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = Theme.TopBar,
        BackgroundTransparency = WINDOW_TRANSPARENCY,
        BorderSizePixel = 0, ZIndex = 2, Parent = Main,
    })
    create("UIStroke", { Color = Theme.Stroke, Thickness = 1 }).Parent = TopBar

    create("TextLabel", {
        Text = title, Font = Enum.Font.GothamBold, TextSize = 15,
        TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 12),
        Size = UDim2.fromOffset(400, 18), ZIndex = 2, Parent = TopBar,
    })
    create("TextLabel", {
        Text = subtitle, Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 31),
        Size = UDim2.fromOffset(400, 16), ZIndex = 2, Parent = TopBar,
    })

    local function ctrlButton(text, xOffset, hoverColor, callback)
        local btn = create("TextButton", {
            Text = text, Font = Enum.Font.GothamBold, TextSize = 13,
            TextColor3 = Theme.TextSecondary, BackgroundColor3 = Theme.Card,
            AutoButtonColor = false, Size = UDim2.fromOffset(30, 30),
            Position = UDim2.new(1, xOffset, 0, 15), ZIndex = 2, Parent = TopBar,
        }, { corner(R.CtrlBtn), stroke(Theme.Stroke, 1) })
        track(btn.MouseEnter:Connect(function() tween(btn, { BackgroundColor3 = hoverColor }) end))
        track(btn.MouseLeave:Connect(function() tween(btn, { BackgroundColor3 = Theme.Card }) end))
        track(btn.MouseButton1Click:Connect(callback))
        return btn
    end

    local minimized, maximized = false, false
    local restoreSize, restorePos = Main.Size, Main.Position

    ctrlButton("_", -116, Theme.CardHover, function()
        minimized = not minimized
        if minimized then
            restoreSize = Main.Size
            tween(Main, { Size = UDim2.fromOffset(Main.AbsoluteSize.X, 60) }, 0.15)
        else
            tween(Main, { Size = maximized and UDim2.new(1, -40, 1, -40) or restoreSize }, 0.15)
        end
    end)
    ctrlButton("[ ]", -78, Theme.CardHover, function()
        if minimized then return end
        maximized = not maximized
        if maximized then
            restoreSize, restorePos = Main.Size, Main.Position
            tween(Main, { Size = UDim2.new(1, -40, 1, -40), Position = UDim2.new(0, 20, 0, 20) }, 0.15)
        else
            tween(Main, { Size = restoreSize, Position = restorePos }, 0.15)
        end
    end)
    ctrlButton("X", -40, Theme.Error, function() ScreenGui:Destroy() end)

    --// Sidebar — fixed positions, no UIListLayout dependency
    local Sidebar = create("Frame", {
        Size = UDim2.new(0, 180, 1, -60), Position = UDim2.new(0, 0, 0, 60),
        BackgroundColor3 = Theme.Sidebar, BackgroundTransparency = WINDOW_TRANSPARENCY,
        BorderSizePixel = 0,
        ClipsDescendants = false, ZIndex = 2, Parent = Main,
    })
    create("Frame", {
        Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Theme.Stroke, BorderSizePixel = 0, ZIndex = 2, Parent = Sidebar,
    })

    local TAB_LIST_TOP = 14 -- y-offset where the first tab button starts

    --// Content
    local Content = create("Frame", {
        Size = UDim2.new(1, -180, 1, -60), Position = UDim2.new(0, 180, 0, 60),
        BackgroundColor3 = Theme.Background, BackgroundTransparency = 1, BorderSizePixel = 0,
        ZIndex = 1, Parent = Main,
    })

    local NotifyHolder = create("Frame", {
        AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.fromOffset(300, 400), BackgroundTransparency = 1,
        ZIndex = 50, Parent = ScreenGui,
    })
    create("UIListLayout", {
        Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
    }).Parent = NotifyHolder

    --// Overlay: dedicated top-most layer for popouts (dropdown lists etc.)
    -- Cards inside Page are drawn in sibling order, so a popout parented to
    -- one Card can end up visually underneath a later Card at the same
    -- ZIndex. Everything that needs to float above all cards belongs here
    -- instead, positioned by converting the anchor's AbsolutePosition into
    -- Overlay-local coordinates.
    local Overlay = create("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        ClipsDescendants = true, ZIndex = 30, Parent = Main,
    })

    -- Invisible full-window catcher that sits just under any open popout
    -- (ZIndex 19, below a popout's own 20/21) so a click anywhere outside
    -- the popout — but still inside the window — closes it immediately,
    -- without needing to click a specific option or press Escape. Hidden
    -- whenever no panel is open, shown by showClickCatcher()/hidden by
    -- hideClickCatcher() which every popout's open/close already calls.
    local ClickOutsideCatcher = create("TextButton", {
        Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 19, Parent = Overlay,
    })
    ClickOutsideCatcher.MouseButton1Click:Connect(function()
        closeAllPanelsExcept(nil)
    end)

    -- Registries so transparency can be adjusted live at runtime via
    -- Window:SetTransparency(...) instead of being baked in at creation.
    local TransparencyRegistry = { Window = {}, Card = {}, Panel = {} }
    TransparencyRegistry.Window[#TransparencyRegistry.Window + 1] = Main
    TransparencyRegistry.Window[#TransparencyRegistry.Window + 1] = Sidebar
    TransparencyRegistry.Window[#TransparencyRegistry.Window + 1] = TopBar

    --// Floating toggle bubble — a small draggable circle docked to the
    -- screen edge that shows/hides the whole window. Lets the player bring
    -- the GUI back after closing/hiding it, without needing to re-run the
    -- script. Starts on the right edge, vertically centered.
    local ToggleBubble = create("TextButton", {
        Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(48, 48),
        Position = UDim2.new(1, -64, 0.5, -24),
        BackgroundColor3 = Theme.Card, BackgroundTransparency = 0,
        ClipsDescendants = true, ZIndex = 100, Parent = ScreenGui,
    }, { corner(999), stroke(Theme.Stroke, 1) })
    if config.ToggleIcon then
        -- Custom image (rbxassetid://...) instead of the drawn eye icon.
        -- Falls back to the drawn icon automatically if the image fails
        -- to load (e.g. a bad/removed asset ID), so the button is never
        -- left blank.
        local ImageIcon = create("ImageLabel", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Image = config.ToggleIcon, ScaleType = Enum.ScaleType.Fit,
            ZIndex = 100, Parent = ToggleBubble,
        })
        local loadedOk = false
        pcall(function() loadedOk = ImageIcon.IsLoaded end)
        task.delay(2, function()
            if ImageIcon.Parent and not ImageIcon.IsLoaded then
                local FallbackIcon = create("Frame", {
                    Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(15, 15),
                    BackgroundTransparency = 1, ZIndex = 100, Parent = ToggleBubble,
                })
                drawIcon("eye", FallbackIcon, Theme.TextPrimary)
                ImageIcon.Visible = false
            end
        end)
    else
        local ToggleIcon = create("Frame", {
            Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(15, 15),
            BackgroundTransparency = 1, ZIndex = 100, Parent = ToggleBubble,
        })
        drawIcon("eye", ToggleIcon, Theme.TextPrimary)
    end

    do
        local dragging, dragStart, startPos, moved
        track(ToggleBubble.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                moved = false
                dragStart = input.Position
                startPos = ToggleBubble.Position
            end
        end))
        track(UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                if delta.Magnitude > 4 then moved = true end
                ToggleBubble.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end))
        track(UserInputService.InputEnded:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                dragging = false
                if not moved then
                    Main.Visible = not Main.Visible
                end
            end
        end))
    end

    local Window = setmetatable({
        ScreenGui = ScreenGui, Main = Main, Sidebar = Sidebar, Content = Content,
        NotifyHolder = NotifyHolder, ConfigFolder = configFolder, Overlay = Overlay,
        Tabs = {}, Flags = {}, _flagSetters = {}, _tabOrder = 0,
        _connections = Connections, _tabListTop = TAB_LIST_TOP,
        _transparency = TransparencyRegistry,
        _windowAlpha = WINDOW_TRANSPARENCY, _cardAlpha = CARD_TRANSPARENCY, _panelAlpha = PANEL_TRANSPARENCY,
        ToggleBubble = ToggleBubble, CurrentTheme = "Original",
        ClickOutsideCatcher = ClickOutsideCatcher,
        State = newStateManager(), Debug = DebugManager,
        Performance = PerformanceManager, ErrorHandler = ErrorHandler, Input = InputManager,
    }, Zentih)

    PreviousWindowConnections = Connections

    return Window
end

-- Adjust the GUI's glass transparency live. Any argument left nil keeps
-- that layer's current value. windowAlpha covers the main window frame,
-- sidebar and topbar; cardAlpha covers element cards; panelAlpha covers
-- dropdown/combobox/multidropdown popout lists.
function Zentih:SetTransparency(windowAlpha, cardAlpha, panelAlpha)
    self._windowAlpha = windowAlpha or self._windowAlpha
    self._cardAlpha = cardAlpha or self._cardAlpha
    self._panelAlpha = panelAlpha or self._panelAlpha

    for _, inst in ipairs(self._transparency.Window) do
        pcall(function() inst.BackgroundTransparency = self._windowAlpha end)
    end
    for _, inst in ipairs(self._transparency.Card) do
        pcall(function() inst.BackgroundTransparency = self._cardAlpha end)
    end
    for _, inst in ipairs(self._transparency.Panel) do
        pcall(function() inst.BackgroundTransparency = self._panelAlpha end)
    end
end

-- Available theme names: Original, Black, CrimsonNight, OceanTeal.
-- Switches every tracked element's color live, no restart needed. Any
-- ThemedInstances entry whose Instance was destroyed (element removed) is
-- silently skipped and pruned.
function Zentih:SetTheme(name)
    local preset = ThemePresets[name]
    if not preset then return false end

    for key, value in pairs(preset) do Theme[key] = value end
    rebuildColorKeyOf()

    local alive = {}
    for _, entry in ipairs(ThemedInstances) do
        if entry.inst.Parent then
            local newColor = Theme[entry.key]
            if newColor then
                pcall(function() tween(entry.inst, { [entry.prop] = newColor }, 0.2) end)
            end
            alive[#alive + 1] = entry
        end
    end
    ThemedInstances = alive

    self.CurrentTheme = name
    return true
end

--// Notifications ------------------------------------------------------
function Zentih:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 4

    local Toast = create("Frame", {
        Size = UDim2.fromOffset(280, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Card, BackgroundTransparency = 1,
        ZIndex = 50, Parent = self.NotifyHolder,
    }, { corner(R.Card), stroke(Theme.Stroke, 1) })
    create("UIPadding", {
        PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
    }).Parent = Toast

    local AccentBar = create("Frame", {
        Size = UDim2.new(0, 3, 1, 0), BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 1, ZIndex = 50, Parent = Toast,
    }, { corner(2) })

    local TitleLabel = create("TextLabel", {
        Text = title, Font = Enum.Font.GothamBold, TextSize = 13,
        TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1, BackgroundTransparency = 1, ZIndex = 50,
        Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -10, 0, 18),
        Parent = Toast,
    })
    local ContentLabel = create("TextLabel", {
        Text = content, Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true, TextTransparency = 1, BackgroundTransparency = 1, ZIndex = 50,
        Position = UDim2.fromOffset(10, 20), Size = UDim2.new(1, -10, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, Parent = Toast,
    })

    tween(Toast, { BackgroundTransparency = 0 }, 0.2)
    tween(AccentBar, { BackgroundTransparency = 0 }, 0.2)
    tween(TitleLabel, { TextTransparency = 0 }, 0.2)
    tween(ContentLabel, { TextTransparency = 0 }, 0.2)

    task.delay(duration, function()
        if not Toast.Parent then return end
        tween(Toast, { BackgroundTransparency = 1 }, 0.2)
        tween(AccentBar, { BackgroundTransparency = 1 }, 0.2)
        tween(TitleLabel, { TextTransparency = 1 }, 0.2)
        tween(ContentLabel, { TextTransparency = 1 }, 0.2)
        task.wait(0.22)
        Toast:Destroy()
    end)
end

--// Popup (modal dialog) -------------------------------------------------
function Zentih:CreatePopup(config)
    -- A modal card over a dimmed backdrop covering the whole window.
    -- Use for a confirmation, a decision with buttons, or a changelog.
    -- Returns a handle with :Close() to dismiss it early from code.
    config = config or {}
    local title = config.Title or "Popup"
    local content = config.Content or ""
    local buttons = config.Buttons or { { Title = "OK", Callback = nil } }

    local Backdrop = create("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1, ZIndex = 90, Parent = self.Main,
    })
    local Card = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.48),
        Size = UDim2.fromOffset(320, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Card, BackgroundTransparency = 1,
        ZIndex = 91, Parent = Backdrop,
    }, { corner(R.Card), stroke(Theme.Stroke, 1) })
    create("UIPadding", {
        PaddingTop = UDim.new(0, 18), PaddingBottom = UDim.new(0, 18),
        PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18),
    }).Parent = Card
    create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }).Parent = Card

    create("TextLabel", {
        Text = title, Font = Enum.Font.GothamBold, TextSize = 16,
        TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, ZIndex = 91, Size = UDim2.new(1, 0, 0, 22),
        LayoutOrder = 1, Parent = Card,
    })
    create("TextLabel", {
        Text = content, Font = Enum.Font.Gotham, TextSize = 13,
        TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true, BackgroundTransparency = 1, ZIndex = 91,
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 2, Parent = Card,
    })

    local ButtonRow = create("Frame", {
        Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1,
        ZIndex = 91, LayoutOrder = 3, Parent = Card,
    })
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder,
    }).Parent = ButtonRow

    local function close()
        tween(Backdrop, { BackgroundTransparency = 1 }, 0.15)
        tween(Card, { BackgroundTransparency = 1 }, 0.15)
        task.delay(0.16, function() if Backdrop.Parent then Backdrop:Destroy() end end)
    end

    for i, btnCfg in ipairs(buttons) do
        local Btn = create("TextButton", {
            Text = btnCfg.Title or "OK", Font = Enum.Font.GothamMedium, TextSize = 13,
            TextColor3 = Theme.TextPrimary, AutoButtonColor = false,
            BackgroundColor3 = Theme.CardHover, Size = UDim2.fromOffset(90, 36),
            ZIndex = 91, LayoutOrder = i, Parent = ButtonRow,
        }, { corner(R.CtrlBtn) })
        Btn.MouseButton1Click:Connect(function()
            if btnCfg.Callback then pcall(btnCfg.Callback) end
            close()
        end)
    end

    tween(Backdrop, { BackgroundTransparency = 0.5 }, 0.15)
    tween(Card, { BackgroundTransparency = 0 }, 0.15)

    return { Close = close }
end


function Zentih:ShowLoading(config)
    config = config or {}
    local title = config.Title or "Loading"
    local subtitle = config.Subtitle or ""
    local duration = config.Duration or 1.5
    self.Main.Visible = false

    local Overlay = create("Frame", {
        Size = UDim2.fromOffset(760, 560), Position = UDim2.new(0.5, -380, 0.5, -280),
        BackgroundColor3 = Theme.Background, ZIndex = 90, Parent = self.ScreenGui,
    }, { corner(R.Window), stroke(Theme.Stroke, 1) })

    create("TextLabel", {
        Text = title, Font = Enum.Font.GothamBold, TextSize = 20,
        TextColor3 = Theme.TextPrimary, BackgroundTransparency = 1, ZIndex = 90,
        Position = UDim2.new(0.5, -150, 0.5, -30), Size = UDim2.fromOffset(300, 24),
        TextXAlignment = Enum.TextXAlignment.Center, Parent = Overlay,
    })
    create("TextLabel", {
        Text = subtitle, Font = Enum.Font.Gotham, TextSize = 13,
        TextColor3 = Theme.TextSecondary, BackgroundTransparency = 1, ZIndex = 90,
        Position = UDim2.new(0.5, -150, 0.5, -4), Size = UDim2.fromOffset(300, 18),
        TextXAlignment = Enum.TextXAlignment.Center, Parent = Overlay,
    })
    local Track = create("Frame", {
        Size = UDim2.fromOffset(240, 6), Position = UDim2.new(0.5, -120, 0.5, 26),
        BackgroundColor3 = Theme.SliderTrack, ZIndex = 90, Parent = Overlay,
    }, { corner(3) })
    local Fill = create("Frame", {
        Size = UDim2.fromOffset(0, 6), BackgroundColor3 = Theme.Accent, ZIndex = 90, Parent = Track,
    }, { corner(3) })
    tween(Fill, { Size = UDim2.fromOffset(240, 6) }, duration)

    task.delay(duration, function()
        Overlay:Destroy()
        self.Main.Visible = true
    end)
end

--// Config Save / Load ---------------------------------------------------
function Zentih:GetFlag(name)
    -- Convenience getter for any element created with a Flag — returns its
    -- current value without needing to keep the element's own handle around.
    local setter = self._flagSetters[name]
    if not setter then return nil end
    return setter.get()
end

function Zentih:SaveConfig(name)
    name = name or "default"
    local data = {}
    for flag, getValue in pairs(self._flagSetters) do data[flag] = getValue.get() end
    local ok = safeWritefile(self.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    self:Notify({
        Title = ok and "Config Saved" or "Save Failed",
        Content = ok and ("Saved as \"" .. name .. "\"") or "Executor does not support writefile",
        Duration = 3,
    })
    return ok
end

function Zentih:LoadConfig(name)
    name = name or "default"
    local raw = safeReadfile(self.ConfigFolder .. "/" .. name .. ".json")
    if not raw then
        self:Notify({ Title = "Load Failed", Content = "No saved config named \"" .. name .. "\"", Duration = 3 })
        return false
    end
    local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok then
        self:Notify({ Title = "Load Failed", Content = "Config file is corrupted", Duration = 3 })
        return false
    end
    for flag, value in pairs(data) do
        local setter = self._flagSetters[flag]
        if setter then setter.set(value) end
    end
    self:Notify({ Title = "Config Loaded", Content = "Loaded \"" .. name .. "\"", Duration = 3 })
    return true
end

--// Config — extended operations --------------------------------------------
-- Builds on SaveConfig/LoadConfig above (which already handle every
-- element type with a Flag: Toggle, Slider, Dropdown, Input, ColorPicker,
-- Keybind, Theme is handled separately via SetTheme/CurrentTheme).

function Zentih:ListConfigs()
    local out = {}
    for _, path in ipairs(safeListFiles(self.ConfigFolder)) do
        local name = path:match("([^/\\]+)%.json$")
        -- Exclude the states/ subfolder's files and the autoload index —
        -- ListConfigs should only return element-Flag configs.
        if name and not path:find("/states/") and not path:find("\\states\\") then
            out[#out + 1] = name
        end
    end
    table.sort(out)
    return out
end

function Zentih:DeleteConfig(name, confirmed)
    if not confirmed then
        self:CreatePopup({
            Title = "Delete config?",
            Content = "This deletes \"" .. tostring(name) .. "\" permanently. This can't be undone.",
            Buttons = {
                { Title = "Cancel" },
                { Title = "Delete", Callback = function() self:DeleteConfig(name, true) end },
            },
        })
        return nil
    end
    local path = self.ConfigFolder .. "/" .. name .. ".json"
    if not safeIsFile(path) then
        self:Notify({ Title = "Delete Failed", Content = "No config named \"" .. name .. "\"", Duration = 3 })
        return false
    end
    local ok = safeDeleteFile(path)
    self:Notify({
        Title = ok and "Config Deleted" or "Delete Failed",
        Content = ok and (name .. ".json") or "Executor does not support delfile",
        Duration = 3,
    })
    return ok
end

function Zentih:RenameConfig(oldName, newName)
    local oldPath = self.ConfigFolder .. "/" .. oldName .. ".json"
    local raw = safeReadfile(oldPath)
    if not raw then
        self:Notify({ Title = "Rename Failed", Content = "No config named \"" .. oldName .. "\"", Duration = 3 })
        return false
    end
    local newPath = self.ConfigFolder .. "/" .. newName .. ".json"
    if safeIsFile(newPath) then
        self:Notify({ Title = "Rename Failed", Content = "\"" .. newName .. "\" already exists", Duration = 3 })
        return false
    end
    local writeOk = safeWritefile(newPath, raw)
    if not writeOk then
        self:Notify({ Title = "Rename Failed", Content = "Executor does not support writefile", Duration = 3 })
        return false
    end
    safeDeleteFile(oldPath) -- best-effort; new file already exists either way
    self:Notify({ Title = "Config Renamed", Content = oldName .. " -> " .. newName, Duration = 3 })
    return true
end

function Zentih:DuplicateConfig(name, newName)
    local raw = safeReadfile(self.ConfigFolder .. "/" .. name .. ".json")
    if not raw then
        self:Notify({ Title = "Duplicate Failed", Content = "No config named \"" .. name .. "\"", Duration = 3 })
        return false
    end
    local newPath = self.ConfigFolder .. "/" .. newName .. ".json"
    if safeIsFile(newPath) then
        self:Notify({ Title = "Duplicate Failed", Content = "\"" .. newName .. "\" already exists", Duration = 3 })
        return false
    end
    local ok = safeWritefile(newPath, raw)
    self:Notify({
        Title = ok and "Config Duplicated" or "Duplicate Failed",
        Content = ok and (name .. " -> " .. newName) or "Executor does not support writefile",
        Duration = 3,
    })
    return ok
end

-- Resets every Flag'd element back to whatever value it was created with
-- (its original config.Default), and optionally also deletes the named
-- config file from disk. Elements that don't support reset (no default
-- captured at creation) are skipped — this reports accurately what
-- happened rather than silently pretending everything was reset.
function Zentih:ResetConfig(name, alsoDeleteFile)
    local resetCount, skippedCount = 0, 0
    for flag, setter in pairs(self._flagSetters) do
        if setter.reset then
            setter.reset()
            resetCount += 1
        else
            skippedCount += 1
        end
    end
    if alsoDeleteFile and name then
        safeDeleteFile(self.ConfigFolder .. "/" .. name .. ".json")
    end
    self:Notify({
        Title = "Config Reset",
        Content = skippedCount == 0
            and (resetCount .. " element(s) reset to defaults")
            or (resetCount .. " reset, " .. skippedCount .. " element(s) don't support reset"),
        Duration = 3,
    })
end

-- Returns the raw JSON string for a config so the host script can display
-- it, copy it to clipboard (if the executor supports setclipboard), or
-- write it somewhere else entirely.
function Zentih:ExportConfig(name)
    local raw = safeReadfile(self.ConfigFolder .. "/" .. name .. ".json")
    if not raw then
        self:Notify({ Title = "Export Failed", Content = "No config named \"" .. name .. "\"", Duration = 3 })
        return nil
    end
    return raw
end

-- Imports a raw JSON string (e.g. pasted by the player, or from
-- ExportConfig on another device) as a new named config file, then
-- optionally loads it immediately.
function Zentih:ImportConfig(name, jsonString, loadImmediately)
    local ok, data = pcall(function() return HttpService:JSONDecode(jsonString) end)
    if not ok or type(data) ~= "table" then
        self:Notify({ Title = "Import Failed", Content = "Invalid config data", Duration = 3 })
        return false
    end
    local writeOk = safeWritefile(self.ConfigFolder .. "/" .. name .. ".json", jsonString)
    if not writeOk then
        self:Notify({ Title = "Import Failed", Content = "Executor does not support writefile", Duration = 3 })
        return false
    end
    self:Notify({ Title = "Config Imported", Content = name .. ".json", Duration = 3 })
    if loadImmediately then self:LoadConfig(name) end
    return true
end

-- AutoSaveConfig(name, intervalSeconds): saves the named config on a
-- repeating timer using task.spawn (not a tight loop) until
-- StopAutoSaveConfig() is called. Safe to call more than once — starting
-- again with a new name/interval replaces the previous timer.
function Zentih:AutoSaveConfig(name, intervalSeconds)
    self:StopAutoSaveConfig()
    intervalSeconds = intervalSeconds or 30
    self._autoSaveRunning = true
    task.spawn(function()
        while self._autoSaveRunning do
            task.wait(intervalSeconds)
            if not self._autoSaveRunning then break end
            local data = {}
            for flag, getValue in pairs(self._flagSetters) do data[flag] = getValue.get() end
            safeWritefile(self.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
        end
    end)
end

function Zentih:StopAutoSaveConfig()
    self._autoSaveRunning = false
end

--// Script State ------------------------------------------------------------
-- Distinct from SaveConfig/LoadConfig (which only saves GUI element
-- Flags): this saves whatever your own game code puts into Window.State
-- (StateManager) — wave number, selected tower, currency, anything. Real
-- filesystem operations throughout (listfiles/isfile/delfile), each
-- guarded so a missing executor function degrades to a clear Notify
-- instead of throwing.
--
-- Files live at <ConfigFolder>/states/<name>.json. Must create a named
-- state file with :CreateStateFile(name) before :SaveState(name) will
-- write to it — this matches the spec's "ต้องสร้างไฟล์ก่อน" requirement
-- and stops a typo'd name from silently creating an untracked file.

function Zentih:CreateStateFile(name)
    if not name or name == "" then
        self:Notify({ Title = "Create Failed", Content = "State file needs a name", Duration = 3 })
        return false
    end
    local folder = self.ConfigFolder .. "/states"
    safeMakeFolder(self.ConfigFolder)
    safeMakeFolder(folder)
    local path = folder .. "/" .. name .. ".json"
    if safeIsFile(path) then
        self:Notify({ Title = "Already Exists", Content = "State file \"" .. name .. "\" already exists", Duration = 3 })
        return false
    end
    local ok = safeWritefile(path, HttpService:JSONEncode({}))
    if ok then
        self._stateFiles = self._stateFiles or {}
        self._stateFiles[name] = { lastSave = nil, lastLoad = nil, autoLoad = false }
        self:Notify({ Title = "State File Created", Content = name .. ".json", Duration = 3 })
    else
        self:Notify({ Title = "Create Failed", Content = "Executor does not support writefile", Duration = 3 })
    end
    return ok
end

-- Lists every state file that actually exists on disk (not just ones
-- created this session) — real filesystem read, not a cached guess.
function Zentih:ListStateFiles()
    local folder = self.ConfigFolder .. "/states"
    local out = {}
    for _, path in ipairs(safeListFiles(folder)) do
        local name = path:match("([^/\\]+)%.json$")
        if name then out[#out + 1] = name end
    end
    table.sort(out)
    return out
end

function Zentih:SaveState(name, stateManager)
    name = name or "default"
    local folder = self.ConfigFolder .. "/states"
    local path = folder .. "/" .. name .. ".json"
    if not safeIsFile(path) then
        self:Notify({
            Title = "Save Failed",
            Content = "No state file \"" .. name .. "\" — create it first",
            Duration = 3,
        })
        return false
    end
    local sm = stateManager or self.State
    local data = sm.GetAll()
    local ok = safeWritefile(path, HttpService:JSONEncode(data))
    self._stateFiles = self._stateFiles or {}
    self._stateFiles[name] = self._stateFiles[name] or {}
    if ok then
        self._stateFiles[name].lastSave = os.time()
        self:Notify({ Title = "State Saved", Content = name .. ".json", Duration = 3 })
    else
        self:Notify({ Title = "Save Failed", Content = "Executor does not support writefile", Duration = 3 })
    end
    return ok
end

-- LoadState guards against loading the same file twice in a row unless
-- force=true is passed — matches the spec's "ป้องกันโหลดซ้ำ" requirement.
-- Applies the saved data onto stateManager (defaults to Window.State) via
-- Set(), so every Subscribe()'d listener fires normally.
function Zentih:LoadState(name, stateManager, force)
    name = name or "default"
    self._stateFiles = self._stateFiles or {}
    local record = self._stateFiles[name]
    if record and record.loading and not force then
        self:Notify({ Title = "Already Loading", Content = "\"" .. name .. "\" is already being loaded", Duration = 3 })
        return false
    end

    local path = self.ConfigFolder .. "/states/" .. name .. ".json"
    local raw = safeReadfile(path)
    if not raw then
        self:Notify({ Title = "Load Failed", Content = "No state file named \"" .. name .. "\"", Duration = 3 })
        return false
    end
    local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or type(data) ~= "table" then
        self:Notify({ Title = "Load Failed", Content = "State file is corrupted", Duration = 3 })
        return false
    end

    self._stateFiles[name] = self._stateFiles[name] or {}
    self._stateFiles[name].loading = true
    local sm = stateManager or self.State
    for key, value in pairs(data) do sm.Set(key, value) end
    self._stateFiles[name].loading = false
    self._stateFiles[name].lastLoad = os.time()

    self:Notify({ Title = "State Loaded", Content = "Loaded \"" .. name .. "\"", Duration = 3 })
    return true
end

-- LoadOnce: loads exactly one time per session even if called repeatedly
-- (e.g. from code that runs on every CharacterAdded). Second+ calls no-op
-- silently — no Notify spam, since this is meant to be safe to call from
-- a loop without the player noticing anything.
function Zentih:LoadStateOnce(name, stateManager)
    name = name or "default"
    self._loadedOnce = self._loadedOnce or {}
    if self._loadedOnce[name] then return false end
    self._loadedOnce[name] = true
    return self:LoadState(name, stateManager, true)
end

-- AutoLoad: marks a state file to load automatically the next time
-- ApplyAutoLoads() runs (call that once near the top of your script,
-- after CreateWindow). SetAutoLoad(name, false) turns it back off.
function Zentih:SetAutoLoad(name, enabled)
    self._stateFiles = self._stateFiles or {}
    self._stateFiles[name] = self._stateFiles[name] or {}
    self._stateFiles[name].autoLoad = enabled
    self:SaveAutoLoadFlags()
end

function Zentih:SaveAutoLoadFlags()
    local flags = {}
    for name, record in pairs(self._stateFiles or {}) do
        if record.autoLoad then flags[name] = true end
    end
    safeMakeFolder(self.ConfigFolder)
    safeWritefile(self.ConfigFolder .. "/autoload.json", HttpService:JSONEncode(flags))
end

-- Call once at startup to actually perform whichever state files were
-- previously marked with SetAutoLoad(name, true). Uses LoadOnce
-- semantics internally, so it's safe even if called more than once.
function Zentih:ApplyAutoLoads(stateManager)
    local raw = safeReadfile(self.ConfigFolder .. "/autoload.json")
    if not raw then return end
    local ok, flags = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or type(flags) ~= "table" then return end
    for name in pairs(flags) do
        self:LoadStateOnce(name, stateManager)
    end
end

-- Stop: cancels an in-progress load flag if your own code set one via a
-- custom flow, and clears the autoLoad flag for this name so
-- ApplyAutoLoads won't pick it up again next session.
function Zentih:StopAutoLoad(name)
    self:SetAutoLoad(name, false)
end

function Zentih:DeleteStateFile(name, confirmed)
    if not confirmed then
        self:CreatePopup({
            Title = "Delete state file?",
            Content = "This deletes \"" .. tostring(name) .. "\" permanently. This can't be undone.",
            Buttons = {
                { Title = "Cancel" },
                { Title = "Delete", Callback = function() self:DeleteStateFile(name, true) end },
            },
        })
        return nil -- awaiting confirmation; result comes via the popup callback
    end
    local path = self.ConfigFolder .. "/states/" .. name .. ".json"
    if not safeIsFile(path) then
        self:Notify({ Title = "Delete Failed", Content = "No state file named \"" .. name .. "\"", Duration = 3 })
        return false
    end
    local ok = safeDeleteFile(path)
    if ok then
        if self._stateFiles then self._stateFiles[name] = nil end
        self:Notify({ Title = "State Deleted", Content = name .. ".json", Duration = 3 })
    else
        self:Notify({ Title = "Delete Failed", Content = "Executor does not support delfile", Duration = 3 })
    end
    return ok
end

function Zentih:ClearAllStateFiles(confirmed)
    if not confirmed then
        self:CreatePopup({
            Title = "Delete ALL state files?",
            Content = "This deletes every saved state file permanently. This can't be undone.",
            Buttons = {
                { Title = "Cancel" },
                { Title = "Delete All", Callback = function() self:ClearAllStateFiles(true) end },
            },
        })
        return nil
    end
    local names = self:ListStateFiles()
    local failCount = 0
    for _, name in ipairs(names) do
        if not safeDeleteFile(self.ConfigFolder .. "/states/" .. name .. ".json") then
            failCount += 1
        end
    end
    self._stateFiles = {}
    self:Notify({
        Title = "Cleared",
        Content = failCount == 0 and (#names .. " state file(s) deleted")
            or (#names - failCount .. "/" .. #names .. " deleted, " .. failCount .. " failed"),
        Duration = 3,
    })
    return failCount == 0
end

-- Search across existing state file names (simple substring match) — for
-- wiring up a search box in a Config/State tab.
function Zentih:SearchStateFiles(query)
    local all = self:ListStateFiles()
    if not query or query == "" then return all end
    local needle = string.lower(query)
    local out = {}
    for _, name in ipairs(all) do
        if string.find(string.lower(name), needle, 1, true) then out[#out + 1] = name end
    end
    return out
end

-- GetStateFileStatus(name) -> { exists, lastSave, lastLoad, autoLoad } —
-- for a Status Dashboard row per file. Timestamps are os.time() (unix
-- seconds) from this session; nil if never saved/loaded this session
-- (the file may still exist on disk from a previous session).
function Zentih:GetStateFileStatus(name)
    local path = self.ConfigFolder .. "/states/" .. name .. ".json"
    local record = (self._stateFiles or {})[name] or {}
    return {
        exists = safeIsFile(path),
        lastSave = record.lastSave,
        lastLoad = record.lastLoad,
        autoLoad = record.autoLoad or false,
    }
end

function Zentih:Destroy()
    if self._connections then
        for _, conn in ipairs(self._connections) do
            pcall(function() conn:Disconnect() end)
            PerformanceManager.ConnectionDestroyed()
        end
        if PreviousWindowConnections == self._connections then PreviousWindowConnections = nil end
    end
    OpenPanels = {}
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

--// Tabs -------------------------------------------------------------------
-- Icon = a string name picked from the drawn-icon set below (not a raw
-- character — Roblox's built-in Gotham fonts can't render most symbols).
-- Available icons (18 total, also in Zentih.IconList): home, sword, save,
-- settings, input, dungeon, status, eye, star, gamepad, macro, map,
-- script, config, debug, tower, enemy, wave

function Zentih:CreateTab(config)
    config = config or {}
    local name = config.Name or "Tab"
    local icon = config.Icon or "home"

    self._tabOrder = self._tabOrder + 1
    local order = self._tabOrder
    local yPos = self._tabListTop + (order - 1) * 46

    local TabButton = create("TextButton", {
        Text = "", AutoButtonColor = false, BackgroundColor3 = Theme.Card,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Size = UDim2.new(1, -12, 0, 38), Position = UDim2.fromOffset(6, yPos),
        ZIndex = 3, Parent = self.Sidebar,
    }, { corner(R.CtrlBtn) })

    local AccentBar = create("Frame", {
        Size = UDim2.new(0, 3, 0, 18), Position = UDim2.new(0, 0, 0.5, -9),
        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
        BackgroundTransparency = 1, ZIndex = 3, Parent = TabButton,
    }, { corner(2) })

    local IconHolder = create("Frame", {
        Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(12, 10),
        BackgroundTransparency = 1, ZIndex = 3, Parent = TabButton,
    })
    drawIcon(icon, IconHolder, Theme.TextTab)

    local Label = create("TextLabel", {
        Text = name, Font = Enum.Font.GothamMedium, TextSize = 14,
        TextColor3 = Theme.TextTab, TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, ZIndex = 3, Position = UDim2.fromOffset(40, 0),
        Size = UDim2.new(1, -50, 1, 0), Parent = TabButton,
    })

    local BadgePill = create("Frame", {
        Size = UDim2.fromOffset(18, 16), Position = UDim2.new(1, -26, 0.5, -8),
        BackgroundColor3 = Theme.Accent, Visible = false, ZIndex = 3, Parent = TabButton,
    }, { corner(8) })
    local BadgeLabel = create("TextLabel", {
        Text = "", Font = Enum.Font.GothamBold, TextSize = 10,
        TextColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1,
        ZIndex = 3, Size = UDim2.fromScale(1, 1), Parent = BadgePill,
    })

    local Tab = { Page = nil, _order = 0, Window = self, Name = name, Button = TabButton, _active = false }

    self._connections[#self._connections + 1] = TabButton.MouseEnter:Connect(function()
        if not Tab._active then tween(TabButton, { BackgroundTransparency = 0.6 }, 0.15) end
    end)
    self._connections[#self._connections + 1] = TabButton.MouseLeave:Connect(function()
        if not Tab._active then tween(TabButton, { BackgroundTransparency = 1 }, 0.15) end
    end)

    local Page = create("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Stroke,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false, ZIndex = 1, Parent = self.Content,
    })
    create("UIPadding", {
        PaddingTop = UDim.new(0, 18), PaddingLeft = UDim.new(0, 22),
        PaddingRight = UDim.new(0, 22), PaddingBottom = UDim.new(0, 18),
    }).Parent = Page
    create("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }).Parent = Page

    -- Scrolling this tab's content closes any open dropdown/combobox/popout
    -- list. Popouts float in a fixed spot on Overlay (by design — they
    -- don't track their button), so if the player scrolls past the row
    -- that opened one, it would otherwise keep floating on screen and
    -- cover whatever they scrolled to. Closing it on scroll avoids that.
    self._connections[#self._connections + 1] = Page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        closeAllPanelsExcept(nil)
    end)

    Tab.Page = Page

    local function setActive(active)
        Tab._active = active
        tween(TabButton, { BackgroundTransparency = active and 0.5 or 1 }, 0.15)
        tween(AccentBar, { BackgroundTransparency = active and 0 or 1 }, 0.15)
        tween(Label, { TextColor3 = active and Theme.TextTabActive or Theme.TextTab }, 0.15)
        for _, child in ipairs(IconHolder:GetChildren()) do
            if child:IsA("Frame") then tween(child, { BackgroundColor3 = active and Theme.TextTabActive or Theme.TextTab }, 0.15) end
            if child:IsA("UIStroke") then tween(child, { Color = active and Theme.TextTabActive or Theme.TextTab }, 0.15) end
        end
        Label.Font = active and Enum.Font.GothamBold or Enum.Font.GothamMedium
        Page.Visible = active
    end

    TabButton.MouseButton1Click:Connect(function()
        closeAllPanelsExcept(nil)
        for _, t in pairs(self.Tabs) do t.setActive(false) end
        setActive(true)
    end)

    Tab.setActive = setActive
    Tab.SetBadge = function(_, text)
        if text == nil or text == "" then
            BadgePill.Visible = false
        else
            BadgePill.Visible = true
            BadgeLabel.Text = tostring(text)
            BadgePill.Size = UDim2.fromOffset(math.max(18, 10 + #tostring(text) * 7), 16)
        end
    end
    if config.Badge then Tab:SetBadge(config.Badge) end
    self.Tabs[#self.Tabs + 1] = Tab
    if #self.Tabs == 1 then setActive(true) end

    local function baseCard(order, height)
        local Card = create("Frame", {
            BackgroundColor3 = Theme.Card, BackgroundTransparency = CARD_TRANSPARENCY,
            Size = UDim2.new(1, 0, 0, height or 58),
            LayoutOrder = order, ZIndex = 1, Parent = Page,
        }, { corner(R.Card), stroke(Theme.Stroke, 1) })
        local reg = self._transparency
        reg.Card[#reg.Card + 1] = Card
        return Card
    end

    local function cardTexts(Card, title, desc, rightPad)
        create("TextLabel", {
            Text = title, Font = Enum.Font.GothamMedium, TextSize = 14,
            TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1, ZIndex = 1,
            Position = UDim2.fromOffset(16, desc ~= "" and 9 or 0),
            Size = UDim2.new(1, -(rightPad + 16), 0, desc ~= "" and 18 or 58),
            Parent = Card,
        })
        if desc and desc ~= "" then
            create("TextLabel", {
                Text = desc, Font = Enum.Font.Gotham, TextSize = 12,
                TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1, ZIndex = 1, Position = UDim2.fromOffset(16, 31),
                Size = UDim2.new(1, -(rightPad + 16), 0, 16), Parent = Card,
            })
        end
    end

    local function registerFlag(flag, getFn, setFn)
        if not flag then return end
        self._flagSetters[flag] = { get = getFn, set = setFn }
    end

    function Tab:CreateSection(name)
        self._order = self._order + 1
        create("TextLabel", {
            Text = name, Font = Enum.Font.GothamBold, TextSize = 19,
            TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 28),
            LayoutOrder = self._order, ZIndex = 1, Parent = Page,
        })
    end

    function Tab:CreateLabel(text)
        self._order = self._order + 1
        create("TextLabel", {
            Text = text, Font = Enum.Font.Gotham, TextSize = 13,
            TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18),
            LayoutOrder = self._order, ZIndex = 1, Parent = Page,
        })
    end

    function Tab:CreateDivider()
        self._order = self._order + 1
        create("Frame", {
            Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.Stroke,
            BorderSizePixel = 0, LayoutOrder = self._order, ZIndex = 1, Parent = Page,
        })
    end

    function Tab:CreateParagraph(config)
        config = config or {}
        local title, content = config.Title or "", config.Content or ""
        self._order = self._order + 1
        local Holder = create("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, LayoutOrder = self._order, ZIndex = 1, Parent = Page,
        })
        local y = 0
        if title ~= "" then
            create("TextLabel", {
                Text = title, Font = Enum.Font.GothamBold, TextSize = 14,
                TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18),
                ZIndex = 1, Parent = Holder,
            })
            y = 22
        end
        create("TextLabel", {
            Text = content, Font = Enum.Font.Gotham, TextSize = 13,
            TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true,
            BackgroundTransparency = 1, Position = UDim2.fromOffset(0, y),
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 1, Parent = Holder,
        })
    end

    function Tab:CreateProgressBar(config)
        config = config or {}
        local title = config.Title or "Progress"
        local min, max = config.Min or 0, config.Max or 100
        local default = math.clamp(config.Default or min, min, max)
        self._order = self._order + 1
        local Card = baseCard(self._order, 58)
        create("TextLabel", {
            Text = title, Font = Enum.Font.GothamMedium, TextSize = 14,
            TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1, ZIndex = 1, Position = UDim2.fromOffset(16, 8),
            Size = UDim2.new(1, -80, 0, 18), Parent = Card,
        })
        local ValueLabel = create("TextLabel", {
            Text = default .. "/" .. max, Font = Enum.Font.GothamMedium, TextSize = 12,
            TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1, ZIndex = 1, Position = UDim2.new(1, -76, 0, 8),
            Size = UDim2.fromOffset(60, 18), Parent = Card,
        })
        local Track = create("Frame", {
            Size = UDim2.new(1, -32, 0, 8), Position = UDim2.fromOffset(16, 34),
            BackgroundColor3 = Theme.SliderTrack, ZIndex = 1, Parent = Card,
        }, { corner(4) })
        local Fill = create("Frame", {
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = Theme.Accent, ZIndex = 1, Parent = Track,
        }, { corner(4) })
        return {
            Set = function(_, value)
                value = math.clamp(value, min, max)
                tween(Fill, { Size = UDim2.new((value - min) / (max - min), 0, 1, 0) }, 0.2)
                ValueLabel.Text = value .. "/" .. max
            end,
        }
    end

    function Tab:CreateStat(config)
        -- Read-only key/value display for live game data (kills, ping,
        -- currency, a boss/status name, etc). Calling :Set(value) briefly
        -- flashes the value text to show it changed, and if the value is
        -- numeric, shows the +/- delta from the previous value.
        --
        -- Hardened for real gameplay loops that call :Set() every frame or
        -- from RemoteEvent callbacks: :Set() never throws even if given an
        -- odd value (table, function, nil) or called after the tab/window
        -- was destroyed — it just silently no-ops instead of erroring out
        -- your update loop. Use :Get() to read the current value back.
        config = config or {}
        local title = config.Title or "Stat"
        local default = config.Default
        self._order = self._order + 1
        local Card = baseCard(self._order, 58)
        create("TextLabel", {
            Text = title, Font = Enum.Font.GothamMedium, TextSize = 14,
            TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1, ZIndex = 1, Position = UDim2.fromOffset(16, 0),
            Size = UDim2.new(1, -160, 1, 0), Parent = Card,
        })
        local ValueLabel = create("TextLabel", {
            Text = tostring(default ~= nil and default or "-"), Font = Enum.Font.GothamBold, TextSize = 14,
            TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1, ZIndex = 1, Position = UDim2.new(1, -140, 0, 0),
            Size = UDim2.fromOffset(100, 58), Parent = Card,
        })
        local DeltaLabel = create("TextLabel", {
            Text = "", Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1, ZIndex = 1, Position = UDim2.new(1, -36, 0, 0),
            Size = UDim2.fromOffset(36, 58), Parent = Card,
        })
        local lastValue = default

        local function doSet(value)
            if not ValueLabel.Parent then return end -- element was destroyed; no-op
            local displayText = tostring(value)
            if type(value) == "number" and type(lastValue) == "number" then
                local delta = value - lastValue
                if delta ~= 0 then
                    DeltaLabel.Text = (delta > 0 and "+" or "") .. tostring(delta)
                    DeltaLabel.TextColor3 = delta > 0 and Theme.Success or Theme.Error
                end
            else
                DeltaLabel.Text = ""
            end
            lastValue = value
            ValueLabel.Text = displayText
            ValueLabel.TextColor3 = Theme.Accent
            tween(ValueLabel, { TextColor3 = Theme.TextPrimary }, 0.4)
        end

        return {
            Set = function(_, value) pcall(doSet, value) end,
            Get = function(_) return lastValue end,
        }
    end

    function Tab:CreateToggle(config)
        config = config or {}
        local title, desc = config.Title or "Toggle", config.Desc or ""
        local default, callback = config.Default or false, config.Callback or function() end
        self._order = self._order + 1
        local Card = baseCard(self._order)
        cardTexts(Card, title, desc, 62)

        local Track = create("Frame", {
            Size = UDim2.fromOffset(44, 24), Position = UDim2.new(1, -60, 0.5, -12),
            BackgroundColor3 = default and Theme.Accent or Theme.ToggleOff, ZIndex = 1, Parent = Card,
        }, { corner(12) })
        local Knob = create("Frame", {
            Size = UDim2.fromOffset(18, 18),
            Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
            BackgroundColor3 = Theme.ToggleKnob, ZIndex = 1, Parent = Track,
        }, { corner(R.Knob) })

        local state = default
        local function render()
            tween(Track, { BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff }, 0.15)
            tween(Knob, { Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.15)
        end

        local ClickArea = create("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 1, Parent = Card })
        ClickArea.MouseButton1Click:Connect(function()
            state = not state
            render()
            pcall(callback, state)
        end)

        registerFlag(config.Flag, function() return state end, function(v) state = v; render(); pcall(callback, state) end)
        return { Set = function(_, v) state = v; render(); pcall(callback, state) end, Get = function() return state end }
    end

    function Tab:CreateButton(config)
        config = config or {}
        local title, desc = config.Title or "Button", config.Desc or ""
        local callback = config.Callback or function() end
        local expandable = config.Expandable
        self._order = self._order + 1
        local Card = baseCard(self._order)
        cardTexts(Card, title, desc, expandable and 40 or 20)

        if expandable then
            create("TextLabel", {
                Text = ">", Font = Enum.Font.GothamBold, TextSize = 20,
                TextColor3 = Theme.TextSecondary, BackgroundTransparency = 1, ZIndex = 1,
                Position = UDim2.new(1, -34, 0, 0), Size = UDim2.fromOffset(24, 58),
                Parent = Card,
            })
        end

        local ClickArea = create("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 1, Parent = Card })
        ClickArea.MouseEnter:Connect(function() tween(Card, { BackgroundColor3 = Theme.CardHover }) end)
        ClickArea.MouseLeave:Connect(function() tween(Card, { BackgroundColor3 = Theme.Card }) end)
        ClickArea.MouseButton1Click:Connect(callback)
        return Card
    end

    function Tab:CreateSlider(config)
        config = config or {}
        local title = config.Title or "Slider"
        local min, max = config.Min or 0, config.Max or 100
        local default = math.clamp(config.Default or min, min, max)
        local callback = config.Callback or function() end
        self._order = self._order + 1
        local Card = baseCard(self._order, 66)

        create("TextLabel", {
            Text = title, Font = Enum.Font.GothamMedium, TextSize = 14,
            TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1, ZIndex = 1, Position = UDim2.fromOffset(16, 10),
            Size = UDim2.new(1, -90, 0, 18), Parent = Card,
        })
        local ValueLabel = create("TextLabel", {
            Text = tostring(default), Font = Enum.Font.GothamMedium, TextSize = 13,
            TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1, ZIndex = 1, Position = UDim2.new(1, -66, 0, 10),
            Size = UDim2.fromOffset(50, 18), Parent = Card,
        })

        local Track = create("Frame", {
            Size = UDim2.new(1, -32, 0, 6), Position = UDim2.fromOffset(16, 40),
            BackgroundColor3 = Theme.SliderTrack, ZIndex = 1, Parent = Card,
        }, { corner(3) })
        local Fill = create("Frame", {
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = Theme.Accent, ZIndex = 1, Parent = Track,
        }, { corner(3) })
        local Knob = create("Frame", {
            Size = UDim2.fromOffset(14, 14),
            Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7),
            BackgroundColor3 = Theme.ToggleKnob, ZIndex = 1, Parent = Track,
        }, { corner(R.Knob) })

        local currentValue = default
        local dragging = false
        local function setFromAlpha(alpha)
            alpha = math.clamp(alpha, 0, 1)
            local value = math.floor(min + (max - min) * alpha + 0.5)
            currentValue = value
            Fill.Size = UDim2.new(alpha, 0, 1, 0)
            Knob.Position = UDim2.new(alpha, -7, 0.5, -7)
            ValueLabel.Text = tostring(value)
            pcall(callback, value)
        end
        Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromAlpha((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X)
            end
        end)
        self.Window._connections[#self.Window._connections + 1] = UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                setFromAlpha((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X)
            end
        end)
        self.Window._connections[#self.Window._connections + 1] = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        registerFlag(config.Flag, function() return currentValue end, function(v) setFromAlpha((v - min) / (max - min)) end)
        return { Set = function(_, v) setFromAlpha((v - min) / (max - min)) end }
    end

    function Tab:CreateDropdown(config)
        config = config or {}
        local title = config.Title or "Dropdown"
        local options = config.Options or {}
        local default = config.Default or options[1] or ""
        local callback = config.Callback or function() end
        self._order = self._order + 1
        local Card = baseCard(self._order, 58)
        cardTexts(Card, title, "", 156)

        local SelectBtn = create("TextButton", {
            Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(140, 34),
            Position = UDim2.new(1, -156, 0.5, -17), BackgroundColor3 = Theme.ToggleOff,
            ZIndex = 1, Parent = Card,
        }, { corner(R.Control), stroke(Theme.Stroke, 1) })
        local SelectedLabel = create("TextLabel", {
            Text = default, Font = Enum.Font.Gotham, TextSize = 13,
            TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1, ZIndex = 1, Position = UDim2.fromOffset(12, 0),
            Size = UDim2.new(1, -22, 1, 0), Parent = SelectBtn,
        })

        local POPOUT_W, POPOUT_H, ROW_H = 480, 380, 44
        local List = create("Frame", {
            Size = UDim2.fromOffset(POPOUT_W, 0), Position = UDim2.fromOffset(POPOUT_FIXED_X, POPOUT_FIXED_Y),
            BackgroundColor3 = Theme.Card, BackgroundTransparency = PANEL_TRANSPARENCY, ClipsDescendants = true, ZIndex = 20, Parent = self.Window.Overlay,
        }, { corner(R.Control) })
        do
            local reg = self.Window._transparency
            reg.Panel[#reg.Panel + 1] = List
        end
        local ListScroll = create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Stroke,
            CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = 20, Parent = List,
        })
        create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }).Parent = ListScroll

        local currentValue = default
        local open = false
        local function close()
            open = false
            tween(List, { Size = UDim2.fromOffset(POPOUT_W, 0) }, 0.12)
            self.Window.ClickOutsideCatcher.Visible = false
        end
        local function toggleOpen()
            if not open then closeAllPanelsExcept(close) end
            open = not open
            local target = open and POPOUT_H or 0
            tween(List, { Size = UDim2.fromOffset(POPOUT_W, target) }, 0.12)
            self.Window.ClickOutsideCatcher.Visible = open
        end
        registerPanel(close)
        local optAccents = {}
        for i, opt in ipairs(options) do
            local OptBtn = create("TextButton", {
                Text = "|  " .. opt, Font = Enum.Font.GothamMedium, TextSize = 14,
                TextColor3 = Theme.TextPrimary, AutoButtonColor = false,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundColor3 = Theme.CardHover, BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, ROW_H),
                LayoutOrder = i, ZIndex = 21, Parent = ListScroll,
            })
            create("UIPadding", { PaddingLeft = UDim.new(0, 14) }).Parent = OptBtn
            local Accent = create("Frame", {
                Size = UDim2.new(0, 3, 0, 18), Position = UDim2.new(0, 0, 0.5, -9),
                BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
                BackgroundTransparency = opt == default and 0 or 1,
                ZIndex = 21, Parent = OptBtn,
            }, { corner(2) })
            optAccents[opt] = Accent
            OptBtn.MouseEnter:Connect(function() tween(OptBtn, { BackgroundTransparency = 0 }) end)
            OptBtn.MouseLeave:Connect(function() tween(OptBtn, { BackgroundTransparency = 1 }) end)
            OptBtn.MouseButton1Click:Connect(function()
                currentValue = opt
                SelectedLabel.Text = opt
                for o, bar in pairs(optAccents) do
                    tween(bar, { BackgroundTransparency = (o == opt) and 0 or 1 }, 0.12)
                end
                close()
                pcall(callback, opt)
            end)
        end
        SelectBtn.MouseButton1Click:Connect(toggleOpen)

        registerFlag(config.Flag, function() return currentValue end, function(v) currentValue = v; SelectedLabel.Text = v; pcall(callback, v) end)
        return { Set = function(_, v) currentValue = v; SelectedLabel.Text = v; pcall(callback, v) end }
    end


    function Tab:CreateKeybind(config)
        config = config or {}
        local title = config.Title or "Keybind"
        local default = config.Default or Enum.KeyCode.E
        local callback = config.Callback or function() end
        self._order = self._order + 1
        local Card = baseCard(self._order, 58)
        cardTexts(Card, title, "", 100)

        local KeyBtn = create("TextButton", {
            Text = default.Name, Font = Enum.Font.GothamBold, TextSize = 12,
            TextColor3 = Theme.TextPrimary, AutoButtonColor = false,
            BackgroundColor3 = Theme.ToggleOff, Size = UDim2.fromOffset(80, 30),
            Position = UDim2.new(1, -96, 0.5, -15), ZIndex = 1, Parent = Card,
        }, { corner(R.Control) })

        local currentKey = default
        local listening = false
        KeyBtn.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            KeyBtn.Text = "..."
            local conn
            conn = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    KeyBtn.Text = input.KeyCode.Name
                    listening = false
                    conn:Disconnect()
                    pcall(callback, input.KeyCode)
                end
            end)
            self.Window._connections[#self.Window._connections + 1] = conn
        end)

        registerFlag(config.Flag,
            function() return currentKey.Name end,
            function(v) local kc = Enum.KeyCode[v]; if kc then currentKey = kc; KeyBtn.Text = kc.Name end end)
        return { Set = function(_, keyCode) currentKey = keyCode; KeyBtn.Text = keyCode.Name end }
    end

    function Tab:CreateInput(config)
        config = config or {}
        local title = config.Title or "Input"
        local placeholder = config.Placeholder or ""
        local callback = config.Callback or function() end
        self._order = self._order + 1
        local Card = baseCard(self._order, 58)
        cardTexts(Card, title, "", 160)

        local Box = create("TextBox", {
            Text = "", PlaceholderText = placeholder,
            Font = Enum.Font.Gotham, TextSize = 13,
            TextColor3 = Theme.TextPrimary, PlaceholderColor3 = Theme.TextSecondary,
            BackgroundColor3 = Theme.ToggleOff, ClearTextOnFocus = false,
            Size = UDim2.fromOffset(140, 32), Position = UDim2.new(1, -156, 0.5, -16),
            ZIndex = 1, Parent = Card,
        }, { corner(R.Control) })
        create("UIPadding", { PaddingLeft = UDim.new(0, 10) }).Parent = Box

        Box.FocusLost:Connect(function(enterPressed) pcall(callback, Box.Text, enterPressed) end)
        registerFlag(config.Flag, function() return Box.Text end, function(v) Box.Text = v end)
        return { Set = function(_, v) Box.Text = v end }
    end

    function Tab:CreateMultiDropdown(config)
        config = config or {}
        local title = config.Title or "Multi Dropdown"
        local options = config.Options or {}
        local defaults = config.Default or {}
        local callback = config.Callback or function() end

        local selected = {}
        for _, v in ipairs(defaults) do selected[v] = true end

        self._order = self._order + 1
        local Card = baseCard(self._order, 58)
        cardTexts(Card, title, "", 156)

        local function selectedText()
            local list = {}
            for opt in pairs(selected) do list[#list + 1] = opt end
            if #list == 0 then return "None selected" end
            return #list .. " selected"
        end

        local SelectBtn = create("TextButton", {
            Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(140, 34),
            Position = UDim2.new(1, -156, 0.5, -17), BackgroundColor3 = Theme.ToggleOff,
            ZIndex = 1, Parent = Card,
        }, { corner(R.Control), stroke(Theme.Stroke, 1) })
        local SelectedLabel = create("TextLabel", {
            Text = selectedText(), Font = Enum.Font.Gotham, TextSize = 13,
            TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1, ZIndex = 1, Position = UDim2.fromOffset(12, 0),
            Size = UDim2.new(1, -22, 1, 0), Parent = SelectBtn,
        })

        local POPOUT_W, POPOUT_H, ROW_H = 480, 380, 44
        local List = create("Frame", {
            Size = UDim2.fromOffset(POPOUT_W, 0), Position = UDim2.fromOffset(POPOUT_FIXED_X, POPOUT_FIXED_Y),
            BackgroundColor3 = Theme.Card, BackgroundTransparency = PANEL_TRANSPARENCY, ClipsDescendants = true, ZIndex = 20, Parent = self.Window.Overlay,
        }, { corner(R.Control) })
        do
            local reg = self.Window._transparency
            reg.Panel[#reg.Panel + 1] = List
        end
        local ListScroll = create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Stroke,
            CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = 20, Parent = List,
        })
        create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }).Parent = ListScroll

        local open = false
        local function close()
            open = false
            tween(List, { Size = UDim2.fromOffset(POPOUT_W, 0) }, 0.12)
            self.Window.ClickOutsideCatcher.Visible = false
        end
        local function toggleOpen()
            if not open then closeAllPanelsExcept(close) end
            open = not open
            local target = open and POPOUT_H or 0
            tween(List, { Size = UDim2.fromOffset(POPOUT_W, target) }, 0.12)
            self.Window.ClickOutsideCatcher.Visible = open
        end
        registerPanel(close)
        SelectBtn.MouseButton1Click:Connect(toggleOpen)

        for i, opt in ipairs(options) do
            local Row = create("TextButton", {
                Text = "", AutoButtonColor = false, BackgroundColor3 = Theme.CardHover,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, ROW_H), LayoutOrder = i, ZIndex = 21, Parent = ListScroll,
            })
            create("UIPadding", { PaddingLeft = UDim.new(0, 14) }).Parent = Row
            Row.MouseEnter:Connect(function() tween(Row, { BackgroundTransparency = 0 }) end)
            Row.MouseLeave:Connect(function() tween(Row, { BackgroundTransparency = 1 }) end)
            local Accent = create("Frame", {
                Size = UDim2.new(0, 3, 0, 18), Position = UDim2.new(0, 0, 0.5, -9),
                BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
                BackgroundTransparency = selected[opt] and 0 or 1,
                ZIndex = 21, Parent = Row,
            }, { corner(2) })
            local OptLabel = create("TextLabel", {
                Text = "|  " .. opt, Font = Enum.Font.GothamMedium, TextSize = 14,
                TextColor3 = selected[opt] and Theme.TextPrimary or Theme.TextSecondary,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1, ZIndex = 21, Size = UDim2.new(1, -14, 1, 0),
                Parent = Row,
            })
            Row.MouseButton1Click:Connect(function()
                selected[opt] = not selected[opt] or nil
                tween(Accent, { BackgroundTransparency = selected[opt] and 0 or 1 }, 0.12)
                OptLabel.TextColor3 = selected[opt] and Theme.TextPrimary or Theme.TextSecondary
                SelectedLabel.Text = selectedText()
                local list = {}
                for o in pairs(selected) do list[#list + 1] = o end
                pcall(callback, list)
            end)
        end

        registerFlag(config.Flag,
            function()
                local list = {}
                for o in pairs(selected) do list[#list + 1] = o end
                return list
            end,
            function(list)
                selected = {}
                for _, o in ipairs(list) do selected[o] = true end
                SelectedLabel.Text = selectedText()
            end)

        return {
            Get = function()
                local list = {}
                for o in pairs(selected) do list[#list + 1] = o end
                return list
            end,
        }
    end

    function Tab:CreateComboBox(config)
        -- Now visually unified with CreateDropdown: a plain select button + popout
        -- list (no editable search box), matching the reference dropdown style.
        config = config or {}
        local title = config.Title or "Combo Box"
        local options = config.Options or {}
        local default = config.Default or options[1] or ""
        local callback = config.Callback or function() end
        self._order = self._order + 1
        local Card = baseCard(self._order, 58)
        cardTexts(Card, title, "", 156)

        local SelectBtn = create("TextButton", {
            Text = "", AutoButtonColor = false, Size = UDim2.fromOffset(140, 34),
            Position = UDim2.new(1, -156, 0.5, -17), BackgroundColor3 = Theme.ToggleOff,
            ZIndex = 1, Parent = Card,
        }, { corner(R.Control), stroke(Theme.Stroke, 1) })
        local SelectedLabel = create("TextLabel", {
            Text = default, Font = Enum.Font.Gotham, TextSize = 13,
            TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1, ZIndex = 1, Position = UDim2.fromOffset(12, 0),
            Size = UDim2.new(1, -22, 1, 0), Parent = SelectBtn,
        })

        local POPOUT_W, POPOUT_H, ROW_H = 480, 380, 44
        local List = create("Frame", {
            Size = UDim2.fromOffset(POPOUT_W, 0), Position = UDim2.fromOffset(POPOUT_FIXED_X, POPOUT_FIXED_Y),
            BackgroundColor3 = Theme.Card, BackgroundTransparency = PANEL_TRANSPARENCY, ClipsDescendants = true, ZIndex = 20, Parent = self.Window.Overlay,
        }, { corner(R.Control) })
        do
            local reg = self.Window._transparency
            reg.Panel[#reg.Panel + 1] = List
        end
        local ListScroll = create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Stroke,
            CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = 20, Parent = List,
        })
        create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }).Parent = ListScroll

        local currentValue = default
        local open = false
        local function close()
            open = false
            tween(List, { Size = UDim2.fromOffset(POPOUT_W, 0) }, 0.12)
            self.Window.ClickOutsideCatcher.Visible = false
        end
        local function toggleOpen()
            if not open then closeAllPanelsExcept(close) end
            open = not open
            local target = open and POPOUT_H or 0
            tween(List, { Size = UDim2.fromOffset(POPOUT_W, target) }, 0.12)
            self.Window.ClickOutsideCatcher.Visible = open
        end
        registerPanel(close)
        SelectBtn.MouseButton1Click:Connect(toggleOpen)

        local optAccents = {}
        for i, opt in ipairs(options) do
            local OptBtn = create("TextButton", {
                Text = "|  " .. opt, Font = Enum.Font.GothamMedium, TextSize = 14,
                TextColor3 = Theme.TextPrimary, AutoButtonColor = false,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundColor3 = Theme.CardHover, BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, ROW_H),
                LayoutOrder = i, ZIndex = 21, Parent = ListScroll,
            })
            create("UIPadding", { PaddingLeft = UDim.new(0, 14) }).Parent = OptBtn
            local Accent = create("Frame", {
                Size = UDim2.new(0, 3, 0, 18), Position = UDim2.new(0, 0, 0.5, -9),
                BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
                BackgroundTransparency = (opt == default) and 0 or 1,
                ZIndex = 21, Parent = OptBtn,
            }, { corner(2) })
            optAccents[opt] = Accent
            OptBtn.MouseEnter:Connect(function() tween(OptBtn, { BackgroundTransparency = 0 }) end)
            OptBtn.MouseLeave:Connect(function() tween(OptBtn, { BackgroundTransparency = 1 }) end)
            OptBtn.MouseButton1Click:Connect(function()
                currentValue = opt
                SelectedLabel.Text = opt
                for o, bar in pairs(optAccents) do
                    tween(bar, { BackgroundTransparency = (o == opt) and 0 or 1 }, 0.12)
                end
                close()
                pcall(callback, opt)
            end)
        end

        registerFlag(config.Flag, function() return currentValue end, function(v)
            currentValue = v; SelectedLabel.Text = v
            for o, bar in pairs(optAccents) do tween(bar, { BackgroundTransparency = (o == v) and 0 or 1 }, 0.12) end
            pcall(callback, v)
        end)
        return { Set = function(_, v)
            currentValue = v; SelectedLabel.Text = v
            for o, bar in pairs(optAccents) do tween(bar, { BackgroundTransparency = (o == v) and 0 or 1 }, 0.12) end
            pcall(callback, v)
        end }
    end

    function Tab:CreateColorPicker(config)
        config = config or {}
        local title = config.Title or "Color"
        local default = config.Default or Color3.fromRGB(255, 255, 255)
        local callback = config.Callback or function() end
        self._order = self._order + 1
        local Card = baseCard(self._order, 58)
        cardTexts(Card, title, "", 60)

        local Swatch = create("TextButton", {
            Text = "", AutoButtonColor = false,
            Size = UDim2.fromOffset(36, 28), Position = UDim2.new(1, -52, 0.5, -14),
            BackgroundColor3 = default, ZIndex = 1, Parent = Card,
        }, { corner(R.Control), stroke(Theme.Stroke, 1) })

        local Panel = create("Frame", {
            Size = UDim2.fromOffset(180, 0), Position = UDim2.new(1, -196, 0, 62),
            BackgroundColor3 = Theme.CardHover, ClipsDescendants = true, ZIndex = 20, Parent = Card,
        }, { corner(R.Card), stroke(Theme.Stroke, 1) })
        create("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }).Parent = Panel

        local h, s, v = default:ToHSV()
        local currentColor = default

        local function makeChannelSlider(order, labelText, initial)
            local Row = create("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = order, ZIndex = 20, Parent = Panel })
            create("TextLabel", {
                Text = labelText, Font = Enum.Font.Gotham, TextSize = 11,
                TextColor3 = Theme.TextSecondary, BackgroundTransparency = 1, ZIndex = 20,
                Size = UDim2.fromOffset(16, 20), Parent = Row,
            })
            local Track = create("Frame", {
                Size = UDim2.new(1, -26, 0, 6), Position = UDim2.fromOffset(20, 10),
                BackgroundColor3 = Theme.SliderTrack, ZIndex = 20, Parent = Row,
            }, { corner(3) })
            local Knob = create("Frame", {
                Size = UDim2.fromOffset(12, 12), Position = UDim2.new(initial, -6, 0.5, -6),
                BackgroundColor3 = Theme.ToggleKnob, ZIndex = 20, Parent = Track,
            }, { corner(R.Knob) })
            return Track, Knob
        end
        create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }).Parent = Panel

        local HTrack, HKnob = makeChannelSlider(1, "H", h)
        local STrack, SKnob = makeChannelSlider(2, "S", s)
        local VTrack, VKnob = makeChannelSlider(3, "V", v)
        create("Frame", { Size = UDim2.new(1, 0, 0, 8), BackgroundTransparency = 1, LayoutOrder = 4, Parent = Panel })

        local function updateColor()
            currentColor = Color3.fromHSV(h, s, v)
            Swatch.BackgroundColor3 = currentColor
            pcall(callback, currentColor)
        end

        local function bindChannel(track, knob, getSet)
            local dragging = false
            local function apply(input)
                local alpha = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                knob.Position = UDim2.new(alpha, -6, 0.5, -6)
                getSet(alpha)
                updateColor()
            end
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    apply(input)
                end
            end)
            self.Window._connections[#self.Window._connections + 1] = UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    apply(input)
                end
            end)
            self.Window._connections[#self.Window._connections + 1] = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
        end
        bindChannel(HTrack, HKnob, function(a) h = a end)
        bindChannel(STrack, SKnob, function(a) s = a end)
        bindChannel(VTrack, VKnob, function(a) v = a end)

        local open = false
        local function closePanel()
            open = false
            tween(Panel, { Size = UDim2.fromOffset(180, 0) }, 0.15)
            self.Window.ClickOutsideCatcher.Visible = false
        end
        Swatch.MouseButton1Click:Connect(function()
            if not open then closeAllPanelsExcept(closePanel) end
            open = not open
            tween(Panel, { Size = UDim2.fromOffset(180, open and 110 or 0) }, 0.15)
            self.Window.ClickOutsideCatcher.Visible = open
        end)
        registerPanel(closePanel)

        registerFlag(config.Flag,
            function() return { currentColor.R, currentColor.G, currentColor.B } end,
            function(rgb)
                currentColor = Color3.new(rgb[1], rgb[2], rgb[3])
                h, s, v = currentColor:ToHSV()
                Swatch.BackgroundColor3 = currentColor
                HKnob.Position = UDim2.new(h, -6, 0.5, -6)
                SKnob.Position = UDim2.new(s, -6, 0.5, -6)
                VKnob.Position = UDim2.new(v, -6, 0.5, -6)
                pcall(callback, currentColor)
            end)

        return { Set = function(_, color)
            currentColor = color
            h, s, v = currentColor:ToHSV()
            Swatch.BackgroundColor3 = currentColor
            pcall(callback, currentColor)
        end }
    end

    return Tab
end

return Zentih
