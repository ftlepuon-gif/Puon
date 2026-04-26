-- FX's Finder  V2
-- Titre: FX's Finder | Couleurs: Blue-White Chroma

local HttpService    = game:GetService("HttpService")
local CoreGui        = game:GetService("CoreGui")
local TweenService   = game:GetService("TweenService")
local Players        = game:GetService("Players")
local TeleportService= game:GetService("TeleportService")
local SoundService   = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local UI_NAME = "FXsFinderv2_GUI"
local lp = Players.LocalPlayer

---- Cleanup
local gui0 = (gethui and gethui()) or CoreGui
for _, v in pairs(gui0:GetChildren()) do
    if v.Name == UI_NAME then v:Destroy() end
end
if SoundService:FindFirstChild("FX_NotifSound") then SoundService.FX_NotifSound:Destroy() end
if lp.Character then
    local h = lp.Character:FindFirstChild("Head")
    if h and h:FindFirstChild("FX_USER_ESP") then h.FX_USER_ESP:Destroy() end
end

-- ═══════════════════════════════════
-- THEME 
-- ═══════════════════════════════════
local T = {
    BgDark      = Color3.fromRGB(5, 5, 5),
    BgMid       = Color3.fromRGB(10, 10, 10),
    BgCard      = Color3.fromRGB(12, 12, 12),
    BgCardHover = Color3.fromRGB(20, 20, 20),
    Sidebar     = Color3.fromRGB(8, 8, 8),
    Accent1     = Color3.fromRGB(0, 106, 255),
    Accent2     = Color3.fromRGB(99, 179, 255),
    AccentGlow  = Color3.fromRGB(40, 100, 220),
    White       = Color3.fromRGB(240, 245, 255),
    TextDim     = Color3.fromRGB(122, 122, 122),
    Off         = Color3.fromRGB(25, 25, 25),
    Green       = Color3.fromRGB(45, 210, 110),
    GreenDim    = Color3.fromRGB(25, 60, 40),
    Red         = Color3.fromRGB(220, 60, 70),
    HighlightC  = Color3.fromRGB(255, 75, 75),
    MidlightC   = Color3.fromRGB(80, 175, 255),
}

-- ═══════════════════════════════════
-- USER SETTINGS
-- ═══════════════════════════════════
local userSettings = {
    Midlights       = true,
    Highlights      = true,
    AutoJoin        = false,
    AutoJoinRetries = 20,
    PlaySound       = true,
    ToggleKey       = "RightShift",
    UseWhitelist    = false,
    Whitelist       = {}
}

local CONFIG_FILE = "FXsFinder_Config.json"
pcall(function()
    if isfile and readfile and isfile(CONFIG_FILE) then
        local saved = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(saved) == "table" then
            for k, v in pairs(saved) do
                if k == "Whitelist" and type(v) == "table" then
                    for wk, wv in pairs(v) do userSettings.Whitelist[wk] = wv end
                else
                    userSettings[k] = v
                end
            end
        end
    end
end)

task.spawn(function()
    local lastSave = HttpService:JSONEncode(userSettings)
    while _G.FXRunning ~= false do
        task.wait(3)
        pcall(function()
            local current = HttpService:JSONEncode(userSettings)
            if current ~= lastSave then
                if writefile then writefile(CONFIG_FILE, current) end
                lastSave = current
            end
        end)
    end
end)

-- ═══════════════════════════════════
-- BRAINROTS LIST
-- ═══════════════════════════════════
local allBrainrots = {
    "Los Nooo My Hotspotsitos","Serafinna Medusella","La Grande Combinassion","La Easter Grande","Rang Ring Bus","Guest 666",
    "Los Mi Gatitos","Los Chicleteiras","Noo My Eggs","67","Donkeyturbo Express","Mariachi Corazoni","Los Burritos",
    "Los 25","Tacorillo Crocodillo","Swag Soda","Noo my Heart","Chimnino","Los Combinasionas","Chicleteira Noelteira",
    "Fishino Clownino","Baskito","Tacorita Bicicleta","Los Sweethearts","Spinny Hammy","Nuclearo Dinosauro","Las Sis",
    "DJ Panda","Chicleteira Cupideira","La Karkerkar Combinasion","Chillin Chili","Chipso and Queso","Money Money Reindeer",
    "Money Money Puggy","Churrito Bunnito","Celularcini Viciosini","Los Planitos","Los Mobilis","Los 67",
    "Mieteteira Bicicleteira","Tuff Toucan","La Spooky Grande","Los Spooky Combinasionas","Cigno Fulgoro","Los Candies",
    "Los Hotspositos","Los Jolly Combinasionas","Los Cupids","Los Puggies","W or L","Tralalalaledon",
    "La Extinct Grande Combinasion","Tralaledon","La Jolly Grande","Los Primos","Bacuru and Egguru","Eviledon",
    "Los Tacoritas","Lovin Rose","Tang Tang Kelentang","Ketupat Kepat","Los Bros","Tictac Sahur","La Romantic Grande",
    "Gingerat Gerat","Orcaledon","La Lucky Grande","Ketchuru and Masturu","Jolly Jolly Sahur","Garama and Madundung",
    "Rosetti Tualetti","Nacho Spyder","Hopilikalika Hopilikalako","Festive 67","Sammyni Fattini","Love Love Bear",
    "La Ginger Sekolah","Spooky and Pumpky","Boppin Bunny","Lavadorito Spinito","La Food Combinasion","Los Spaghettis",
    "La Casa Boo","Fragrama and Chocrama","Los Sekolahs","Foxini Lanternini","La Secret Combinasion","Los Amigos",
    "Reinito Sleighito","Ketupat Bros","Burguro and Fryuro","Cooki and Milki","Capitano Moby","Rosey and Teddy",
    "Popcuru and Fizzuru","Hydra Bunny","Celestial Pegasus","Cerberus","La Supreme Combinasion","Dragon Cannelloni",
    "Dragon Gingerini","Headless Horseman","Hydra Dragon Cannelloni","Griffin","Skibidi Toilet","Meowl",
    "Strawberry Elephant","La Vacca Saturno Saturnita","Pandanini Frostini","Bisonte Giuppitere","Blackhole Goat",
    "Jackorilla","Agarrini Ia Palini","Chachechi","Karkerkar Kurkur","Los Tortus","Los Matteos","Sammyni Spyderini",
    "Trenostruzzo Turbo 4000","Chimpanzini Spiderini","Boatito Auratito","Fragola La La La","Dul Dul Dul",
    "La Vacca Prese Presente","Frankentteo","Los Trios","Karker Sahur","Torrtuginni Dragonfrutini (Lucky Block)",
    "Los Tralaleritos","Zombie Tralala","La Cucaracha","Vulturino Skeletono","Guerriro Digitale","Extinct Tralalero",
    "Yess My Examine","Extinct Matteo","Las Tralaleritas","Rocco Disco","Reindeer Tralala","Las Vaquitas Saturnitas",
    "Pumpkin Spyderini","Job Job Job Sahur","Los Karkeritos","Graipuss Medussi","Santteo","Fishboard","Buntteo",
    "La Vacca Jacko Linterino","Triplito Tralaleritos","Trickolino","Paradiso Axolottino","GOAT","Giftini Spyderini",
    "Los Spyderinis","Love Love Love Sahur","Perrito Burrito","1x1x1x1","Los Cucarachas","Easter Easter Sahur",
    "Please My Present","Cuadramat and Pakrahmatmamat","Los Jobcitos","Nooo My Hotspot","Pot Hotspot (Lucky Block)",
    "Noo My Examine","Telemorte","La Sahur Combinasion","List List List Sahur","Bunny Bunny Bunny Sahur","To To To Sahur",
    "Pirulitoita Bicicletaire","25","Santa Hotspot","Horegini Boom","Quesadilla Crocodila","Pot Pumpkin","Naughty Naughty",
    "Cupid Cupid Sahur","Ho Ho Ho Sahur","Mi Gatito","Chicleteira Bicicleteira","Eid Eid Eid Sahur","Cupid Hotspot",
    "Spaghetti Tualetti (Lucky Block)","Esok Sekolah (Lucky Block)","Quesadillo Vampiro","Brunito Marsito","Chill Puppy",
    "Burrito Bandito","Chicleteirina Bicicleteirina","Granny","Los Bunitos","Los Quesadillas","Bunito Bunito Spinito",
    "Noo My Candy"
}

