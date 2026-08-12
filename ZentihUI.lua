--[[
    Zentih UI Library — Module

    This is the library only (no test/demo build). It returns the Zentih
    table so other scripts can require() it and build their own GUI:

        local Zentih = require(path.to.ZentihLibrary)
        local Window = Zentih:CreateWindow({ Title = "My Script" })
        local Tab = Window:CreateTab({ Name = "Main", Icon = "home" })
        Tab:CreateButton({ Title = "Click me", Callback = function() end })
        ...

    See ZentihExample.lua for a full usage example covering every element
    type (Sections, Labels, Dividers, Paragraphs, Buttons, Toggles,
    Sliders, Progress Bars, Dropdowns, Multi Dropdowns, Combo Boxes,
    Keybinds, Text Inputs, Color Pickers, Notify(), Config Save/Load,
    live Transparency, and the 9 drawn tab icons: home, sword, save,
    settings, input, dungeon, status, eye, star).

    To load this over HTTP in an executor instead of a ModuleScript:
        local Zentih = loadstring(game:HttpGet("<raw url to this file>"))()
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Theme = {
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
}

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

local function create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
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
    for _, fn in ipairs(OpenPanels) do if fn ~= exceptFn then fn() end end
end

--// Window ----------------------------------------------------------------
function Zentih:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Zentih"
    local subtitle = config.Subtitle or ""
    local configFolder = config.ConfigFolder or "ZentihUI"

    local existing = PlayerGui:FindFirstChild("ZentihUI")
    if existing then existing:Destroy() end
    safeMakeFolder(configFolder)

    local ScreenGui = create("ScreenGui", {
        Name = "ZentihUI", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
        Parent = PlayerGui,
    })

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
        ToggleBubble = ToggleBubble,
    }, Zentih)

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
    end
    OpenPanels = {}
    if self.ScreenGui then self.ScreenGui:Destroy() end
end

--// Tabs -------------------------------------------------------------------
-- Icon = a string name picked from the drawn-icon set below (not a raw
-- character — Roblox's built-in Gotham fonts can't render most symbols).
-- Available icons: home, sword, save, settings, input, dungeon, status,
-- eye, star

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
            callback(state)
        end)

        registerFlag(config.Flag, function() return state end, function(v) state = v; render(); callback(state) end)
        return { Set = function(_, v) state = v; render(); callback(state) end, Get = function() return state end }
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
            callback(value)
        end
        Track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromAlpha((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                setFromAlpha((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
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
                callback(opt)
            end)
        end
        SelectBtn.MouseButton1Click:Connect(toggleOpen)

        registerFlag(config.Flag, function() return currentValue end, function(v) currentValue = v; SelectedLabel.Text = v; callback(v) end)
        return { Set = function(_, v) currentValue = v; SelectedLabel.Text = v; callback(v) end }
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
                    callback(input.KeyCode)
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

        Box.FocusLost:Connect(function(enterPressed) callback(Box.Text, enterPressed) end)
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
                callback(list)
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
                callback(opt)
            end)
        end

        registerFlag(config.Flag, function() return currentValue end, function(v)
            currentValue = v; SelectedLabel.Text = v
            for o, bar in pairs(optAccents) do tween(bar, { BackgroundTransparency = (o == v) and 0 or 1 }, 0.12) end
            callback(v)
        end)
        return { Set = function(_, v)
            currentValue = v; SelectedLabel.Text = v
            for o, bar in pairs(optAccents) do tween(bar, { BackgroundTransparency = (o == v) and 0 or 1 }, 0.12) end
            callback(v)
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
            callback(currentColor)
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
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    apply(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
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
                callback(currentColor)
            end)

        return { Set = function(_, color)
            currentColor = color
            h, s, v = currentColor:ToHSV()
            Swatch.BackgroundColor3 = currentColor
            callback(currentColor)
        end }
    end

    return Tab
end

return Zentih
