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
})

พอสร้าง Window แล้ว จะมี "ปุ่มลอยวงกลม" โผล่ที่ขอบขวาจอให้อัตโนมัติ
กดปุ่มนั้นเพื่อซ่อน/เปิด GUI ทั้งหมด ลากปุ่มไปวางตรงไหนของจอก็ได้

------------------------------------------------------------------------
3) สร้างแท็บ (Tab) — 1 หน้าต่างมีได้หลายแท็บ
------------------------------------------------------------------------

local Main = Window:CreateTab({
    Name = "หน้าหลัก",   -- ชื่อโชว์ในแถบข้างซ้าย
    Icon = "home",       -- ไอคอนหน้าชื่อแท็บ เลือกได้: home, sword, save,
                          -- settings, input, dungeon, status, eye, star
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

-- ตัวเลขที่อัปเดตสดๆ (เช่น เงิน, kill count) — โชว์ +/- ตอนค่าเปลี่ยน
local Kills = Main:CreateStat({ Title = "จำนวนคิล", Default = 0 })
Kills:Set(5)

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
9) ปิดโปรแกรม / ทำลาย GUI ทิ้งทั้งหมด
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
- ดูรายละเอียดพารามิเตอร์ครบทุกฟังก์ชันได้ในไฟล์ API.md (ภาษาอังกฤษ)

========================================================================
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

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

local function create(class, props, children)
    local inst = Instance.new(class)
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

local Zentih = {}
Zentih.__index = Zentih

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
    end
end

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
    local function track(conn) Connections[#Connections + 1] = conn; return conn end

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
        ZIndex = 100, Parent = ScreenGui,
    }, { corner(999), stroke(Theme.Stroke, 1) })
    local ToggleIcon = create("Frame", {
        Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(15, 15),
        BackgroundTransparency = 1, ZIndex = 100, Parent = ToggleBubble,
    })
    drawIcon("eye", ToggleIcon, Theme.TextPrimary)

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

function Zentih:Destroy()
    if self._connections then
        for _, conn in ipairs(self._connections) do pcall(function() conn:Disconnect() end) end
        if PreviousWindowConnections == self._connections then PreviousWindowConnections = nil end
    end
    OpenPanels = {}
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

--// Tabs -------------------------------------------------------------------
-- Icon = a string name picked from the drawn-icon set below (not a raw
-- character — Roblox's built-in Gotham fonts can't render most symbols).
-- Available icons: home, sword, save, settings, input, dungeon, status,
-- eye, star

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
        -- Read-only key/value display. Calling :Set(value) on the returned
        -- handle briefly flashes the value text to show it changed, and if
        -- the value is numeric, shows the +/- delta from the previous value.
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
        return {
            Set = function(_, value)
                if type(value) == "number" and type(lastValue) == "number" then
                    local delta = value - lastValue
                    if delta ~= 0 then
                        DeltaLabel.Text = (delta > 0 and "+" or "") .. tostring(delta)
                        DeltaLabel.TextColor3 = delta > 0 and Theme.Success or Theme.Error
                    end
                end
                lastValue = value
                ValueLabel.Text = tostring(value)
                ValueLabel.TextColor3 = Theme.Accent
                tween(ValueLabel, { TextColor3 = Theme.TextPrimary }, 0.4)
            end,
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
        end
        local function toggleOpen()
            if not open then closeAllPanelsExcept(close) end
            open = not open
            local target = open and POPOUT_H or 0
            tween(List, { Size = UDim2.fromOffset(POPOUT_W, target) }, 0.12)
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
        end
        local function toggleOpen()
            if not open then closeAllPanelsExcept(close) end
            open = not open
            local target = open and POPOUT_H or 0
            tween(List, { Size = UDim2.fromOffset(POPOUT_W, target) }, 0.12)
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
        end
        local function toggleOpen()
            if not open then closeAllPanelsExcept(close) end
            open = not open
            local target = open and POPOUT_H or 0
            tween(List, { Size = UDim2.fromOffset(POPOUT_W, target) }, 0.12)
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
        end
        Swatch.MouseButton1Click:Connect(function()
            if not open then closeAllPanelsExcept(closePanel) end
            open = not open
            tween(Panel, { Size = UDim2.fromOffset(180, open and 110 or 0) }, 0.15)
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