-- ═══════════════════════════════════
-- SOUND
-- ═══════════════════════════════════
local NotifSound = Instance.new("Sound")
NotifSound.Name    = "FX_NotifSound"
NotifSound.SoundId = "rbxassetid://4590662766"
NotifSound.Volume  = 1
NotifSound.Parent  = SoundService

local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://75311202481026"
ClickSound.Volume  = 0.3
ClickSound.Parent  = SoundService

local function playNotifSound() if userSettings.PlaySound then NotifSound:Play() end end
local function playClick() pcall(function() ClickSound:Play() end) end

local function formatNumber(n)
    n = tonumber(n) or 0
    if n >= 1000000 then
        return (string.format("%.1fM", n/1000000)):gsub("%.0M","M")
    elseif n >= 1000 then
        return (string.format("%.1fK", n/1000)):gsub("%.0K","K")
    else
        return tostring(n)
    end
end

-- ═══════════════════════════════════
-- SCREEN GUI
-- ═══════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name          = UI_NAME
ScreenGui.Parent        = gui0
ScreenGui.ZIndexBehavior= Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn  = false

local isMobile    = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local TARGET_SCALE= isMobile and 0.85 or 1.0
local HIDE_SCALE  = TARGET_SCALE - 0.12

-- ═══════════════════════════════════
-- MAIN FRAME (CanvasGroup style Moby)
-- ═══════════════════════════════════
local Frame = Instance.new("CanvasGroup", ScreenGui)
Frame.BackgroundColor3 = T.BgDark
Frame.BorderSizePixel  = 0
Frame.Position         = UDim2.new(0.5, -303, 0.5, -190)
Frame.Size             = UDim2.new(0, 606, 0, 380)
Frame.Active           = true
Frame.GroupTransparency= 1

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
local UIScale = Instance.new("UIScale", Frame)
UIScale.Scale = HIDE_SCALE

-- Chroma border stroke
local MainStroke = Instance.new("UIStroke", Frame)
MainStroke.Thickness = 2
MainStroke.Color     = T.Accent1
MainStroke.Transparency = 0.1

local BorderGrad = Instance.new("UIGradient", MainStroke)
BorderGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40,100,220)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140,210,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40,100,220))
}

-- Intro animation
TweenService:Create(Frame,   TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = TARGET_SCALE}):Play()

local tweenInfo     = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local dragTweenInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- ═══════════════════════════════════
-- SIDEBAR (155px, dark)
-- ═══════════════════════════════════
local Sidebar = Instance.new("Frame", Frame)
Sidebar.Size             = UDim2.new(0, 155, 1, 0)
Sidebar.BackgroundColor3 = T.Sidebar
Sidebar.BorderSizePixel  = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

-- Fix corner on right side
local SFix = Instance.new("Frame", Sidebar)
SFix.Size             = UDim2.new(0, 10, 1, 0)
SFix.Position         = UDim2.new(1, -10, 0, 0)
SFix.BackgroundColor3 = T.Sidebar
SFix.BorderSizePixel  = 0

local SepLine = Instance.new("Frame", Sidebar)
SepLine.Size             = UDim2.new(0, 1, 1, -20)
SepLine.Position         = UDim2.new(1, 0, 0, 10)
SepLine.BackgroundColor3 = T.Off
SepLine.BorderSizePixel  = 0

-- Logo
local Logo = Instance.new("TextLabel", Sidebar)
Logo.Size               = UDim2.new(1, 0, 0, 28)
Logo.Position           = UDim2.new(0, 0, 0, 10)
Logo.BackgroundTransparency = 1
Logo.Text               = "FX's Finder"
Logo.Font               = Enum.Font.GothamBlack
Logo.TextSize           = 18
Logo.TextColor3         = T.Accent2

local LogoSub = Instance.new("TextLabel", Sidebar)
LogoSub.Size               = UDim2.new(1, 0, 0, 13)
LogoSub.Position           = UDim2.new(0, 0, 0, 38)
LogoSub.BackgroundTransparency = 1
LogoSub.Text               = "N O T I F I E R"
LogoSub.Font               = Enum.Font.Gotham
LogoSub.TextSize           = 9
LogoSub.TextColor3         = T.TextDim

local VerBadge = Instance.new("TextLabel", Sidebar)
VerBadge.Size               = UDim2.new(0.5, 0, 0, 16)
VerBadge.Position           = UDim2.new(0.25, 0, 0, 54)
VerBadge.BackgroundColor3   = T.BgCard
VerBadge.Text               = "v1"
VerBadge.Font               = Enum.Font.GothamBold
VerBadge.TextSize           = 10
VerBadge.TextColor3         = T.Accent2
Instance.new("UICorner", VerBadge).CornerRadius = UDim.new(0, 6)

-- ═══════════════════════════════════
-- SIDEBAR TAB BUTTONS
-- ═══════════════════════════════════
local activeTab = "logs"
local tabButtons = {}
local espStrokes = {}

local LogsPage     = Instance.new("Frame", Frame)
LogsPage.Size      = UDim2.new(1, -155, 1, -2)
LogsPage.Position  = UDim2.new(0, 155, 0, 2)
LogsPage.BackgroundTransparency = 1

local SettingsPage = Instance.new("Frame", Frame)
SettingsPage.Size  = UDim2.new(1, -155, 1, -2)
SettingsPage.Position = UDim2.new(0, 155, 0, 2)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false

local WhitelistPage = Instance.new("Frame", Frame)
WhitelistPage.Size  = UDim2.new(1, -155, 1, -2)
WhitelistPage.Position = UDim2.new(0, 155, 0, 2)
WhitelistPage.BackgroundTransparency = 1
WhitelistPage.Visible = false

local ProfilePage = Instance.new("Frame", Frame)
ProfilePage.Size  = UDim2.new(1, -155, 1, -2)
ProfilePage.Position = UDim2.new(0, 155, 0, 2)
ProfilePage.BackgroundTransparency = 1
ProfilePage.Visible = false

local function switchTab(toKey)
    activeTab = toKey
    LogsPage.Visible     = toKey == "logs"
    SettingsPage.Visible = toKey == "settings"
    WhitelistPage.Visible= toKey == "whitelist"
    ProfilePage.Visible  = toKey == "profile"
    for k, d in pairs(tabButtons) do
        local on = k == toKey
        d.btn.BackgroundTransparency = on and 0 or 1
        d.ind.BackgroundTransparency = on and 0 or 1
        d.lbl.TextColor3 = on and T.White or T.TextDim
    end
end

local function makeTabBtn(icon, text, yPos, key)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size               = UDim2.new(1, -20, 0, 34)
    btn.Position           = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3   = T.BgCard
    btn.BackgroundTransparency = key == "logs" and 0 or 1
    btn.BorderSizePixel    = 0
    btn.Text               = ""
    btn.AutoButtonColor    = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local ind = Instance.new("Frame", btn)
    ind.Size               = UDim2.new(0, 3, 0.6, 0)
    ind.Position           = UDim2.new(0, 0, 0.2, 0)
    ind.BackgroundColor3   = T.Accent1
    ind.BackgroundTransparency = key == "logs" and 0 or 1
    Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size               = UDim2.new(1, -15, 1, 0)
    lbl.Position           = UDim2.new(0, 15, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Text               = icon .. "  " .. text
    lbl.Font               = Enum.Font.GothamSemibold
    lbl.TextSize           = 12
    lbl.TextColor3         = key == "logs" and T.White or T.TextDim

    tabButtons[key] = {btn=btn, ind=ind, lbl=lbl}

    btn.MouseButton1Click:Connect(function()
        playClick()
        switchTab(key)
    end)
end

makeTabBtn("📋", "Logs",      82,  "logs")
makeTabBtn("⚙️", "Settings", 122, "settings")
makeTabBtn("🛡️", "Whitelist",162, "whitelist")
makeTabBtn("👤", "Profile",  202, "profile")

-- ═══════════════════════════════════
-- TOP CONTROLS (close + minimize)
-- ═══════════════════════════════════
local TopControls = Instance.new("Frame", Frame)
TopControls.BackgroundColor3 = T.BgCard
TopControls.AnchorPoint      = Vector2.new(1, 0)
TopControls.Position         = UDim2.new(1, -12, 0, 10)
TopControls.Size             = UDim2.new(0, 64, 0, 28)
Instance.new("UICorner", TopControls).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", TopControls).Color = T.Off

local TCLayout = Instance.new("UIListLayout", TopControls)
TCLayout.FillDirection       = Enum.FillDirection.Horizontal
TCLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TCLayout.VerticalAlignment   = Enum.VerticalAlignment.Center

local function makeIconBtn(parent, imgId, order)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundTransparency = 1
    btn.Size        = UDim2.new(0, 32, 0, 28)
    btn.Text        = ""
    btn.LayoutOrder = order
    local ic = Instance.new("ImageLabel", btn)
    ic.BackgroundTransparency = 1
    ic.AnchorPoint  = Vector2.new(0.5, 0.5)
    ic.Position     = UDim2.new(0.5, 0, 0.5, 0)
    ic.Size         = UDim2.new(0, 14, 0, 14)
    ic.Image        = imgId
    ic.ImageColor3  = T.White
    btn.MouseEnter:Connect(function() TweenService:Create(ic, tweenInfo, {ImageColor3 = Color3.fromRGB(180,180,180)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(ic, tweenInfo, {ImageColor3 = T.White}):Play() end)
    return btn, ic
end

local MinBtn,   _ = makeIconBtn(TopControls, "rbxassetid://110986349331865", 1)
local CloseBtn, _ = makeIconBtn(TopControls, "rbxassetid://119410757402001",  2)

local guiVisible = true

local function toggleGUI()
    guiVisible = not guiVisible
    if guiVisible then
        Frame.Visible = true
        TweenService:Create(Frame,   TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
        TweenService:Create(UIScale, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = TARGET_SCALE}):Play()
    else
        local tw = TweenService:Create(Frame,   TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {GroupTransparency = 1})
        TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = HIDE_SCALE}):Play()
        tw:Play()
        tw.Completed:Connect(function() if not guiVisible then Frame.Visible = false end end)
    end
end

MinBtn.MouseButton1Click:Connect(function()
    playClick()
    toggleGUI()
end)

CloseBtn.MouseButton1Click:Connect(function()
    playClick()
    _G.FXRunning = false
    local tw = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {GroupTransparency = 1})
    TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = HIDE_SCALE}):Play()
    tw:Play()
    tw.Completed:Connect(function()
        ScreenGui:Destroy()
        if SoundService:FindFirstChild("FX_NotifSound") then SoundService.FX_NotifSound:Destroy() end
        if lp.Character then
            local h = lp.Character:FindFirstChild("Head")
            if h and h:FindFirstChild("FX_USER_ESP") then h.FX_USER_ESP:Destroy() end
        end
    end)
end)

-- Mobile toggle
local MobileToggle = Instance.new("TextButton", ScreenGui)
MobileToggle.Size             = UDim2.new(0, 40, 0, 40)
MobileToggle.Position         = UDim2.new(0, 10, 0, 10)
MobileToggle.BackgroundColor3 = T.BgCard
MobileToggle.BorderSizePixel  = 0
MobileToggle.Text             = "FX"
MobileToggle.Font             = Enum.Font.GothamBlack
MobileToggle.TextSize         = 14
MobileToggle.TextColor3       = T.Accent2
MobileToggle.Active           = true
MobileToggle.Draggable        = true
MobileToggle.Visible          = UserInputService.TouchEnabled
Instance.new("UICorner", MobileToggle).CornerRadius = UDim.new(1, 0)
local mtStroke = Instance.new("UIStroke", MobileToggle)
mtStroke.Thickness = 2
mtStroke.Color     = T.Accent1
MobileToggle.MouseButton1Click:Connect(toggleGUI)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode.Name == userSettings.ToggleKey then toggleGUI() end
end)

-- ═══════════════════════════════════
-- DRAG SYSTEM
-- ═══════════════════════════════════
local dragging = false
local dragStart, startPos, dragInput

local function updateDrag(input)
    if not dragging or not dragStart or not startPos then return end
    local delta = input.Position - dragStart
    local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(Frame, dragTweenInfo, {Position = targetPos}):Play()
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos  = Frame.Position
        TweenService:Create(UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {Scale = TARGET_SCALE * 0.98}):Play()
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                TweenService:Create(UIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = TARGET_SCALE}):Play()
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput then updateDrag(input) end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        TweenService:Create(UIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = TARGET_SCALE}):Play()
    end
end)

-- ═══════════════════════════════════
-- LOGS PAGE
-- ═══════════════════════════════════
local TopBar = Instance.new("Frame", LogsPage)
TopBar.Size                 = UDim2.new(1, 0, 0, 52)
TopBar.BackgroundTransparency = 1

local ajPanel = Instance.new("Frame", TopBar)
ajPanel.Size             = UDim2.new(1, -95, 0, 34)
ajPanel.Position         = UDim2.new(0, 12, 0, 10)
ajPanel.BackgroundColor3 = T.BgCard
Instance.new("UICorner", ajPanel).CornerRadius = UDim.new(0, 8)

local ajStroke = Instance.new("UIStroke", ajPanel)
ajStroke.Color     = T.Off
ajStroke.Thickness = 1

local ajPulse = Instance.new("Frame", ajPanel)
ajPulse.Size             = UDim2.new(0, 8, 0, 8)
ajPulse.Position         = UDim2.new(0, 10, 0.5, -4)
ajPulse.BackgroundColor3 = T.Off
Instance.new("UICorner", ajPulse).CornerRadius = UDim.new(1, 0)

local ajLbl = Instance.new("TextLabel", ajPanel)
ajLbl.Size               = UDim2.new(0, 100, 1, 0)
ajLbl.Position           = UDim2.new(0, 24, 0, 0)
ajLbl.BackgroundTransparency = 1
ajLbl.Text               = "AutoJoin"
ajLbl.Font               = Enum.Font.GothamBold
ajLbl.TextXAlignment     = Enum.TextXAlignment.Left
ajLbl.TextSize           = 12
ajLbl.TextColor3         = T.White

local ajStatus = Instance.new("TextLabel", ajPanel)
ajStatus.Size               = UDim2.new(0, 120, 1, 0)
ajStatus.Position           = UDim2.new(0, 128, 0, 0)
ajStatus.BackgroundTransparency = 1
ajStatus.Text               = ""
ajStatus.Font               = Enum.Font.GothamBold
ajStatus.TextXAlignment     = Enum.TextXAlignment.Left
ajStatus.TextSize           = 11
ajStatus.TextColor3         = T.Green

local ajTrack = Instance.new("TextButton", ajPanel)
ajTrack.Size             = UDim2.new(0, 42, 0, 20)
ajTrack.Position         = UDim2.new(1, -54, 0.5, -10)
ajTrack.BackgroundColor3 = userSettings.AutoJoin and T.Accent1 or T.Off
ajTrack.Text             = ""
Instance.new("UICorner", ajTrack).CornerRadius = UDim.new(1, 0)

local ajDot = Instance.new("Frame", ajTrack)
ajDot.Size             = UDim2.new(0, 14, 0, 14)
ajDot.Position         = userSettings.AutoJoin and UDim2.new(1,-17,0,3) or UDim2.new(0,3,0,3)
ajDot.BackgroundColor3 = T.White
Instance.new("UICorner", ajDot).CornerRadius = UDim.new(1, 0)

local function updateAJVisuals(on)
    TweenService:Create(ajDot,   TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = on and UDim2.new(1,-17,0,3) or UDim2.new(0,3,0,3)}):Play()
    TweenService:Create(ajTrack, TweenInfo.new(0.15), {BackgroundColor3 = on and T.Accent1 or T.Off}):Play()
    TweenService:Create(ajPulse, TweenInfo.new(0.2),  {BackgroundColor3 = on and T.Green  or T.Off}):Play()
    TweenService:Create(ajStroke,TweenInfo.new(0.2),  {Color = on and T.Accent1 or T.Off}):Play()
    ajStatus.Text      = on and "Waiting for logs..." or ""
    ajStatus.TextColor3= T.TextDim
end

ajTrack.MouseButton1Click:Connect(function()
    userSettings.AutoJoin = not userSettings.AutoJoin
    updateAJVisuals(userSettings.AutoJoin)
end)

-- ─── FILTER BUTTONS ────────────────
local filterFrame = Instance.new("Frame", TopBar)
filterFrame.Size             = UDim2.new(0, 82, 0, 34)
filterFrame.Position         = UDim2.new(1, -86, 0, 10)
filterFrame.BackgroundColor3 = T.BgCard
Instance.new("UICorner", filterFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", filterFrame).Color = T.Off

local filterBtns = {}
local CurrentFilter = "AJ"
local LogEntries = {}

local function applyFilter()
    for _, entry in ipairs(LogEntries) do
        if CurrentFilter == "AJ" then
            entry.card.Visible = true
        elseif CurrentFilter == "HL" then
            entry.card.Visible = entry.isHL == true
        elseif CurrentFilter == "ML" then
            entry.card.Visible = entry.isHL == false
        end
    end
end

local filterLayout = Instance.new("UIListLayout", filterFrame)
filterLayout.FillDirection       = Enum.FillDirection.Horizontal
filterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
filterLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
filterLayout.Padding             = UDim.new(0, 4)

local function makeFilterBtn(label, filter)
    local b = Instance.new("TextButton", filterFrame)
    b.Size             = UDim2.new(0, 22, 0, 22)
    b.BackgroundColor3 = filter == "AJ" and T.Accent1 or T.Off
    b.Text             = label
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 9
    b.TextColor3       = filter == "AJ" and T.White or T.TextDim
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    table.insert(filterBtns, {btn=b, filter=filter})
    b.MouseButton1Click:Connect(function()
        playClick()
        CurrentFilter = filter
        for _, fd in ipairs(filterBtns) do
            TweenService:Create(fd.btn, tweenInfo, {BackgroundColor3 = fd.filter==filter and T.Accent1 or T.Off, TextColor3 = fd.filter==filter and T.White or T.TextDim}):Play()
        end
        applyFilter()
    end)
end

makeFilterBtn("All", "AJ")
makeFilterBtn("HL",  "HL")
makeFilterBtn("ML",  "ML")

-- ─── SCROLL LOGS ───────────────────
local Content = Instance.new("ScrollingFrame", LogsPage)
Content.Size             = UDim2.new(1, 0, 1, -52)
Content.Position         = UDim2.new(0, 0, 0, 50)
Content.BackgroundTransparency = 1
Content.BorderSizePixel  = 0
Content.ScrollBarThickness     = 2
Content.ScrollBarImageColor3   = T.Off
Content.AutomaticCanvasSize    = Enum.AutomaticSize.Y

local CLayout = Instance.new("UIListLayout", Content)
CLayout.Padding    = UDim.new(0, 0)   -- no gap between rows (Moby style)
CLayout.SortOrder  = Enum.SortOrder.LayoutOrder

local CPad = Instance.new("UIPadding", Content)
CPad.PaddingLeft  = UDim.new(0, 8)
CPad.PaddingRight = UDim.new(0, 8)
CPad.PaddingTop   = UDim.new(0, 4)

-- ═══════════════════════════════════
-- AUTOJOIN LOGIC
-- ═══════════════════════════════════
local currentlyJoining = false

local function performJoinSpam(jobId)
    if currentlyJoining then return end
    currentlyJoining = true
    task.spawn(function()
        local dots = {"Joining.","Joining..","Joining..."}
        local i = 1
        while currentlyJoining and _G.FXRunning do
            ajStatus.Text = dots[i]
            i = i%3+1
            task.wait(0.4)
        end
    end)
    task.spawn(function()
        local attempts = tonumber(userSettings.AutoJoinRetries) or 3
        for i = 1, attempts do
            if not _G.FXRunning then break end
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, lp) end)
            task.wait(3)
        end
        currentlyJoining = false
        if userSettings.AutoJoin then
            ajStatus.Text      = "Waiting for logs..."
            ajStatus.TextColor3= T.TextDim
        else
            ajStatus.Text = ""
        end
    end)
end

-- ═══════════════════════════════════
-- LOG ENTRIES  ★ MOBY STYLE ★
--   layout: [tierBar] [icon] [name · value · tier] ........... [JOIN] [FORCE]
--   height : 45px | flat (BackgroundTransparency = 1)
--   séparateur bas : 1px T.Off
-- ═══════════════════════════════════
local hlCount = 0
local mlCount = 0
local activeLogs = {}

local function addLogEntry(data)
    local isHL = data.tier == "Highlights"
    local order
    if isHL then hlCount = hlCount+1; order = -200000-hlCount
    else mlCount = mlCount+1; order = -100000-mlCount end

    -- ── ROW (flat, Moby style) ──────────────────────────────────────────
    local LogItem = Instance.new("Frame", Content)
    LogItem.BackgroundTransparency = 1
    LogItem.Size         = UDim2.new(1, -10, 0, 45)
    LogItem.LayoutOrder  = order

    -- Bottom separator
    local line = Instance.new("Frame", LogItem)
    line.BackgroundColor3 = T.Off
    line.BorderSizePixel  = 0
    line.Size             = UDim2.new(1, 0, 0, 1)
    line.Position         = UDim2.new(0, 0, 1, -1)

    -- Tier colour bar (left edge, 3px, Laced style)
    local tierBar = Instance.new("Frame", LogItem)
    tierBar.Size             = UDim2.new(0, 3, 0.6, 0)
    tierBar.Position         = UDim2.new(0, 0, 0.2, 0)
    tierBar.BackgroundColor3 = isHL and T.HighlightC or T.MidlightC
    Instance.new("UICorner", tierBar).CornerRadius = UDim.new(1, 0)

    -- ── LEFT SECTION (icon + name + value) ─────────────────────────────
    local Left = Instance.new("Frame", LogItem)
    Left.BackgroundTransparency = 1
    Left.Size     = UDim2.new(0.58, 0, 1, 0)
    Left.Position = UDim2.new(0, 10, 0, 0)

    local LL = Instance.new("UIListLayout", Left)
    LL.FillDirection      = Enum.FillDirection.Horizontal
    LL.VerticalAlignment  = Enum.VerticalAlignment.Center
    LL.Padding            = UDim.new(0, 7)

    -- Small icon (same as Moby)
    local Icon = Instance.new("ImageLabel", Left)
    Icon.Size                 = UDim2.new(0, 14, 0, 14)
    Icon.BackgroundTransparency = 1
    Icon.Image                = "rbxassetid://136959386531965"
    Icon.ImageColor3          = isHL and T.HighlightC or T.MidlightC

    -- Brainrot name
    local NameLbl = Instance.new("TextLabel", Left)
    NameLbl.BackgroundTransparency = 1
    NameLbl.AutomaticSize          = Enum.AutomaticSize.X
    NameLbl.Size                   = UDim2.new(0, 0, 1, 0)
    NameLbl.Font                   = Enum.Font.GothamMedium
    NameLbl.Text                   = data.name or "Unknown"
    NameLbl.TextColor3             = Color3.fromRGB(200, 200, 200)
    NameLbl.TextSize               = 12
    NameLbl.TextTruncate           = Enum.TextTruncate.AtEnd

    -- Value  e.g. "100M"  (Moby hero element)
    local baseMoneyStr = formatNumber(data.value or 0)
    local MoneyLbl = Instance.new("TextLabel", Left)
    MoneyLbl.BackgroundTransparency = 1
    MoneyLbl.AutomaticSize          = Enum.AutomaticSize.X
    MoneyLbl.Size                   = UDim2.new(0, 0, 1, 0)
    MoneyLbl.Font                   = Enum.Font.GothamBold
    MoneyLbl.Text                   = baseMoneyStr
    MoneyLbl.TextColor3             = T.White
    MoneyLbl.TextSize               = 13

    -- ── RIGHT SECTION (JOIN + FORCE) ───────────────────────────────────
    local Right = Instance.new("Frame", LogItem)
    Right.BackgroundTransparency = 1
    Right.Size     = UDim2.new(0.42, -10, 1, 0)
    Right.Position = UDim2.new(0.58, 0, 0, 0)

    local RL = Instance.new("UIListLayout", Right)
    RL.FillDirection         = Enum.FillDirection.Horizontal
    RL.HorizontalAlignment   = Enum.HorizontalAlignment.Right
    RL.VerticalAlignment     = Enum.VerticalAlignment.Center
    RL.Padding               = UDim.new(0, 6)

    -- JOIN button
    local jBtn = Instance.new("TextButton", Right)
    jBtn.Size             = UDim2.new(0, 50, 0, 26)
    jBtn.BackgroundColor3 = T.Accent1
    jBtn.Text             = "JOIN"
    jBtn.Font             = Enum.Font.GothamBold
    jBtn.TextSize         = 11
    jBtn.TextColor3       = T.White
    Instance.new("UICorner", jBtn).CornerRadius = UDim.new(0, 6)
    jBtn.MouseEnter:Connect(function() TweenService:Create(jBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(30,130,255)}):Play() end)
    jBtn.MouseLeave:Connect(function() TweenService:Create(jBtn, tweenInfo, {BackgroundColor3 = T.Accent1}):Play() end)

    -- FORCE button  (= ancien SPAM, renommé comme Moby)
    local fBtn = Instance.new("TextButton", Right)
    fBtn.Size             = UDim2.new(0, 56, 0, 26)
    fBtn.BackgroundColor3 = T.Accent1
    fBtn.Text             = "FORCE"
    fBtn.Font             = Enum.Font.GothamBold
    fBtn.TextSize         = 11
    fBtn.TextColor3       = T.White
    Instance.new("UICorner", fBtn).CornerRadius = UDim.new(0, 6)
    fBtn.MouseEnter:Connect(function() TweenService:Create(fBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(30,130,255)}):Play() end)
    fBtn.MouseLeave:Connect(function() TweenService:Create(fBtn, tweenInfo, {BackgroundColor3 = T.Accent1}):Play() end)

    jBtn.MouseButton1Click:Connect(function()
        if data.job_id then
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, data.job_id, lp) end)
            jBtn.Text = "..."
            jBtn.BackgroundColor3 = T.AccentGlow
            task.delay(1.5, function() jBtn.Text = "JOIN"; jBtn.BackgroundColor3 = T.Accent1 end)
        end
    end)
    fBtn.MouseButton1Click:Connect(function()
        if data.job_id then performJoinSpam(data.job_id) end
    end)

    -- Time ticker (updates each second)
    local baseStr = baseMoneyStr
    table.insert(activeLogs, {
        moneyLbl = MoneyLbl,
        baseStr  = baseStr,
        ts       = data.timestamp or math.floor(os.time())
    })

    -- Track for filter
    table.insert(LogEntries, {card=LogItem, isHL=isHL, numVal=data.value or 0})
    applyFilter()
end

-- ═══════════════════════════════════
-- SETTINGS PAGE
-- ═══════════════════════════════════
local SScroll = Instance.new("ScrollingFrame", SettingsPage)
SScroll.Size             = UDim2.new(1, 0, 1, 0)
SScroll.BackgroundTransparency = 1
SScroll.BorderSizePixel  = 0
SScroll.ScrollBarThickness     = 2
SScroll.ScrollBarImageColor3   = T.Off
SScroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y

local SLayout = Instance.new("UIListLayout", SScroll)
SLayout.Padding    = UDim.new(0, 8)
SLayout.SortOrder  = Enum.SortOrder.LayoutOrder

local SPad = Instance.new("UIPadding", SScroll)
SPad.PaddingTop   = UDim.new(0, 12)
SPad.PaddingLeft  = UDim.new(0, 12)
SPad.PaddingRight = UDim.new(0, 12)

local function makeHeader(text, parent)
    local h = Instance.new("TextLabel", parent)
    h.Size               = UDim2.new(1, 0, 0, 18)
    h.BackgroundTransparency = 1
    h.Text               = text
    h.TextXAlignment     = Enum.TextXAlignment.Left
    h.Font               = Enum.Font.GothamBold
    h.TextSize           = 10
    h.TextColor3         = T.Accent2
end

local function spacer(parent)
    local s = Instance.new("Frame", parent)
    s.Size             = UDim2.new(1, 0, 0, 4)
    s.BackgroundTransparency = 1
end

local function makeToggle(parent, text, key)
    local f = Instance.new("Frame", parent)
    f.Size             = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = T.BgCard
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", f)
    lbl.Size               = UDim2.new(1, -65, 1, 0)
    lbl.Position           = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Text               = text
    lbl.Font               = Enum.Font.GothamSemibold
    lbl.TextSize           = 13
    lbl.TextColor3         = T.White
    local track = Instance.new("TextButton", f)
    track.Size             = UDim2.new(0, 42, 0, 22)
    track.Position         = UDim2.new(1, -54, 0.5, -11)
    track.BackgroundColor3 = userSettings[key] and T.Accent1 or T.Off
    track.Text             = ""
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", track)
    dot.Size             = UDim2.new(0, 16, 0, 16)
    dot.Position         = userSettings[key] and UDim2.new(1,-19,0,3) or UDim2.new(0,3,0,3)
    dot.BackgroundColor3 = T.White
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    track.MouseButton1Click:Connect(function()
        userSettings[key] = not userSettings[key]
        local on = userSettings[key]
        TweenService:Create(dot,   TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = on and UDim2.new(1,-19,0,3) or UDim2.new(0,3,0,3)}):Play()
        TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = on and T.Accent1 or T.Off}):Play()
    end)
end

local function makeInput(parent, text, key)
    local f = Instance.new("Frame", parent)
    f.Size             = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = T.BgCard
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", f)
    lbl.Size               = UDim2.new(1, -65, 1, 0)
    lbl.Position           = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Text               = text
    lbl.Font               = Enum.Font.GothamSemibold
    lbl.TextSize           = 13
    lbl.TextColor3         = T.White
    local box = Instance.new("TextBox", f)
    box.Size             = UDim2.new(0, 34, 0, 26)
    box.Position         = UDim2.new(1, -50, 0.5, -13)
    box.BackgroundColor3 = T.Off
    box.Text             = tostring(userSettings[key])
    box.Font             = Enum.Font.GothamBold
    box.TextSize         = 13
    box.TextColor3       = T.White
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v and v > 0 then userSettings[key] = math.floor(v) else box.Text = tostring(userSettings[key]) end
    end)
end

local KeyHint
local function makeKeybindSetting(parent, text)
    local f = Instance.new("Frame", parent)
    f.Size             = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = T.BgCard
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", f)
    lbl.Size               = UDim2.new(1, -100, 1, 0)
    lbl.Position           = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Text               = text
    lbl.Font               = Enum.Font.GothamSemibold
    lbl.TextSize           = 13
    lbl.TextColor3         = T.White
    local btn = Instance.new("TextButton", f)
    btn.Size             = UDim2.new(0, 80, 0, 26)
    btn.Position         = UDim2.new(1, -96, 0.5, -13)
    btn.BackgroundColor3 = T.Off
    btn.Text             = tostring(userSettings.ToggleKey)
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 11
    btn.TextColor3       = T.Accent2
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    KeyHint = btn
    local connection
    btn.MouseButton1Click:Connect(function()
        btn.Text = "..."
        if connection then connection:Disconnect() end
        connection = UserInputService.InputBegan:Connect(function(input, gpe)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                userSettings.ToggleKey = input.KeyCode.Name
                btn.Text = input.KeyCode.Name
                connection:Disconnect(); connection = nil
            end
        end)
    end)
end

local function makeActionBtn(parent, text, callback)
    local f = Instance.new("Frame", parent)
    f.Size             = UDim2.new(1, 0, 0, 42)
    f.BackgroundColor3 = T.BgCardHover
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local btn = Instance.new("TextButton", f)
    btn.Size               = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text               = text
    btn.Font               = Enum.Font.GothamBold
    btn.TextSize           = 13
    btn.TextColor3         = T.White
    btn.MouseButton1Click:Connect(function() callback(btn) end)
end

makeHeader("── UI SETTINGS", SScroll)
makeKeybindSetting(SScroll, "Toggle GUI Keybind")
spacer(SScroll)
makeHeader("── FILTERS", SScroll)
makeToggle(SScroll, "Receive Midlights",    "Midlights")
makeToggle(SScroll, "Receive Highlights",   "Highlights")
spacer(SScroll)
makeHeader("── NOTIFICATIONS", SScroll)
makeToggle(SScroll, "Play Sound on New Log","PlaySound")
spacer(SScroll)
makeHeader("── JOIN SETTINGS", SScroll)
makeInput(SScroll,  "Join Spam Retries",    "AutoJoinRetries")
spacer(SScroll)
makeHeader("── DATA", SScroll)
makeActionBtn(SScroll, "💾  Save All Settings", function(btn)
    btn.Text = "Saving..."
    pcall(function() if writefile then writefile(CONFIG_FILE, HttpService:JSONEncode(userSettings)) end end)
    task.delay(0.5, function()
        btn.Text = "Saved!"
        task.delay(1.2, function() btn.Text = "💾  Save All Settings" end)
    end)
end)

-- ═══════════════════════════════════
-- WHITELIST PAGE
-- ═══════════════════════════════════
local WLTop = Instance.new("Frame", WhitelistPage)
WLTop.Size               = UDim2.new(1, 0, 0, 52)
WLTop.BackgroundTransparency = 1

local wlPanel = Instance.new("Frame", WLTop)
wlPanel.Size             = UDim2.new(1, 0, 0, 36)
wlPanel.Position         = UDim2.new(0, 0, 0, 8)
wlPanel.BackgroundColor3 = T.BgCard
Instance.new("UICorner", wlPanel).CornerRadius = UDim.new(0, 8)

local wlStroke = Instance.new("UIStroke", wlPanel)
wlStroke.Color     = T.Off
wlStroke.Thickness = 1

local wlLbl = Instance.new("TextLabel", wlPanel)
wlLbl.Size               = UDim2.new(0, 90, 1, 0)
wlLbl.Position           = UDim2.new(0, 12, 0, 0)
wlLbl.BackgroundTransparency = 1
wlLbl.Text               = "Use Whitelist"
wlLbl.Font               = Enum.Font.GothamBold
wlLbl.TextXAlignment     = Enum.TextXAlignment.Left
wlLbl.TextSize           = 12
wlLbl.TextColor3         = T.White

local wlTrack = Instance.new("TextButton", wlPanel)
wlTrack.Size             = UDim2.new(0, 32, 0, 18)
wlTrack.Position         = UDim2.new(0, 104, 0.5, -9)
wlTrack.BackgroundColor3 = userSettings.UseWhitelist and T.Accent1 or T.Off
wlTrack.Text             = ""
Instance.new("UICorner", wlTrack).CornerRadius = UDim.new(1, 0)
local wlDot = Instance.new("Frame", wlTrack)
wlDot.Size             = UDim2.new(0, 12, 0, 12)
wlDot.Position         = userSettings.UseWhitelist and UDim2.new(1,-15,0,3) or UDim2.new(0,3,0,3)
wlDot.BackgroundColor3 = T.White
Instance.new("UICorner", wlDot).CornerRadius = UDim.new(1, 0)
wlTrack.MouseButton1Click:Connect(function()
    userSettings.UseWhitelist = not userSettings.UseWhitelist
    local on = userSettings.UseWhitelist
    TweenService:Create(wlDot,   TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = on and UDim2.new(1,-15,0,3) or UDim2.new(0,3,0,3)}):Play()
    TweenService:Create(wlTrack, TweenInfo.new(0.15), {BackgroundColor3 = on and T.Accent1 or T.Off}):Play()
    TweenService:Create(wlStroke,TweenInfo.new(0.2),  {Color = on and T.Accent1 or T.Off}):Play()
end)

local WLAll = Instance.new("TextButton", wlPanel)
WLAll.Size             = UDim2.new(0, 28, 0, 18)
WLAll.Position         = UDim2.new(0, 140, 0.5, -9)
WLAll.BackgroundColor3 = T.GreenDim
WLAll.Text             = "All"
WLAll.Font             = Enum.Font.GothamBold
WLAll.TextSize         = 10
WLAll.TextColor3       = T.Green
Instance.new("UICorner", WLAll).CornerRadius = UDim.new(0, 4)

local WLNone = Instance.new("TextButton", wlPanel)
WLNone.Size             = UDim2.new(0, 36, 0, 18)
WLNone.Position         = UDim2.new(0, 172, 0.5, -9)
WLNone.BackgroundColor3 = Color3.fromRGB(60,25,25)
WLNone.Text             = "None"
WLNone.Font             = Enum.Font.GothamBold
WLNone.TextSize         = 10
WLNone.TextColor3       = T.HighlightC
Instance.new("UICorner", WLNone).CornerRadius = UDim.new(0, 4)

local WLSearch = Instance.new("TextBox", wlPanel)
WLSearch.Size             = UDim2.new(0, 90, 0, 22)
WLSearch.Position         = UDim2.new(1, -98, 0.5, -11)
WLSearch.BackgroundColor3 = T.BgDark
WLSearch.Text             = ""
WLSearch.PlaceholderText  = "Search..."
WLSearch.Font             = Enum.Font.Gotham
WLSearch.TextSize         = 11
WLSearch.TextColor3       = T.White
Instance.new("UICorner", WLSearch).CornerRadius = UDim.new(0, 5)

local WLContent = Instance.new("ScrollingFrame", WhitelistPage)
WLContent.Size             = UDim2.new(1, 0, 1, -52)
WLContent.Position         = UDim2.new(0, 0, 0, 52)
WLContent.BackgroundTransparency = 1
WLContent.BorderSizePixel  = 0
WLContent.ScrollBarThickness     = 2
WLContent.ScrollBarImageColor3   = T.Off
WLContent.AutomaticCanvasSize    = Enum.AutomaticSize.Y

local WLLayout = Instance.new("UIListLayout", WLContent)
WLLayout.Padding   = UDim.new(0, 5)

local WLPad = Instance.new("UIPadding", WLContent)
WLPad.PaddingLeft  = UDim.new(0, 12)
WLPad.PaddingRight = UDim.new(0, 12)
WLPad.PaddingTop   = UDim.new(0, 6)

local wlItems = {}

local function createWLEntry(name)
    local f = Instance.new("Frame", WLContent)
    f.Size             = UDim2.new(1, 0, 0, 34)
    f.BackgroundColor3 = T.BgCard
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local line = Instance.new("Frame", f)
    line.BackgroundColor3 = T.Off
    line.BorderSizePixel  = 0
    line.Size             = UDim2.new(1, 0, 0, 1)
    line.Position         = UDim2.new(0, 0, 1, -1)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size               = UDim2.new(1, -60, 1, 0)
    lbl.Position           = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Text               = name
    lbl.Font               = Enum.Font.GothamSemibold
    lbl.TextSize           = 12
    lbl.TextColor3         = T.White

    local track = Instance.new("TextButton", f)
    track.Size             = UDim2.new(0, 32, 0, 18)
    track.Position         = UDim2.new(1, -44, 0.5, -9)
    track.BackgroundColor3 = userSettings.Whitelist[name] and T.Accent1 or T.Off
    track.Text             = ""
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", track)
    dot.Size             = UDim2.new(0, 12, 0, 12)
    dot.Position         = userSettings.Whitelist[name] and UDim2.new(1,-15,0,3) or UDim2.new(0,3,0,3)
    dot.BackgroundColor3 = T.White
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local function setVisuals(on, anim)
        if anim then
            TweenService:Create(dot,   TweenInfo.new(0.15), {Position = on and UDim2.new(1,-15,0,3) or UDim2.new(0,3,0,3)}):Play()
            TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = on and T.Accent1 or T.Off}):Play()
        else
            dot.Position         = on and UDim2.new(1,-15,0,3) or UDim2.new(0,3,0,3)
            track.BackgroundColor3= on and T.Accent1 or T.Off
        end
    end

    track.MouseButton1Click:Connect(function()
        userSettings.Whitelist[name] = not userSettings.Whitelist[name]
        setVisuals(userSettings.Whitelist[name], true)
    end)

    return {frame=f, name=string.lower(name), rawName=name, update=setVisuals}
end

for _, v in ipairs(allBrainrots) do
    table.insert(wlItems, createWLEntry(v))
end

WLSearch.Changed:Connect(function(prop)
    if prop == "Text" then
        local q = string.lower(WLSearch.Text)
        for _, itm in ipairs(wlItems) do
            itm.frame.Visible = q == "" or (string.find(itm.name, q, 1, true) ~= nil)
        end
    end
end)

WLAll.MouseButton1Click:Connect(function()
    for _, itm in ipairs(wlItems) do
        if itm.frame.Visible then userSettings.Whitelist[itm.rawName] = true; itm.update(true, true) end
    end
end)
WLNone.MouseButton1Click:Connect(function()
    for _, itm in ipairs(wlItems) do
        if itm.frame.Visible then userSettings.Whitelist[itm.rawName] = false; itm.update(false, true) end
    end
end)

-- ═══════════════════════════════════
-- PROFILE PAGE
-- ═══════════════════════════════════
local ProfileTitle = Instance.new("TextLabel", ProfilePage)
ProfileTitle.BackgroundTransparency = 1
ProfileTitle.Position = UDim2.new(0, 12, 0, 12)
ProfileTitle.Size     = UDim2.new(1, -24, 0, 28)
ProfileTitle.Font     = Enum.Font.GothamBold
ProfileTitle.Text     = "Profile & Community"
ProfileTitle.TextColor3 = T.White
ProfileTitle.TextSize = 16
ProfileTitle.TextXAlignment = Enum.TextXAlignment.Left

local ProfileCard = Instance.new("Frame", ProfilePage)
ProfileCard.BackgroundColor3 = T.BgCard
ProfileCard.Position = UDim2.new(0, 12, 0, 46)
ProfileCard.Size     = UDim2.new(1, -24, 0, 78)
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", ProfileCard).Color = T.Off

local AvatarOuter = Instance.new("Frame", ProfileCard)
AvatarOuter.BackgroundColor3 = T.Off
AvatarOuter.Position = UDim2.new(0, 14, 0.5, -22)
AvatarOuter.Size     = UDim2.new(0, 44, 0, 44)
Instance.new("UICorner", AvatarOuter).CornerRadius = UDim.new(1, 0)

local AvatarImage = Instance.new("ImageLabel", AvatarOuter)
AvatarImage.BackgroundColor3 = T.BgCard
AvatarImage.AnchorPoint = Vector2.new(0.5, 0.5)
AvatarImage.Position    = UDim2.new(0.5, 0, 0.5, 0)
AvatarImage.Size        = UDim2.new(1, -2, 1, -2)
AvatarImage.Image       = "rbxthumb://type=AvatarHeadShot&id="..lp.UserId.."&w=150&h=150"
Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(1, 0)

local DisplayName = Instance.new("TextLabel", ProfileCard)
DisplayName.BackgroundTransparency = 1
DisplayName.Position = UDim2.new(0, 68, 0, 14)
DisplayName.Size     = UDim2.new(0, 200, 0, 22)
DisplayName.Font     = Enum.Font.GothamBlack
DisplayName.Text     = lp.DisplayName
DisplayName.TextColor3 = T.White
DisplayName.TextSize = 16
DisplayName.TextXAlignment = Enum.TextXAlignment.Left

local Username = Instance.new("TextLabel", ProfileCard)
Username.BackgroundTransparency = 1
Username.Position = UDim2.new(0, 68, 0, 40)
Username.Size     = UDim2.new(0, 200, 0, 16)
Username.Font     = Enum.Font.GothamMedium
Username.Text     = "@" .. lp.Name
Username.TextColor3 = T.TextDim
Username.TextSize = 12
Username.TextXAlignment = Enum.TextXAlignment.Left

local DiscordCard = Instance.new("Frame", ProfilePage)
DiscordCard.BackgroundColor3 = T.BgCard
DiscordCard.Position = UDim2.new(0, 12, 0, 140)
DiscordCard.Size     = UDim2.new(1, -24, 0, 56)
Instance.new("UICorner", DiscordCard).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", DiscordCard).Color = T.Off

local DcIcon = Instance.new("ImageLabel", DiscordCard)
DcIcon.BackgroundTransparency = 1
DcIcon.Position = UDim2.new(0, 18, 0.5, -11)
DcIcon.Size     = UDim2.new(0, 22, 0, 22)
DcIcon.Image    = "rbxassetid://77743122983414"

local DcText = Instance.new("TextLabel", DiscordCard)
DcText.BackgroundTransparency = 1
DcText.Position = UDim2.new(0, 50, 0, 0)
DcText.Size     = UDim2.new(0, 150, 1, 0)
DcText.Font     = Enum.Font.GothamBold
DcText.Text     = "FX's Community"
DcText.TextColor3 = T.White
DcText.TextSize = 14
DcText.TextXAlignment = Enum.TextXAlignment.Left

local CopyBtn = Instance.new("TextButton", DiscordCard)
CopyBtn.BackgroundColor3 = T.Accent1
CopyBtn.Position = UDim2.new(1, -82, 0.5, -13)
CopyBtn.Size     = UDim2.new(0, 68, 0, 26)
CopyBtn.Font     = Enum.Font.GothamBold
CopyBtn.Text     = "Copy Link"
CopyBtn.TextColor3 = T.White
CopyBtn.TextSize = 11
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)
CopyBtn.MouseEnter:Connect(function() TweenService:Create(CopyBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(30,130,255)}):Play() end)
CopyBtn.MouseLeave:Connect(function() TweenService:Create(CopyBtn, tweenInfo, {BackgroundColor3 = T.Accent1}):Play() end)
CopyBtn.MouseButton1Click:Connect(function()
    playClick()
    pcall(function() setclipboard("https://discord.gg/yourlink") end)
    CopyBtn.Text = "Copied!"
    TweenService:Create(CopyBtn, tweenInfo, {BackgroundColor3 = T.Green}):Play()
    task.wait(1.5)
    CopyBtn.Text = "Copy Link"
    TweenService:Create(CopyBtn, tweenInfo, {BackgroundColor3 = T.Accent1}):Play()
end)

-- ═══════════════════════════════════
-- NOTIFICATIONS CONTAINER
-- ═══════════════════════════════════
local NC = Instance.new("Frame", ScreenGui)
NC.Name               = "NotifContainer"
NC.Size               = UDim2.new(0, 260, 1, -40)
NC.Position           = UDim2.new(1, -280, 0, 20)
NC.BackgroundTransparency = 1

local NLayout = Instance.new("UIListLayout", NC)
NLayout.SortOrder         = Enum.SortOrder.LayoutOrder
NLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NLayout.Padding           = UDim.new(0, 8)

local function pushNotification(data)
    playNotifSound()
    local isHL = data.tier == "Highlights"
    local f = Instance.new("TextButton", NC)
    f.Size             = UDim2.new(1, 0, 0, 52)
    f.BackgroundColor3 = T.BgMid
    f.BackgroundTransparency = 1
    f.Text             = ""
    f.AutoButtonColor  = false
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local nStroke = Instance.new("UIStroke", f)
    nStroke.Thickness   = 1
    nStroke.Color       = isHL and T.HighlightC or T.MidlightC
    nStroke.Transparency= 1

    local bar = Instance.new("Frame", f)
    bar.Size             = UDim2.new(0, 3, 0.65, 0)
    bar.Position         = UDim2.new(0, 6, 0.175, 0)
    bar.BackgroundColor3 = isHL and T.HighlightC or T.MidlightC
    bar.BackgroundTransparency = 1
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local t = Instance.new("TextLabel", f)
    t.Size               = UDim2.new(1, -80, 0, 16)
    t.Position           = UDim2.new(0, 16, 0, 8)
    t.BackgroundTransparency = 1
    t.TextXAlignment     = Enum.TextXAlignment.Left
    t.TextTruncate       = Enum.TextTruncate.AtEnd
    t.Text               = data.name or "Unknown"
    t.Font               = Enum.Font.GothamBold
    t.TextSize           = 12
    t.TextColor3         = T.White
    t.TextTransparency   = 1
    t.ZIndex             = 2

    local now  = math.floor(os.time())
    local diff = math.max(0, now - (data.timestamp or now))
    local tStr = diff < 60 and (diff.."s ago") or (math.floor(diff/60).."m ago")

    local v = Instance.new("TextLabel", f)
    v.Size               = UDim2.new(1, -80, 0, 14)
    v.Position           = UDim2.new(0, 16, 0, 27)
    v.BackgroundTransparency = 1
    v.TextXAlignment     = Enum.TextXAlignment.Left
    v.Text               = formatNumber(data.value or 0) .. "  ·  " .. (data.tier or "") .. "  •  " .. tStr
    v.Font               = Enum.Font.Gotham
    v.TextSize           = 10
    v.TextColor3         = T.TextDim
    v.TextTransparency   = 1
    v.ZIndex             = 2

    local jn = Instance.new("TextButton", f)
    jn.Size             = UDim2.new(0, 44, 0, 22)
    jn.Position         = UDim2.new(1, -54, 0.5, -11)
    jn.BackgroundColor3 = T.Accent1
    jn.BackgroundTransparency = 1
    jn.Text             = "JOIN"
    jn.Font             = Enum.Font.GothamBold
    jn.TextSize         = 10
    jn.TextColor3       = T.Accent2
    jn.TextTransparency = 1
    jn.AutoButtonColor  = false
    jn.ZIndex           = 2
    Instance.new("UICorner", jn).CornerRadius = UDim.new(0, 5)

    local function doJoin()
        if data.job_id then
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, data.job_id, lp) end)
            jn.Text = "..."
        end
    end
    f.MouseButton1Click:Connect(doJoin)
    jn.MouseButton1Click:Connect(doJoin)

    TweenService:Create(f,      TweenInfo.new(0.35, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(nStroke,TweenInfo.new(0.35), {Transparency = 0.6}):Play()
    TweenService:Create(bar,    TweenInfo.new(0.35), {BackgroundTransparency = 0}):Play()
    TweenService:Create(t,      TweenInfo.new(0.35), {TextTransparency = 0}):Play()
    TweenService:Create(v,      TweenInfo.new(0.35), {TextTransparency = 0}):Play()
    TweenService:Create(jn,     TweenInfo.new(0.35), {TextTransparency = 0, BackgroundTransparency = 0.15}):Play()

    task.delay(4.5, function()
        if f and f.Parent then
            TweenService:Create(f,      TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(nStroke,TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(bar,    TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(t,      TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(v,      TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            local fo = TweenService:Create(jn, TweenInfo.new(0.3), {TextTransparency = 1, BackgroundTransparency = 1})
            fo:Play()
            fo.Completed:Connect(function() f:Destroy() end)
        end
    end)
end

-- ═══════════════════════════════════
-- SELF ESP
-- ═══════════════════════════════════
local function createSelfESP(char)
    task.spawn(function()
        local head = char:WaitForChild("Head", 10)
        if not head then return end
        if head:FindFirstChild("FX_USER_ESP") then head.FX_USER_ESP:Destroy() end

        local bg = Instance.new("BillboardGui", head)
        bg.Name        = "FX_USER_ESP"
        bg.Size        = UDim2.new(0, 130, 0, 30)
        bg.StudsOffset = Vector3.new(0, 2.8, 0)
        bg.AlwaysOnTop = true

        local badge = Instance.new("Frame", bg)
        badge.Size             = UDim2.new(1, 0, 1, 0)
        badge.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
        badge.BackgroundTransparency = 0.2
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)

        local bStroke = Instance.new("UIStroke", badge)
        bStroke.Thickness = 1.5
        bStroke.Color     = T.Accent1
        table.insert(espStrokes, bStroke)

        local txt = Instance.new("TextLabel", badge)
        txt.Size               = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Text               = "FX USER"
        txt.Font               = Enum.Font.GothamBlack
        txt.TextSize           = 13
        txt.TextColor3         = T.White
    end)
end

if lp.Character then createSelfESP(lp.Character) end
lp.CharacterAdded:Connect(createSelfESP)

-- ═══════════════════════════════════
-- SYNC FX USERS
-- ═══════════════════════════════════
local function SyncFXUsers()
    local url  = "https://api.npoint.io/27ddc088b60248893e5d"
    local myId = tostring(lp.UserId)
    local function req(opts)
        if syn and syn.request then return syn.request(opts)
        elseif request then return request(opts)
        elseif http_request then return http_request(opts)
        else return {Body = game:HttpGet(opts.Url, true)} end
    end
    while _G.FXRunning ~= false do
        pcall(function()
            local res = req({Url=url, Method="GET"})
            if not res or not res.Body then return end
            local data = HttpService:JSONDecode(res.Body)
            if type(data) ~= "table" then data = {} end
            if type(data.users) ~= "table" then data.users = {} end
            if not data.users[myId] then
                data.users[myId] = true
                req({Url=url, Method="POST", Headers={["Content-Type"]="application/json"}, Body=HttpService:JSONEncode(data)})
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and data.users[tostring(p.UserId)] then
                    if p.Character and not p.Character:FindFirstChild("FX_USER_ESP", true) then
                        createSelfESP(p.Character)
                    end
                end
            end
        end)
        task.wait(10)
    end
end
task.spawn(SyncFXUsers)

-- ═══════════════════════════════════
-- CHROMA LOOP
-- ═══════════════════════════════════
_G.FXRunning = true

task.spawn(function()
    while _G.FXRunning do
        local tk    = tick()
        local phase = (math.sin(tk * 0.8) + 1) / 2
        local r     = math.floor(40  + phase * 100)
        local g     = math.floor(100 + phase * 120)
        local b     = math.floor(200 + phase * 55)
        local color = Color3.fromRGB(r, g, b)

        BorderGrad.Rotation = (tk * 60) % 360
        BorderGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0,   color),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200,230,255)),
            ColorSequenceKeypoint.new(1,   color)
        }

        Logo.TextColor3 = color

        for k, v in pairs(tabButtons) do
            if k == activeTab then v.ind.BackgroundColor3 = color end
        end

        for _, strk in ipairs(espStrokes) do
            if strk and strk.Parent then strk.Color = color end
        end

        if userSettings.AutoJoin then ajPulse.BackgroundColor3 = color end
        if MobileToggle and MobileToggle.Parent then
            MobileToggle.TextColor3 = color
            if mtStroke then mtStroke.Color = color end
        end

        task.wait(0.04)
    end
end)

-- ═══════════════════════════════════
-- TIME UPDATER  (met à jour MoneyLbl : "100M  •  5s ago")
-- ═══════════════════════════════════
task.spawn(function()
    while _G.FXRunning do
        local now = math.floor(os.time())
        for i = #activeLogs, 1, -1 do
            local ld = activeLogs[i]
            if not ld.moneyLbl or not ld.moneyLbl.Parent then
                table.remove(activeLogs, i)
            else
                local diff = math.max(0, now - ld.ts)
                local tStr = diff < 60 and (diff.."s ago") or (diff < 3600 and math.floor(diff/60).."m ago" or math.floor(diff/3600).."h ago")
                -- affiche "100M  •  5s ago" dans le label Money (style Moby compact)
                ld.moneyLbl.Text = ld.baseStr .. "  •  " .. tStr
            end
        end
        task.wait(1)
    end
end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- DATA FETCHING (Complete & Fixed)
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

-- 1. Setup Variables
local URL = "https://ws.vanishnotifier.org/recent"
local seenIds = {}
_G.FXRunning = true 


local function handleData(findings)
    for _, d in ipairs(findings) do
        if not seenIds[d.id] then
            seenIds[d.id] = true
            
            addLogEntry(d)
            
            -- Only notify/autojoin if the user enabled that Tier (Highlights/Midlights)
            if userSettings[d.tier] then
                pushNotification(d)
                
                -- AutoJoin Logic
                if userSettings.AutoJoin and d.job_id then
                    local passesWhitelist = true
                    if userSettings.UseWhitelist then
                        if not d.base_name or not userSettings.Whitelist[d.base_name] then
                            passesWhitelist = false
                        end
                    end
                    if passesWhitelist then performJoinSpam(d.job_id) end
                end
            end
        end
    end
end

task.spawn(function()
    print("FX's Finder: Fetching sequence started...")
    
    while _G.FXRunning do
        
        task.spawn(function()
            local success, response = pcall(function()
                local reqUrl = URL .. "?t=" .. tostring(tick())
                local headers = {["Cache-Control"]="no-cache", ["User-Agent"]="Roblox/FXFinder"}
                
                if syn and syn.request then
                    return syn.request({Url=reqUrl, Method="GET", Headers=headers})
                elseif request then
                    return request({Url=reqUrl, Method="GET", Headers=headers})
                elseif http_request then
                    return http_request({Url=reqUrl, Method="GET", Headers=headers})
                else
                    return {Body = game:HttpGet(reqUrl, true)}
                end
            end)

            if success and response and response.Body then
                local res = HttpService:JSONDecode(response.Body)
                if res and res.ok and res.findings then 
                    handleData(res.findings) 
                end
            end
        end)

        task.wait(3) 
    end
end)