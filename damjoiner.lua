-- Sources Hub Dump - 2026-04-22 08:41:58

local FIREBASE_URL = "..."

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ContentProvider = game:GetService("ContentProvider")

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local GuiName = "RexzyFreeGui"

for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == GuiName then v:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GuiName
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local function playClick() end

local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local dragTweenInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local TARGET_SCALE = isMobile and 0.82 or 1.0
local HIDE_SCALE = TARGET_SCALE - 0.15

-- ========================
-- ACCENT COLOR: #BBEEFF
-- ========================
local ACCENT = Color3.fromRGB(187, 238, 255)
local ACCENT_HOVER = Color3.fromRGB(160, 220, 245)
local ACCENT_TEXT = Color3.fromRGB(10, 30, 40)
local BG_COLOR = Color3.fromRGB(5, 5, 5)
local BG_TRANSPARENCY = 0.08

-- ========================
-- SETTINGS STATE
-- ========================
local MinFilterValue = 0
local Blacklist = {}
local Whitelist = {}
local HighlightAJEnabled = false
local autoJoinEnabled = false
local isStarted = false

-- ========================
-- MINIMIZE BUTTON
-- ========================
local MinimizeBtn = Instance.new("TextButton", ScreenGui)
MinimizeBtn.Name = "MinimizeToggle"
MinimizeBtn.BackgroundColor3 = ACCENT
MinimizeBtn.BackgroundTransparency = 0.15
MinimizeBtn.Position = UDim2.new(0, 10, 0.5, -20)
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Text = "R"
MinimizeBtn.TextColor3 = ACCENT_TEXT
MinimizeBtn.Font = Enum.Font.GothamBlack
MinimizeBtn.TextSize = 20
MinimizeBtn.Visible = false
MinimizeBtn.ZIndex = 10
MinimizeBtn.Active = true
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 10)
local minStroke = Instance.new("UIStroke", MinimizeBtn)
minStroke.Color = ACCENT
minStroke.Thickness = 1.5

local minDragging = false
local minDragStart, minStartPos
MinimizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        minDragging = true
        minDragStart = input.Position
        minStartPos = MinimizeBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then minDragging = false end
        end)
    end
end)
MinimizeBtn.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        if minDragging and minDragStart and minStartPos then
            local delta = input.Position - minDragStart
            MinimizeBtn.Position = UDim2.new(minStartPos.X.Scale, minStartPos.X.Offset + delta.X, minStartPos.Y.Scale, minStartPos.Y.Offset + delta.Y)
        end
    end
end)


-- ========================
-- MAIN FRAME
-- ========================
local Frame = Instance.new("CanvasGroup", ScreenGui)
Frame.BackgroundColor3 = BG_COLOR
Frame.BackgroundTransparency = BG_TRANSPARENCY
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, -303, 0.5, -182)
Frame.Size = UDim2.new(0, 606, 0, 365)
Frame.Active = true
Frame.GroupTransparency = 1

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 9)
local UIScale = Instance.new("UIScale", Frame)
UIScale.Scale = HIDE_SCALE

local frameStroke = Instance.new("UIStroke", Frame)
frameStroke.Color = ACCENT
frameStroke.Thickness = 1.2
frameStroke.Transparency = 0.5

-- Animate in
TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = TARGET_SCALE}):Play()

-- ========================
-- HEADER: Top-left corner, bigger & stretched, with avatar
-- ========================
local HeaderBar = Instance.new("Frame", Frame)
HeaderBar.BackgroundTransparency = 1
HeaderBar.Position = UDim2.new(0, 10, 0, 6)
HeaderBar.Size = UDim2.new(0, 350, 0, 58)

-- Avatar circle
local AvatarHolder = Instance.new("Frame", HeaderBar)
AvatarHolder.BackgroundColor3 = Color3.fromRGB(20, 30, 35)
AvatarHolder.Position = UDim2.new(0, 0, 0, 3)
AvatarHolder.Size = UDim2.new(0, 48, 0, 48)
Instance.new("UICorner", AvatarHolder).CornerRadius = UDim.new(1, 0)
local avatarStroke = Instance.new("UIStroke", AvatarHolder)
avatarStroke.Color = ACCENT
avatarStroke.Thickness = 1.5
avatarStroke.Transparency = 0.3

local AvatarImg = Instance.new("ImageLabel", AvatarHolder)
AvatarImg.BackgroundTransparency = 1
AvatarImg.Size = UDim2.new(1, -4, 1, -4)
AvatarImg.Position = UDim2.new(0, 2, 0, 2)
AvatarImg.ScaleType = Enum.ScaleType.Crop
AvatarImg.Image = ""
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

local AvatarFallback = Instance.new("TextLabel", AvatarHolder)
AvatarFallback.BackgroundTransparency = 1
AvatarFallback.Size = UDim2.new(1, 0, 1, 0)
AvatarFallback.Font = Enum.Font.GothamBlack
AvatarFallback.Text = string.sub(Player.DisplayName, 1, 1):upper()
AvatarFallback.TextColor3 = ACCENT
AvatarFallback.TextSize = 22
AvatarFallback.ZIndex = 1

-- Robust avatar loader - uses IsLoaded to actually verify image rendered
task.spawn(function()
    local uid = Player.UserId

    -- Helper: set image, wait, check if it actually loaded
    local function trySet(url)
        local ok = pcall(function() AvatarImg.Image = url end)
        if not ok then return false end
        -- Wait for image to load with timeout
        local start = tick()
        while tick() - start < 2 do
            local loaded = pcall(function() return AvatarImg.IsLoaded end)
            if loaded and AvatarImg.IsLoaded then
                AvatarFallback.Visible = false
                return true
            end
            task.wait(0.15)
        end
        AvatarImg.Image = ""
        return false
    end

    -- Helper: use GetUserThumbnailAsync
    local function tryAsync(thumbType, thumbSize)
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(uid, thumbType, thumbSize)
        end)
        if ok and content and content ~= "" then
            return trySet(content)
        end
        return false
    end

    -- Helper: use HTTP API to get image URL
    local function tryHttp(endpoint)
        local ok, response = pcall(function() return game:HttpGet(endpoint) end)
        if ok and response then
            local ok2, decoded = pcall(function() return HttpService:JSONDecode(response) end)
            if ok2 and decoded and decoded.data and decoded.data[1] and decoded.data[1].imageUrl then
                return trySet(decoded.data[1].imageUrl)
            end
        end
        return false
    end

    -- Helper: use ContentProvider to preload then set
    local function tryPreload(url)
        local ok = pcall(function()
            local img = Instance.new("ImageLabel")
            img.Image = url
            ContentProvider:PreloadAsync({img})
            img:Destroy()
        end)
        if ok then return trySet(url) end
        return false
    end

    -- Method 1-4: rbxthumb headshot various sizes
    if trySet("rbxthumb://type=AvatarHeadShot&id="..uid.."&w=150&h=150") then return end
    if trySet("rbxthumb://type=AvatarHeadShot&id="..uid.."&w=420&h=420") then return end
    if trySet("rbxthumb://type=AvatarHeadShot&id="..uid.."&w=100&h=100") then return end
    if trySet("rbxthumb://type=AvatarHeadShot&id="..uid.."&w=352&h=352") then return end
    -- Method 5-6: rbxthumb bust
    if trySet("rbxthumb://type=AvatarBust&id="..uid.."&w=150&h=150") then return end
    if trySet("rbxthumb://type=AvatarBust&id="..uid.."&w=420&h=420") then return end
    -- Method 7-8: rbxthumb full
    if trySet("rbxthumb://type=Avatar&id="..uid.."&w=150&h=150") then return end
    if trySet("rbxthumb://type=Avatar&id="..uid.."&w=420&h=420") then return end
    -- Method 9-14: GetUserThumbnailAsync
    if tryAsync(Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) then return end
    if tryAsync(Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) then return end
    if tryAsync(Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) then return end
    if tryAsync(Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) then return end
    if tryAsync(Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150) then return end
    if tryAsync(Enum.ThumbnailType.AvatarThumbnail, Enum.ThumbnailSize.Size150x150) then return end
    -- Method 15-19: HTTP thumbnail API
    if tryHttp("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="..uid.."&size=150x150&format=Png&isCircular=false") then return end
    if tryHttp("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="..uid.."&size=352x352&format=Png&isCircular=false") then return end
    if tryHttp("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="..uid.."&size=420x420&format=Png&isCircular=false") then return end
    if tryHttp("https://thumbnails.roblox.com/v1/users/avatar-bust?userIds="..uid.."&size=150x150&format=Png&isCircular=false") then return end
    if tryHttp("https://thumbnails.roblox.com/v1/users/avatar?userIds="..uid.."&size=150x150&format=Png&isCircular=false") then return end
    -- Method 20: ContentProvider preload
    if tryPreload("rbxthumb://type=AvatarHeadShot&id="..uid.."&w=150&h=150") then return end
    -- Method 21: Character head face texture
    pcall(function()
        if Player.Character and Player.Character:FindFirstChild("Head") then
            local head = Player.Character.Head
            local face = head:FindFirstChildOfClass("Decal") or head:FindFirstChild("face")
            if face and face.Texture and face.Texture ~= "" then
                if trySet(face.Texture) then return end
            end
        end
    end)
    -- Method 22: Wait for character then try face
    pcall(function()
        local char = Player.Character or Player.CharacterAdded:Wait()
        task.wait(2)
        if char and char:FindFirstChild("Head") then
            local face = char.Head:FindFirstChildOfClass("Decal") or char.Head:FindFirstChild("face")
            if face and face.Texture and face.Texture ~= "" then
                trySet(face.Texture)
            end
        end
    end)
end)

-- Title (bigger, stretched, top-left corner)
local TitleLabel = Instance.new("TextLabel", HeaderBar)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 58, 0, 2)
TitleLabel.Size = UDim2.new(0, 280, 0, 32)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Text = "Rexzy Free"
TitleLabel.TextColor3 = ACCENT
TitleLabel.TextSize = 24
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle (bigger)
local SubtitleLabel = Instance.new("TextLabel", HeaderBar)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Position = UDim2.new(0, 58, 0, 32)
SubtitleLabel.Size = UDim2.new(0, 280, 0, 22)
SubtitleLabel.Font = Enum.Font.GothamBold
SubtitleLabel.Text = "discord.gg/joiner"
SubtitleLabel.TextColor3 = Color3.fromRGB(130, 180, 200)
SubtitleLabel.TextSize = 15
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ========================
-- CONTENT AREA
-- ========================
local ContentArea = Instance.new("Frame", Frame)
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 155, 0, 75)
ContentArea.Size = UDim2.new(0, 435, 0, 275)

-- ========================
-- LOGS PAGE
-- ========================
local LogsPage = Instance.new("Frame", ContentArea)
LogsPage.Name = "LogsPage"
LogsPage.BackgroundTransparency = 1
LogsPage.Size = UDim2.new(1, 0, 1, 0)

local LogScroll = Instance.new("ScrollingFrame", LogsPage)
LogScroll.Active = true
LogScroll.BackgroundTransparency = 1
LogScroll.BorderSizePixel = 0
LogScroll.Size = UDim2.new(1, 0, 1, -10)
LogScroll.ScrollBarThickness = 2
LogScroll.ScrollBarImageColor3 = ACCENT
LogScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local LogLayout = Instance.new("UIListLayout", LogScroll)
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogLayout.Padding = UDim.new(0, 8)

local LogPadding = Instance.new("UIPadding", LogScroll)
LogPadding.PaddingLeft = UDim.new(0, 4)
LogPadding.PaddingRight = UDim.new(0, 14)

local LogEntries = {}
local RenderedIDs = {}

-- ========================
-- SETTINGS PAGE (scrollable)
-- ========================
local SettingsPage = Instance.new("ScrollingFrame", ContentArea)
SettingsPage.Name = "SettingsPage"
SettingsPage.BackgroundTransparency = 1
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.Visible = false
SettingsPage.ScrollBarThickness = 2
SettingsPage.ScrollBarImageColor3 = ACCENT
SettingsPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsPage.BorderSizePixel = 0
SettingsPage.CanvasSize = UDim2.new(0, 0, 0, 0)

local SettingsLayout = Instance.new("UIListLayout", SettingsPage)
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsLayout.Padding = UDim.new(0, 10)

local SettingsPadding = Instance.new("UIPadding", SettingsPage)
SettingsPadding.PaddingLeft = UDim.new(0, 4)
SettingsPadding.PaddingRight = UDim.new(0, 14)

local function makeSettingsCard(parent, height, order)
    local card = Instance.new("Frame", parent)
    card.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    card.BackgroundTransparency = 0.1
    card.Size = UDim2.new(1, 0, 0, height)
    card.LayoutOrder = order
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = Color3.fromRGB(30, 50, 60)
    return card
end

local function makeToggle(parent, labelText, order, default, callback)
    local card = makeSettingsCard(parent, 48, order)
    local lbl = Instance.new("TextLabel", card)
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 15, 0, 0)
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(200, 220, 230)
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local state = default
    local btn = Instance.new("TextButton", card)
    btn.BackgroundColor3 = state and ACCENT or Color3.fromRGB(40, 40, 40)
    btn.Position = UDim2.new(1, -75, 0.5, -14)
    btn.Size = UDim2.new(0, 55, 0, 28)
    btn.Text = state and "ON" or "OFF"
    btn.TextColor3 = state and ACCENT_TEXT or Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        playClick()
        state = not state
        if state then
            TweenService:Create(btn, tweenInfo, {BackgroundColor3 = ACCENT}):Play()
            btn.Text = "ON"; btn.TextColor3 = ACCENT_TEXT
        else
            TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            btn.Text = "OFF"; btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        callback(state)
    end)
    return card
end

-- Settings Title
local stTitle = Instance.new("TextLabel", SettingsPage)
stTitle.BackgroundTransparency = 1
stTitle.Size = UDim2.new(1, -4, 0, 28)
stTitle.Font = Enum.Font.GothamBold
stTitle.Text = "Settings"
stTitle.TextColor3 = ACCENT
stTitle.TextSize = 18
stTitle.TextXAlignment = Enum.TextXAlignment.Left
stTitle.LayoutOrder = 0

-- 1. Minimum Value Filter (text input)
local mvCard = makeSettingsCard(SettingsPage, 48, 1)
local mvLabel = Instance.new("TextLabel", mvCard)
mvLabel.BackgroundTransparency = 1
mvLabel.Position = UDim2.new(0, 15, 0, 0)
mvLabel.Size = UDim2.new(0.5, 0, 1, 0)
mvLabel.Font = Enum.Font.GothamMedium
mvLabel.Text = "Minimum Value Filter"
mvLabel.TextColor3 = Color3.fromRGB(200, 220, 230)
mvLabel.TextSize = 13
mvLabel.TextXAlignment = Enum.TextXAlignment.Left

local mvInput = Instance.new("TextBox", mvCard)
mvInput.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
mvInput.Position = UDim2.new(1, -120, 0.5, -14)
mvInput.Size = UDim2.new(0, 100, 0, 28)
mvInput.Font = Enum.Font.GothamBold
mvInput.Text = "0"
mvInput.PlaceholderText = "e.g. 10000000"
mvInput.TextColor3 = ACCENT
mvInput.PlaceholderColor3 = Color3.fromRGB(80, 100, 110)
mvInput.TextSize = 13
mvInput.ClearTextOnFocus = false
Instance.new("UICorner", mvInput).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", mvInput).Color = Color3.fromRGB(40, 60, 70)

mvInput.FocusLost:Connect(function()
    local num = tonumber(mvInput.Text)
    if num then
        MinFilterValue = math.floor(num)
        mvInput.Text = tostring(MinFilterValue)
    else
        mvInput.Text = tostring(MinFilterValue)
    end
    autoSave()
end)

-- 2. Blacklist Settings
local blCard = makeSettingsCard(SettingsPage, 48, 2)
local blLabel = Instance.new("TextLabel", blCard)
blLabel.BackgroundTransparency = 1
blLabel.Position = UDim2.new(0, 15, 0, 0)
blLabel.Size = UDim2.new(0.6, 0, 1, 0)
blLabel.Font = Enum.Font.GothamMedium
blLabel.Text = "Blacklist Settings"
blLabel.TextColor3 = Color3.fromRGB(200, 220, 230)
blLabel.TextSize = 13
blLabel.TextXAlignment = Enum.TextXAlignment.Left

local blBtn = Instance.new("TextButton", blCard)
blBtn.BackgroundColor3 = ACCENT
blBtn.BackgroundTransparency = 0.15
blBtn.Position = UDim2.new(1, -80, 0.5, -14)
blBtn.Size = UDim2.new(0, 65, 0, 28)
blBtn.Font = Enum.Font.GothamBold
blBtn.Text = "Open"
blBtn.TextColor3 = ACCENT_TEXT
blBtn.TextSize = 12
Instance.new("UICorner", blBtn).CornerRadius = UDim.new(0, 6)

-- 3. Whitelist Settings
local wlCard = makeSettingsCard(SettingsPage, 48, 3)
local wlLabel = Instance.new("TextLabel", wlCard)
wlLabel.BackgroundTransparency = 1
wlLabel.Position = UDim2.new(0, 15, 0, 0)
wlLabel.Size = UDim2.new(0.6, 0, 1, 0)
wlLabel.Font = Enum.Font.GothamMedium
wlLabel.Text = "Whitelist Settings"
wlLabel.TextColor3 = Color3.fromRGB(200, 220, 230)
wlLabel.TextSize = 13
wlLabel.TextXAlignment = Enum.TextXAlignment.Left

local wlBtn = Instance.new("TextButton", wlCard)
wlBtn.BackgroundColor3 = ACCENT
wlBtn.BackgroundTransparency = 0.15
wlBtn.Position = UDim2.new(1, -80, 0.5, -14)
wlBtn.Size = UDim2.new(0, 65, 0, 28)
wlBtn.Font = Enum.Font.GothamBold
wlBtn.Text = "Open"
wlBtn.TextColor3 = ACCENT_TEXT
wlBtn.TextSize = 12
Instance.new("UICorner", wlBtn).CornerRadius = UDim.new(0, 6)

-- 4. Highlight AJ Users
makeToggle(SettingsPage, "Highlight AJ Users", 4, HighlightAJEnabled, function(val) HighlightAJEnabled = val autoSave() end)

-- 5. Discord copy
local dcCard = makeSettingsCard(SettingsPage, 48, 5)
local dcLabel = Instance.new("TextLabel", dcCard)
dcLabel.BackgroundTransparency = 1
dcLabel.Position = UDim2.new(0, 15, 0, 0)
dcLabel.Size = UDim2.new(0.6, 0, 1, 0)
dcLabel.Font = Enum.Font.GothamMedium
dcLabel.Text = "Discord: discord.gg/joiner"
dcLabel.TextColor3 = Color3.fromRGB(200, 220, 230)
dcLabel.TextSize = 12
dcLabel.TextXAlignment = Enum.TextXAlignment.Left

local CopyBtn = Instance.new("TextButton", dcCard)
CopyBtn.BackgroundColor3 = ACCENT
CopyBtn.BackgroundTransparency = 0.1
CopyBtn.Position = UDim2.new(1, -75, 0.5, -14)
CopyBtn.Size = UDim2.new(0, 58, 0, 28)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.Text = "Copy"
CopyBtn.TextColor3 = ACCENT_TEXT
CopyBtn.TextSize = 12
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 6)

CopyBtn.MouseEnter:Connect(function() TweenService:Create(CopyBtn, tweenInfo, {BackgroundColor3 = ACCENT_HOVER}):Play() end)
CopyBtn.MouseLeave:Connect(function() TweenService:Create(CopyBtn, tweenInfo, {BackgroundColor3 = ACCENT}):Play() end)
CopyBtn.MouseButton1Click:Connect(function()
    playClick()
    pcall(function() setclipboard("https://discord.gg/joiner") end)
    CopyBtn.Text = "Copied!"
    TweenService:Create(CopyBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(46, 204, 113)}):Play()
    task.wait(1.5)
    CopyBtn.Text = "Copy"
    TweenService:Create(CopyBtn, tweenInfo, {BackgroundColor3 = ACCENT}):Play()
end)

-- ========================
-- BLACKLIST SUB-PAGE
-- ========================
local BlacklistPage = Instance.new("Frame", ContentArea)
BlacklistPage.Name = "BlacklistPage"
BlacklistPage.BackgroundTransparency = 1
BlacklistPage.Size = UDim2.new(1, 0, 1, 0)
BlacklistPage.Visible = false

local blBackBtn = Instance.new("TextButton", BlacklistPage)
blBackBtn.BackgroundTransparency = 1
blBackBtn.Size = UDim2.new(0, 120, 0, 28)
blBackBtn.Font = Enum.Font.GothamBold
blBackBtn.Text = "< Blacklist"
blBackBtn.TextColor3 = ACCENT
blBackBtn.TextSize = 17
blBackBtn.TextXAlignment = Enum.TextXAlignment.Left

local blInputRow = Instance.new("Frame", BlacklistPage)
blInputRow.BackgroundTransparency = 1
blInputRow.Position = UDim2.new(0, 0, 0, 35)
blInputRow.Size = UDim2.new(1, -15, 0, 32)

local blInput = Instance.new("TextBox", blInputRow)
blInput.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
blInput.Size = UDim2.new(0, 220, 0, 30)
blInput.Font = Enum.Font.GothamMedium
blInput.Text = ""
blInput.PlaceholderText = "Username or item name"
blInput.TextColor3 = ACCENT
blInput.PlaceholderColor3 = Color3.fromRGB(80, 100, 110)
blInput.TextSize = 12
blInput.ClearTextOnFocus = true
Instance.new("UICorner", blInput).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", blInput).Color = Color3.fromRGB(40, 60, 70)

local blAddBtn = Instance.new("TextButton", blInputRow)
blAddBtn.BackgroundColor3 = ACCENT
blAddBtn.Position = UDim2.new(0, 228, 0, 0)
blAddBtn.Size = UDim2.new(0, 55, 0, 30)
blAddBtn.Font = Enum.Font.GothamBold
blAddBtn.Text = "Add"
blAddBtn.TextColor3 = ACCENT_TEXT
blAddBtn.TextSize = 12
Instance.new("UICorner", blAddBtn).CornerRadius = UDim.new(0, 6)

local blScroll = Instance.new("ScrollingFrame", BlacklistPage)
blScroll.BackgroundTransparency = 1
blScroll.Position = UDim2.new(0, 0, 0, 75)
blScroll.Size = UDim2.new(1, -15, 1, -80)
blScroll.ScrollBarThickness = 2
blScroll.ScrollBarImageColor3 = ACCENT
blScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
blScroll.BorderSizePixel = 0
Instance.new("UIListLayout", blScroll).Padding = UDim.new(0, 5)

local function refreshBlacklistUI()
    for _, c in pairs(blScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for i, name in ipairs(Blacklist) do
        local row = Instance.new("Frame", blScroll)
        row.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
        row.Size = UDim2.new(1, 0, 0, 30)
        row.LayoutOrder = i
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
        local txt = Instance.new("TextLabel", row)
        txt.BackgroundTransparency = 1
        txt.Position = UDim2.new(0, 10, 0, 0)
        txt.Size = UDim2.new(1, -50, 1, 0)
        txt.Font = Enum.Font.GothamMedium
        txt.Text = name
        txt.TextColor3 = Color3.fromRGB(200, 220, 230)
        txt.TextSize = 12
        txt.TextXAlignment = Enum.TextXAlignment.Left
        local del = Instance.new("TextButton", row)
        del.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        del.Position = UDim2.new(1, -38, 0.5, -10)
        del.Size = UDim2.new(0, 28, 0, 20)
        del.Font = Enum.Font.GothamBold
        del.Text = "X"
        del.TextColor3 = Color3.fromRGB(255, 255, 255)
        del.TextSize = 11
        Instance.new("UICorner", del).CornerRadius = UDim.new(0, 4)
        del.MouseButton1Click:Connect(function() playClick() blacklistMap[Blacklist[i]] = nil table.remove(Blacklist, i) refreshBlacklistUI() autoSave() end)
    end
end

blAddBtn.MouseButton1Click:Connect(function()
    playClick()
    local val = blInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if val ~= "" then table.insert(Blacklist, val) blacklistMap[val] = true blInput.Text = "" refreshBlacklistUI() autoSave() end
end)

-- ========================
-- WHITELIST SUB-PAGE
-- ========================
local WhitelistPage = Instance.new("Frame", ContentArea)
WhitelistPage.Name = "WhitelistPage"
WhitelistPage.BackgroundTransparency = 1
WhitelistPage.Size = UDim2.new(1, 0, 1, 0)
WhitelistPage.Visible = false

local wlBackBtn = Instance.new("TextButton", WhitelistPage)
wlBackBtn.BackgroundTransparency = 1
wlBackBtn.Size = UDim2.new(0, 120, 0, 28)
wlBackBtn.Font = Enum.Font.GothamBold
wlBackBtn.Text = "< Whitelist"
wlBackBtn.TextColor3 = ACCENT
wlBackBtn.TextSize = 17
wlBackBtn.TextXAlignment = Enum.TextXAlignment.Left

local wlInputRow = Instance.new("Frame", WhitelistPage)
wlInputRow.BackgroundTransparency = 1
wlInputRow.Position = UDim2.new(0, 0, 0, 35)
wlInputRow.Size = UDim2.new(1, -15, 0, 32)

local wlInput = Instance.new("TextBox", wlInputRow)
wlInput.BackgroundColor3 = Color3.fromRGB(20, 25, 30)
wlInput.Size = UDim2.new(0, 220, 0, 30)
wlInput.Font = Enum.Font.GothamMedium
wlInput.Text = ""
wlInput.PlaceholderText = "Username or item name"
wlInput.TextColor3 = ACCENT
wlInput.PlaceholderColor3 = Color3.fromRGB(80, 100, 110)
wlInput.TextSize = 12
wlInput.ClearTextOnFocus = true
Instance.new("UICorner", wlInput).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", wlInput).Color = Color3.fromRGB(40, 60, 70)

local wlAddBtn = Instance.new("TextButton", wlInputRow)
wlAddBtn.BackgroundColor3 = ACCENT
wlAddBtn.Position = UDim2.new(0, 228, 0, 0)
wlAddBtn.Size = UDim2.new(0, 55, 0, 30)
wlAddBtn.Font = Enum.Font.GothamBold
wlAddBtn.Text = "Add"
wlAddBtn.TextColor3 = ACCENT_TEXT
wlAddBtn.TextSize = 12
Instance.new("UICorner", wlAddBtn).CornerRadius = UDim.new(0, 6)

local wlScroll = Instance.new("ScrollingFrame", WhitelistPage)
wlScroll.BackgroundTransparency = 1
wlScroll.Position = UDim2.new(0, 0, 0, 75)
wlScroll.Size = UDim2.new(1, -15, 1, -80)
wlScroll.ScrollBarThickness = 2
wlScroll.ScrollBarImageColor3 = ACCENT
wlScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
wlScroll.BorderSizePixel = 0
Instance.new("UIListLayout", wlScroll).Padding = UDim.new(0, 5)

local function refreshWhitelistUI()
    for _, c in pairs(wlScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for i, name in ipairs(Whitelist) do
        local row = Instance.new("Frame", wlScroll)
        row.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
        row.Size = UDim2.new(1, 0, 0, 30)
        row.LayoutOrder = i
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
        local txt = Instance.new("TextLabel", row)
        txt.BackgroundTransparency = 1
        txt.Position = UDim2.new(0, 10, 0, 0)
        txt.Size = UDim2.new(1, -50, 1, 0)
        txt.Font = Enum.Font.GothamMedium
        txt.Text = name
        txt.TextColor3 = Color3.fromRGB(200, 220, 230)
        txt.TextSize = 12
        txt.TextXAlignment = Enum.TextXAlignment.Left
        local del = Instance.new("TextButton", row)
        del.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        del.Position = UDim2.new(1, -38, 0.5, -10)
        del.Size = UDim2.new(0, 28, 0, 20)
        del.Font = Enum.Font.GothamBold
        del.Text = "X"
        del.TextColor3 = Color3.fromRGB(255, 255, 255)
        del.TextSize = 11
        Instance.new("UICorner", del).CornerRadius = UDim.new(0, 4)
        del.MouseButton1Click:Connect(function() playClick() whitelistMap[Whitelist[i]] = nil table.remove(Whitelist, i) refreshWhitelistUI() autoSave() end)
    end
end

wlAddBtn.MouseButton1Click:Connect(function()
    playClick()
    local val = wlInput.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if val ~= "" then table.insert(Whitelist, val) whitelistMap[val] = true wlInput.Text = "" refreshWhitelistUI() autoSave() end
end)

-- ========================
-- USERS PAGE
-- ========================
local UsersPage = Instance.new("Frame", ContentArea)
UsersPage.Name = "UsersPage"
UsersPage.BackgroundTransparency = 1
UsersPage.Size = UDim2.new(1, 0, 1, 0)
UsersPage.Visible = false

local UsersTitle = Instance.new("TextLabel", UsersPage)
UsersTitle.BackgroundTransparency = 1
UsersTitle.Position = UDim2.new(0, 4, 0, 0)
UsersTitle.Size = UDim2.new(1, -18, 0, 30)
UsersTitle.Font = Enum.Font.GothamBold
UsersTitle.Text = "Users using Rexzy Free"
UsersTitle.TextColor3 = ACCENT
UsersTitle.TextSize = 18
UsersTitle.TextXAlignment = Enum.TextXAlignment.Left

local UserScroll = Instance.new("ScrollingFrame", UsersPage)
UserScroll.Active = true
UserScroll.BackgroundTransparency = 1
UserScroll.BorderSizePixel = 0
UserScroll.Position = UDim2.new(0, 0, 0, 40)
UserScroll.Size = UDim2.new(1, -10, 1, -50)
UserScroll.ScrollBarThickness = 2
UserScroll.ScrollBarImageColor3 = ACCENT
UserScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UserLayout = Instance.new("UIListLayout", UserScroll)
UserLayout.SortOrder = Enum.SortOrder.LayoutOrder
UserLayout.Padding = UDim.new(0, 6)

local UserPadding = Instance.new("UIPadding", UserScroll)
UserPadding.PaddingLeft = UDim.new(0, 4)
UserPadding.PaddingRight = UDim.new(0, 14)

-- Track live WS users
local rexzyUserList = {}

local function RefreshUsers()
    for _, c in pairs(UserScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for i, username in ipairs(rexzyUserList) do
        local card = Instance.new("Frame", UserScroll)
        card.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
        card.BackgroundTransparency = 0.15
        card.Size = UDim2.new(1, -10, 0, 40)
        card.LayoutOrder = i
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Color = Color3.fromRGB(35, 45, 55)
        cardStroke.Thickness = 1
        cardStroke.Transparency = 0.3

        -- Online dot
        local dot = Instance.new("Frame", card)
        dot.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.Position = UDim2.new(0, 10, 0.5, -4)
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        -- Avatar
        local avatarHolder = Instance.new("Frame", card)
        avatarHolder.BackgroundColor3 = Color3.fromRGB(30, 35, 40)
        avatarHolder.Position = UDim2.new(0, 24, 0.5, -14)
        avatarHolder.Size = UDim2.new(0, 28, 0, 28)
        Instance.new("UICorner", avatarHolder).CornerRadius = UDim.new(1, 0)

        local avatarImg = Instance.new("ImageLabel", avatarHolder)
        avatarImg.BackgroundTransparency = 1
        avatarImg.Size = UDim2.new(1, -2, 1, -2)
        avatarImg.Position = UDim2.new(0, 1, 0, 1)
        avatarImg.ScaleType = Enum.ScaleType.Crop
        avatarImg.Image = ""
        Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

        -- Fallback letter
        local fallback = Instance.new("TextLabel", avatarHolder)
        fallback.BackgroundTransparency = 1
        fallback.Size = UDim2.new(1, 0, 1, 0)
        fallback.Font = Enum.Font.GothamBold
        fallback.Text = username:sub(1, 1):upper()
        fallback.TextColor3 = ACCENT
        fallback.TextSize = 14

        -- Try to load avatar by finding the player or using API
        task.spawn(function()
            -- Try finding player in server first
            local plr = Players:FindFirstChild(username)
            if plr then
                pcall(function()
                    avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
                    fallback.Visible = false
                end)
                return
            end
            -- Try GetUserIdFromNameAsync
            pcall(function()
                local userId = Players:GetUserIdFromNameAsync(username)
                if userId then
                    avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150"
                    fallback.Visible = false
                end
            end)
        end)

        -- Username
        local nm = Instance.new("TextLabel", card)
        nm.BackgroundTransparency = 1
        nm.Position = UDim2.new(0, 58, 0, 0)
        nm.Size = UDim2.new(1, -68, 1, 0)
        nm.Font = Enum.Font.GothamBold
        nm.Text = username
        nm.TextColor3 = Color3.fromRGB(220, 240, 250)
        nm.TextSize = 13
        nm.TextXAlignment = Enum.TextXAlignment.Left
    end
end

-- ========================
-- PAGE NAVIGATION
-- ========================
local Pages = {Logs = LogsPage, Settings = SettingsPage, Users = UsersPage, Blacklist = BlacklistPage, Whitelist = WhitelistPage}

local function showPage(pageName)
    for name, page in pairs(Pages) do page.Visible = (name == pageName) end
    if pageName == "Users" then RefreshUsers() end
    if pageName == "Blacklist" then refreshBlacklistUI() end
    if pageName == "Whitelist" then refreshWhitelistUI() end
end

blBtn.MouseButton1Click:Connect(function() playClick() showPage("Blacklist") end)
wlBtn.MouseButton1Click:Connect(function() playClick() showPage("Whitelist") end)
blBackBtn.MouseButton1Click:Connect(function() playClick() showPage("Settings") end)
wlBackBtn.MouseButton1Click:Connect(function() playClick() showPage("Settings") end)

-- ========================
-- TOP CONTROLS
-- ========================
local TopControls = Instance.new("Frame", Frame)
TopControls.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
TopControls.BackgroundTransparency = 0.2
TopControls.AnchorPoint = Vector2.new(1, 0)
TopControls.Position = UDim2.new(1, -15, 0, 10)
TopControls.Size = UDim2.new(0, 68, 0, 30)
Instance.new("UICorner", TopControls).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", TopControls).Color = Color3.fromRGB(30, 50, 60)

local TopLayout = Instance.new("UIListLayout", TopControls)
TopLayout.FillDirection = Enum.FillDirection.Horizontal
TopLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TopLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TopLayout.SortOrder = Enum.SortOrder.LayoutOrder

local MinBtn = Instance.new("TextButton", TopControls)
MinBtn.BackgroundTransparency = 1
MinBtn.Size = UDim2.new(0, 34, 0, 30)
MinBtn.Text = ""
MinBtn.LayoutOrder = 1

local MinIcon = Instance.new("TextLabel", MinBtn)
MinIcon.BackgroundTransparency = 1
MinIcon.AnchorPoint = Vector2.new(0.5, 0.5)
MinIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
MinIcon.Size = UDim2.new(0, 20, 0, 20)
MinIcon.Font = Enum.Font.GothamBold
MinIcon.Text = "—"
MinIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
MinIcon.TextSize = 16

MinBtn.MouseEnter:Connect(function() TweenService:Create(MinIcon, tweenInfo, {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play() end)
MinBtn.MouseLeave:Connect(function() TweenService:Create(MinIcon, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)

local isMinimized = false
local function minimizeGui()
    if isMinimized then return end
    isMinimized = true
    playClick()
    local t1 = TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = HIDE_SCALE})
    local t2 = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {GroupTransparency = 1})
    t1:Play() t2:Play()
    t1.Completed:Wait()
    Frame.Visible = false
    MinimizeBtn.Visible = true
    MinimizeBtn.Size = UDim2.new(0, 10, 0, 10)
    MinimizeBtn.BackgroundTransparency = 1
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 40, 0, 40), BackgroundTransparency = 0.15}):Play()
end

local function restoreGui()
    if not isMinimized then return end
    isMinimized = false
    playClick()
    MinimizeBtn.Visible = false
    Frame.Visible = true
    Frame.GroupTransparency = 1
    UIScale.Scale = HIDE_SCALE
    TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
    TweenService:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Scale = TARGET_SCALE}):Play()
end

MinBtn.MouseButton1Click:Connect(minimizeGui)
MinimizeBtn.MouseButton1Click:Connect(restoreGui)

local CloseBtn = Instance.new("TextButton", TopControls)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(0, 34, 0, 30)
CloseBtn.Text = ""
CloseBtn.LayoutOrder = 2

local CloseIcon = Instance.new("ImageLabel", CloseBtn)
CloseIcon.BackgroundTransparency = 1
CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
CloseIcon.Size = UDim2.new(0, 16, 0, 16)
CloseIcon.Image = "rbxassetid://119410757402001"
CloseIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseIcon, tweenInfo, {ImageColor3 = Color3.fromRGB(255, 100, 100)}):Play() end)
CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseIcon, tweenInfo, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
CloseBtn.MouseButton1Click:Connect(function()
    playClick()
    TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Scale = HIDE_SCALE}):Play()
    local cf = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {GroupTransparency = 1})
    cf:Play()
    cf.Completed:Wait()
    ScreenGui:Destroy()
end)

-- ========================
-- SIDEBAR BUTTONS
-- ========================
local sidebarButtons = {}

local function createSidebarButton(text, yPos, pageName, default)
    local btn = Instance.new("TextButton", Frame)
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.Size = UDim2.new(0, 130, 0, 32)
    btn.BackgroundColor3 = default and ACCENT or Color3.fromRGB(12, 12, 12)
    btn.BackgroundTransparency = default and 0.05 or 0.1
    btn.Text = text
    btn.TextColor3 = default and ACCENT_TEXT or Color3.fromRGB(150, 170, 180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = default and ACCENT or Color3.fromRGB(30, 50, 60)
    stroke.Transparency = 0.3
    Instance.new("UIPadding", btn).PaddingLeft = UDim.new(0, 15)

    local data = {Button = btn, Stroke = stroke, IsActive = default}
    table.insert(sidebarButtons, data)

    btn.MouseEnter:Connect(function()
        if not data.IsActive then TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(20, 30, 35)}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if not data.IsActive then TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(12, 12, 12)}):Play() end
    end)
    btn.MouseButton1Click:Connect(function()
        playClick()
        showPage(pageName)
        for _, d in ipairs(sidebarButtons) do
            if d.Button ~= btn then
                d.IsActive = false
                TweenService:Create(d.Button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(12, 12, 12), TextColor3 = Color3.fromRGB(150, 170, 180)}):Play()
                TweenService:Create(d.Stroke, tweenInfo, {Color = Color3.fromRGB(30, 50, 60)}):Play()
            end
        end
        data.IsActive = true
        TweenService:Create(btn, tweenInfo, {BackgroundColor3 = ACCENT, TextColor3 = ACCENT_TEXT}):Play()
        TweenService:Create(stroke, tweenInfo, {Color = ACCENT}):Play()
    end)
end

createSidebarButton("Logs", 75, "Logs", true)
createSidebarButton("Settings", 115, "Settings", false)
createSidebarButton("Users", 155, "Users", false)

-- ========================
-- START BUTTON
-- ========================
local startBtn = Instance.new("TextButton", Frame)
startBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
startBtn.Position = UDim2.new(0, 15, 0, 320)
startBtn.Size = UDim2.new(0, 130, 0, 32)
startBtn.Font = Enum.Font.GothamBold
startBtn.Text = "Start"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextSize = 15
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)
local startStroke = Instance.new("UIStroke", startBtn)
startStroke.Color = Color3.fromRGB(46, 204, 113)
startStroke.Transparency = 0.4

startBtn.MouseEnter:Connect(function()
    TweenService:Create(startBtn, tweenInfo, {BackgroundColor3 = isStarted and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(60, 220, 130)}):Play()
end)
startBtn.MouseLeave:Connect(function()
    TweenService:Create(startBtn, tweenInfo, {BackgroundColor3 = isStarted and Color3.fromRGB(231, 76, 60) or Color3.fromRGB(46, 204, 113)}):Play()
end)
startBtn.MouseButton1Click:Connect(function()
    playClick()
    isStarted = not isStarted
    if isStarted then
        startBtn.Text = "Stop"
        TweenService:Create(startBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(231, 76, 60)}):Play()
        TweenService:Create(startStroke, tweenInfo, {Color = Color3.fromRGB(231, 76, 60)}):Play()
    else
        startBtn.Text = "Start"
        TweenService:Create(startBtn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(46, 204, 113)}):Play()
        TweenService:Create(startStroke, tweenInfo, {Color = Color3.fromRGB(46, 204, 113)}):Play()
    end
end)

-- ========================
-- DRAG SYSTEM
-- ========================
local dragging, dragStart, startPos, dragInput = false, nil, nil, nil

local function updateDrag(input)
    if not dragging or not dragStart or not startPos then return end
    local delta = input.Position - dragStart
    TweenService:Create(Frame, dragTweenInfo, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input) if input == dragInput then updateDrag(input) end end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- ========================
-- LOG CREATION + JOINING + FILTERING
-- ========================
local function JoinServer(placeId, jobId)
    pcall(function() TeleportService:TeleportToPlaceInstance(tonumber(placeId), jobId, Player) end)
end

local function ForceServer(placeId, jobId)
    task.spawn(function()
        for i = 1, 50 do
            pcall(function() TeleportService:TeleportToPlaceInstance(tonumber(placeId), jobId, Player) end)
            task.wait(2.5)
        end
    end)
end

local function ApplyFilter()
    for _, entry in ipairs(LogEntries) do
        local v = entry.NumericValue
        local show = (v >= MinFilterValue)
        if show and #Blacklist > 0 then
            for _, bl in ipairs(Blacklist) do
                if string.find(string.lower(entry.Name), string.lower(bl)) then show = false break end
            end
        end
        if show and #Whitelist > 0 then
            local found = false
            for _, wl in ipairs(Whitelist) do
                if string.find(string.lower(entry.Name), string.lower(wl)) then found = true break end
            end
            show = found
        end
        entry.UI.Visible = show
    end
end

local function CreateLogNotification(dbKey, brainrotName, moneyStr, numVal, jobId, placeId)
    if RenderedIDs[dbKey] then return end
    RenderedIDs[dbKey] = true

    local LogItem = Instance.new("Frame", LogScroll)
    LogItem.BackgroundTransparency = 1
    LogItem.Size = UDim2.new(1, -10, 0, 45)

    if HighlightAJEnabled then
        LogItem.BackgroundColor3 = Color3.fromRGB(15, 30, 35)
        LogItem.BackgroundTransparency = 0.3
        Instance.new("UICorner", LogItem).CornerRadius = UDim.new(0, 6)
    end

    local line = Instance.new("Frame", LogItem)
    line.BackgroundColor3 = Color3.fromRGB(30, 50, 60)
    line.BorderSizePixel = 0
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -1)

    local Left = Instance.new("Frame", LogItem)
    Left.BackgroundTransparency = 1
    Left.Size = UDim2.new(0.6, 0, 1, 0)
    Left.Position = UDim2.new(0, 5, 0, 0)
    local LL = Instance.new("UIListLayout", Left)
    LL.FillDirection = Enum.FillDirection.Horizontal
    LL.VerticalAlignment = Enum.VerticalAlignment.Center
    LL.Padding = UDim.new(0, 8)

    local Icon = Instance.new("ImageLabel", Left)
    Icon.Size = UDim2.new(0, 14, 0, 14)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://136959386531965"
    Icon.ImageColor3 = ACCENT

    local Name = Instance.new("TextLabel", Left)
    Name.BackgroundTransparency = 1
    Name.AutomaticSize = Enum.AutomaticSize.X
    Name.Font = Enum.Font.GothamMedium
    Name.Text = brainrotName
    Name.TextColor3 = Color3.fromRGB(200, 220, 230)
    Name.TextSize = 12

    local Money = Instance.new("TextLabel", Left)
    Money.BackgroundTransparency = 1
    Money.AutomaticSize = Enum.AutomaticSize.X
    Money.Font = Enum.Font.GothamBold
    Money.Text = moneyStr
    Money.TextColor3 = ACCENT
    Money.TextSize = 13

    local Right = Instance.new("Frame", LogItem)
    Right.BackgroundTransparency = 1
    Right.Size = UDim2.new(0.4, 0, 1, 0)
    Right.Position = UDim2.new(0.6, -5, 0, 0)
    local RL = Instance.new("UIListLayout", Right)
    RL.FillDirection = Enum.FillDirection.Horizontal
    RL.HorizontalAlignment = Enum.HorizontalAlignment.Right
    RL.VerticalAlignment = Enum.VerticalAlignment.Center
    RL.Padding = UDim.new(0, 8)

    local jBtn = Instance.new("TextButton", Right)
    jBtn.BackgroundColor3 = ACCENT
    jBtn.Size = UDim2.new(0, 50, 0, 26)
    jBtn.Font = Enum.Font.GothamBold
    jBtn.Text = "JOIN"
    jBtn.TextColor3 = ACCENT_TEXT
    jBtn.TextSize = 11
    Instance.new("UICorner", jBtn).CornerRadius = UDim.new(0, 6)
    jBtn.MouseEnter:Connect(function() TweenService:Create(jBtn, tweenInfo, {BackgroundColor3 = ACCENT_HOVER}):Play() end)
    jBtn.MouseLeave:Connect(function() TweenService:Create(jBtn, tweenInfo, {BackgroundColor3 = ACCENT}):Play() end)
    jBtn.MouseButton1Click:Connect(function() playClick() JoinServer(placeId, jobId) end)

    local fBtn = Instance.new("TextButton", Right)
    fBtn.BackgroundColor3 = ACCENT
    fBtn.Size = UDim2.new(0, 60, 0, 26)
    fBtn.Font = Enum.Font.GothamBold
    fBtn.Text = "FORCE"
    fBtn.TextColor3 = ACCENT_TEXT
    fBtn.TextSize = 11
    Instance.new("UICorner", fBtn).CornerRadius = UDim.new(0, 6)
    fBtn.MouseEnter:Connect(function() TweenService:Create(fBtn, tweenInfo, {BackgroundColor3 = ACCENT_HOVER}):Play() end)
    fBtn.MouseLeave:Connect(function() TweenService:Create(fBtn, tweenInfo, {BackgroundColor3 = ACCENT}):Play() end)
    fBtn.MouseButton1Click:Connect(function() playClick() ForceServer(placeId, jobId) end)

    table.insert(LogEntries, {NumericValue = numVal, UI = LogItem, PlaceId = placeId, JobId = jobId, Name = brainrotName})
    ApplyFilter()
end

-- ========================
-- CLEAR ERRORS
-- ========================
local GuiService = game:GetService("GuiService")
GuiService.ErrorMessageChanged:Connect(function(Message)
    if Message ~= "" then GuiService:ClearError() end
end)
task.spawn(function()
    while true do GuiService:ClearError() task.wait() end
end)

-- ========================
-- CONFIG SAVE/LOAD
-- ========================
local CONFIG_PATH = "rexzy.json"
local defaultConfig = {
    minGeneration = 0,
    spamRetries = 5,
    spamOnLog = false,
    blacklist = {},
    whitelist = {},
    highlightAJ = false,
    minFilterValue = 0,
}

local function loadConfig()
    local success, content = pcall(function()
        if readfile then return readfile(CONFIG_PATH) end
        return nil
    end)
    if success and content then
        local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
        if ok and data then return data end
    end
    return defaultConfig
end

local function saveConfig(cfg)
    pcall(function()
        if writefile then writefile(CONFIG_PATH, HttpService:JSONEncode(cfg)) end
    end)
end

local config = loadConfig()
local minGeneration = config.minGeneration or 0
local spamRetries = config.spamRetries or 5
local spamOnLog = config.spamOnLog or false
local blacklistMap = {}
local whitelistMap = {}

-- Load saved toggles
HighlightAJEnabled = config.highlightAJ or false
MinFilterValue = config.minFilterValue or 0

if config.blacklist and type(config.blacklist) == "table" then
    for _, name in ipairs(config.blacklist) do blacklistMap[name] = true end
end
if config.whitelist and type(config.whitelist) == "table" then
    for _, name in ipairs(config.whitelist) do whitelistMap[name] = true end
end

local function getConfigTable()
    local bl, wl = {}, {}
    for name, _ in pairs(blacklistMap) do table.insert(bl, name) end
    for name, _ in pairs(whitelistMap) do table.insert(wl, name) end
    return {
        minGeneration = minGeneration,
        spamRetries = spamRetries,
        spamOnLog = spamOnLog,
        blacklist = bl,
        whitelist = wl,
        highlightAJ = HighlightAJEnabled,
        minFilterValue = MinFilterValue,
    }
end

local function autoSave()
    saveConfig(getConfigTable())
end

-- ========================
-- BRAINROT NAMES
-- ========================
local allBrainrotNames = {
    "Antonio","Bacuru and Egguru","Burguro And Fryuro","Capitano Moby","Celestial Pegasus","Granny",
    "Celularcini Viciosini","Cerberus","Chicleteira Cupideira","Chicleteira Noelteira","Chill Puppy",
    "Chillin Chili","Chimnino","Chipso and Queso","Cigno Fulgoro","Cloverat Clapat",
    "Cooki and Milki","Cupid Cupid sahur","DJ Panda","Dragon Cannelloni","Dragon Gingerini",
    "Dug dug dug","Elefanto Frigo","Esok Sekolah","Eviledon","Festive 67",
    "Fishino Clownino","Fortunu and Cashuru","Fragola La La La","Fragrama and Chocrama",
    "Garama and Madundung","Ginger Gerat","Gobblino Uniciclino","Griffin","Ho Ho Ho Sahur",
    "Hydra Dragon Cannelloni","Jolly Jolly Sahur","Karker Sahur","Ketchuru and Musturu",
    "Ketupat Bros","Ketupat Kepat","La Casa Boo","La Extinct Grande","La Food Combinasion",
    "La Ginger Sekolah","La Grande Combinasion","La Jolly Grande","La Lucky Grande",
    "La Romantic Grande","La Secret Combinasion","La Spooky Grande","La Supreme Combinasion",
    "La Taco Combinasion","Lavadorito Spinito","Los 25","Los 67","Los Amigos","Los Bros",
    "Los Candies","Los Combinasionas","Los Cupids","Los Hotspotsitos","Los Jolly Combinasionas",
    "Los Mobilis","Los Planitos","Los Primos","Los Puggies","Los Sekolahs","Los Spaghettis",
    "Los Spooky Combinasionas","Los Sweethearts","Los Tacoritas","Love Love Bear","Lovin Rose",
    "Mariachi Corazoni","Mieteteira Bicicleteira","Money Money Puggy","Money Money Reindeer",
    "Nacho Spyder","Nuclearo Dinossauro","Orcaledon","Popcuru and Fizzuru","Reinito Sleighito",
    "Rosetti Tualetti","Rosey and Teddy","Sammyni Fattini","Signore Carapace","Spaghetti Tualetti",
    "Spinny Hammy","Spooky and Pumpky","Swag Soda","Swaggy Bros","Tacorillo Crocodillo",
    "Tacorita Bicicleta","Tang Tang Keletang","Tictac Sahur","Tirilikalika Tirilikalako",
    "Tralaledon","Tuff Toucan","Ventoliero Pavonero","W or L","Headless Horseman","Meowl",
    "Skibidi Toilet","Strawberry Elephant",
}

-- ========================
-- JOB ID DECODER
-- ========================
local function deobfuscate(encoded)
    local parts = {}
    for num in string.gmatch(encoded, "[^,]+") do table.insert(parts, tonumber(num)) end
    local idx = 1
    local checksum = parts[idx]; idx = idx + 1
    local length = parts[idx]; idx = idx + 1
    local offsetSeed = parts[idx]; idx = idx + 1
    local noiseCount = parts[idx]; idx = idx + 1
    local keys = {}
    for i = 1, 5 do table.insert(keys, parts[idx]); idx = idx + 1 end
    local noisePositions = {}
    for i = 1, noiseCount do table.insert(noisePositions, parts[idx]); idx = idx + 1 end
    local encrypted = {}
    for i = idx, #parts do table.insert(encrypted, parts[i]) end
    table.sort(noisePositions, function(a, b) return a > b end)
    for _, pos in ipairs(noisePositions) do table.remove(encrypted, pos + 1) end
    for i = 1, #encrypted - 1, 2 do encrypted[i], encrypted[i+1] = encrypted[i+1], encrypted[i] end
    local unrotated = {}
    for i = 1, #encrypted do
        local b = encrypted[i]
        local rot = ((i-1) % 7) + 1
        table.insert(unrotated, bit32.bor(math.floor(b / (2^rot)), (b * (2^(8-rot))) % 256))
    end
    local unxored = {}
    for i = 1, #unrotated do
        local result = unrotated[i]
        for j = 1, #keys do
            if ((i-1)+(j-1)) % 2 == 0 then result = bit32.bxor(result, keys[j]) end
        end
        table.insert(unxored, result)
    end
    local decrypted = {}
    for i = 1, #unxored do table.insert(decrypted, (unxored[i] - ((i-1) * offsetSeed)) % 256) end
    local result = ""
    for i = 1, #decrypted do result = result .. string.char(decrypted[i]) end
    return result
end

local function decodeJobID(encodedJobID)
    if not encodedJobID or type(encodedJobID) ~= "string" then return nil end
    encodedJobID = encodedJobID:gsub("%s+", "")
    local success, decoded = pcall(function() return deobfuscate(encodedJobID) end)
    if success and decoded then
        if #decoded == 36 and decoded:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
            return decoded
        end
        local hex = decoded:gsub("[^%x]", ""):lower()
        if #hex >= 32 then
            local s = hex:sub(1, 32)
            return string.format("%s-%s-%s-%s-%s", s:sub(1,8), s:sub(9,12), s:sub(13,16), s:sub(17,20), s:sub(21,32))
        end
    end
    return nil
end

-- ========================
-- TELEPORT
-- ========================
local function teleportToJob(jobId)
    if jobId then pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, Player) end) end
end

-- ========================
-- HIGHLIGHT REXZY USERS
-- ========================
local function highlightUser(username)
    if username == Player.Name or username == Player.DisplayName then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == username or p.DisplayName == username then
            local char = p.Character
            if char then
                if char:FindFirstChild("RexzyHighlight") then char.RexzyHighlight:Destroy() end
                local hl = Instance.new("Highlight")
                hl.Name = "RexzyHighlight"
                hl.FillColor = ACCENT
                hl.FillTransparency = 0.7
                hl.OutlineColor = ACCENT
                hl.OutlineTransparency = 0.3
                hl.Parent = char
                if char:FindFirstChild("RexzyBillboard") then char.RexzyBillboard:Destroy() end
                local head = char:FindFirstChild("Head")
                if head then
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "RexzyBillboard"
                    bb.Size = UDim2.new(0, 100, 0, 20)
                    bb.StudsOffset = Vector3.new(0, 3, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = head
                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "Rexzy User"
                    lbl.TextColor3 = ACCENT
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 12
                    lbl.TextStrokeTransparency = 0.5
                    lbl.Parent = bb
                end
            end
        end
    end
end

-- ========================
-- UNIFIED LOG ENTRY
-- ========================
local logOrder = 0
local entryIdCounter = 0

local function createLogEntry(brainrotName, generation, playerCount, jobId, source)
    -- Clean generation text - remove $, extra spaces
    local genText = tostring(generation):gsub("%$", ""):gsub("%s+", " "):match("^%s*(.-)%s*$") or "0"
    local genNum = tonumber(genText:match("[%d%.]+")) or 0
    print("[Log] Received:", source, "|", brainrotName, "|", genText, "| genNum:", genNum, "| filter:", MinFilterValue)

    local nameList = {}
    for name in brainrotName:gmatch("[^,]+") do
        table.insert(nameList, name:match("^%s*(.-)%s*$"))
    end

    -- Blacklist
    for _, name in ipairs(nameList) do
        if blacklistMap[name] then print("[Log] Blacklisted:", name) return end
    end

    -- Whitelist
    local isWhitelisted = false
    for _, name in ipairs(nameList) do
        if whitelistMap[name] then isWhitelisted = true break end
    end

    -- Filter: MinFilterValue is in M (e.g. 50 = 50M), genNum is raw number from text
    -- If genText contains M/K suffixes, genNum is already the raw number
    -- MinFilterValue * 1000000 for comparison OR compare genNum directly if it's already in millions
    local genValueForFilter = genNum
    if genText:lower():find("m") then
        genValueForFilter = genNum -- already in millions as a number
    elseif genText:lower():find("k") then
        genValueForFilter = genNum / 1000 -- convert K to M
    elseif genNum >= 1000000 then
        genValueForFilter = genNum / 1000000 -- raw big number to M
    end

    if not isWhitelisted and MinFilterValue > 0 and genValueForFilter < MinFilterValue then
        print("[Log] Filtered: value", genValueForFilter, "M < min", MinFilterValue, "M")
        return
    end

    logOrder = logOrder - 1
    entryIdCounter = entryIdCounter + 1
    local entryId = entryIdCounter
    local isSpamming = false

    -- Resolve job ID
    local resolvedJobId = nil
    if jobId and jobId ~= "" then
        if jobId:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
            resolvedJobId = jobId
        else
            resolvedJobId = decodeJobID(jobId)
        end
    end
    print("[Log] Entry #" .. entryId, "| Job:", tostring(resolvedJobId):sub(1, 36))

    local dbKey = (source or "ws") .. "_" .. tostring(entryId)
    if RenderedIDs[dbKey] then return end
    RenderedIDs[dbKey] = true

    -- Format display gen (no double $)
    local displayGen = "$" .. genText
    if displayGen:find("M") or displayGen:find("m") then
        -- already has M
    else
        displayGen = displayGen .. "M/s"
    end

    -- ========== CARD ==========
    local card = Instance.new("Frame", LogScroll)
    card.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    card.Size = UDim2.new(1, -6, 0, 56)
    card.LayoutOrder = logOrder
    card.ClipsDescendants = true
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = Color3.fromRGB(40, 50, 60)
    cardStroke.Thickness = 1

    -- Name (big, readable)
    local nLbl = Instance.new("TextLabel", card)
    nLbl.BackgroundTransparency = 1
    nLbl.Position = UDim2.new(0, 14, 0, 6)
    nLbl.Size = UDim2.new(0.6, -14, 0, 22)
    nLbl.Font = Enum.Font.GothamBold
    nLbl.Text = brainrotName
    nLbl.TextColor3 = Color3.fromRGB(245, 250, 255)
    nLbl.TextSize = 15
    nLbl.TextXAlignment = Enum.TextXAlignment.Left
    nLbl.TextTruncate = Enum.TextTruncate.AtEnd

    -- Generation (big green text under name)
    local gLbl = Instance.new("TextLabel", card)
    gLbl.BackgroundTransparency = 1
    gLbl.Position = UDim2.new(0, 14, 0, 30)
    gLbl.Size = UDim2.new(0.5, -14, 0, 18)
    gLbl.Font = Enum.Font.GothamBold
    gLbl.Text = displayGen
    gLbl.TextColor3 = Color3.fromRGB(46, 204, 113)
    gLbl.TextSize = 14
    gLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- JOIN button (centered right, big)
    local jBtn = Instance.new("TextButton", card)
    jBtn.BackgroundColor3 = ACCENT
    jBtn.AnchorPoint = Vector2.new(1, 0.5)
    jBtn.Position = UDim2.new(1, -8, 0.5, 0)
    jBtn.Size = UDim2.new(0, 55, 0, 34)
    jBtn.Font = Enum.Font.GothamBold
    jBtn.Text = "JOIN"
    jBtn.TextColor3 = ACCENT_TEXT
    jBtn.TextSize = 14
    Instance.new("UICorner", jBtn).CornerRadius = UDim.new(0, 8)
    jBtn.MouseButton1Click:Connect(function()
        if resolvedJobId then teleportToJob(resolvedJobId) end
    end)

    -- AUTO-JOIN: if isStarted is ON, join once
    if isStarted and resolvedJobId then
        print("[Log] Auto-joining:", brainrotName)
        teleportToJob(resolvedJobId)
    end

    table.insert(LogEntries, {NumericValue = genNum * 1000000, UI = card, PlaceId = game.PlaceId, JobId = resolvedJobId or "", Name = brainrotName})
end

-- ========================
-- XOR ENCRYPTION/DECRYPTION
-- ========================
local sessionXorKey = nil
local FIXED_OUTBOUND_KEY = "rExZyWsSn9001SecretInboundKeyForClientMessages2025XorDecrypt!"

local function hexToBytes(hexStr)
    local bytes = {}
    for i = 1, #hexStr, 2 do
        local byte = tonumber(hexStr:sub(i, i + 1), 16)
        if byte then table.insert(bytes, byte) end
    end
    return bytes
end

local function bytesToHex(bytes)
    local hex = {}
    for _, b in ipairs(bytes) do table.insert(hex, string.format("%02x", b)) end
    return table.concat(hex)
end

local function xorDecryptBytes(bytes, key)
    local keyLen = #key
    local result = {}
    for i, b in ipairs(bytes) do
        local keyByte = string.byte(key, ((i - 1) % keyLen) + 1)
        table.insert(result, bit32.bxor(b, keyByte))
    end
    return result
end

local function bytesToString(bytes)
    local chars = {}
    for _, b in ipairs(bytes) do table.insert(chars, string.char(b)) end
    return table.concat(chars)
end

local function stringToBytes(str)
    local bytes = {}
    for i = 1, #str do table.insert(bytes, string.byte(str, i)) end
    return bytes
end

local function xorEncryptToHex(plaintext, key)
    local bytes = stringToBytes(plaintext)
    local encrypted = xorDecryptBytes(bytes, key)
    return bytesToHex(encrypted)
end

local function xorDecryptHex(hexStr, key)
    local bytes = hexToBytes(hexStr)
    local decrypted = xorDecryptBytes(bytes, key)
    return bytesToString(decrypted)
end

-- ========================
-- REXZY NOTIFIER WS (wss://wssn.rexzy.online/)
-- ========================
local rexzyWs = nil

local function connectRexzyWS()
    if rexzyWs then print("[Rexzy] Already connected") return end
    print("[Rexzy] Connecting to wss://wssn.rexzy.online/ ...")
    local success, ws = pcall(function()
        if WebSocket then return WebSocket.connect("wss://wssn.rexzy.online/") end
        if syn and syn.websocket then return syn.websocket.connect("wss://wssn.rexzy.online/") end
        if fluxus and fluxus.websocket then return fluxus.websocket.connect("wss://wssn.rexzy.online/") end
        if websocket and websocket.connect then return websocket.connect("wss://wssn.rexzy.online/") end
        return nil
    end)
    if not success then print("[Rexzy] Connection failed:", tostring(ws)) return end
    if not ws then print("[Rexzy] No WebSocket API available") return end
    print("[Rexzy] Connected!")
    rexzyWs = ws
    local handshakeDone = false

    ws.OnMessage:Connect(function(msg)
        -- Handle userid_ messages (can come multiple times, ignore if same key)
        if type(msg) == "string" and msg:sub(1, 7) == "userid_" then
            local newKey = msg:sub(8)
            if sessionXorKey == newKey then
                print("[Rexzy] Duplicate userid_ key, ignoring")
                return
            end
            sessionXorKey = newKey
            print("[Rexzy] XOR key received, length:", #sessionXorKey)
            if not handshakeDone then
                handshakeDone = true
                pcall(function() ws:Send(HttpService:JSONEncode({user = Player.Name})) end)
                print("[Rexzy] Registered as:", Player.Name)
            else
                print("[Rexzy] Key updated (was already handshaked)")
            end
            return
        end

        if not handshakeDone or not sessionXorKey then
            print("[Rexzy] Msg before handshake, ignoring")
            return
        end
        if type(msg) ~= "string" or #msg < 2 then return end

        -- Some messages come as plain JSON (like users list), try that first
        local plainOk, plainData = pcall(function() return HttpService:JSONDecode(msg) end)
        if plainOk and type(plainData) == "table" then
            -- Users list update (plain JSON)
            if plainData.users and type(plainData.users) == "table" then
                print("[Rexzy] Users update (plain):", #plainData.users, "users")
                rexzyUserList = plainData.users
                if UsersPage.Visible then RefreshUsers() end
                for _, u in ipairs(plainData.users) do pcall(function() highlightUser(u) end) end
                return
            end
            -- If it parsed as JSON but has brainrots, use it directly
            if plainData.brainrots and plainData.generation then
                local name = type(plainData.brainrots) == "table" and table.concat(plainData.brainrots, ", ") or tostring(plainData.brainrots)
                local gen = type(plainData.generation) == "table" and plainData.generation[1] or tostring(plainData.generation)
                print("[Rexzy] Log (plain):", name, "| Gen:", gen)
                createLogEntry(name, gen, plainData.players or "0", plainData.job_id or "", "rexzy")
                return
            end
        end

        -- Not plain JSON, try XOR decrypt
        local ok, decrypted = pcall(function() return xorDecryptHex(msg, sessionXorKey) end)
        if not ok then print("[Rexzy] XOR decrypt error:", tostring(decrypted)) return end
        if not decrypted then return end

        local ok2, data = pcall(function() return HttpService:JSONDecode(decrypted) end)
        if not ok2 then
            print("[Rexzy] JSON parse failed after XOR. Preview:", decrypted:sub(1, 80))
            return
        end
        if type(data) ~= "table" then return end

        -- Users list update (XOR encrypted)
        if data.users and type(data.users) == "table" then
            print("[Rexzy] Users update (xor):", #data.users, "users")
            rexzyUserList = data.users
            if UsersPage.Visible then RefreshUsers() end
            for _, u in ipairs(data.users) do pcall(function() highlightUser(u) end) end
            return
        end

        -- Brainrot log
        if data.brainrots and data.generation then
            local name = type(data.brainrots) == "table" and table.concat(data.brainrots, ", ") or tostring(data.brainrots)
            local gen = type(data.generation) == "table" and data.generation[1] or tostring(data.generation)
            print("[Rexzy] Log:", name, "| Gen:", gen)
            createLogEntry(name, gen, data.players or "0", data.job_id or "", "rexzy")
        end
    end)

    ws.OnClose:Connect(function()
        print("[Rexzy] WS closed, reconnecting in 3s...")
        rexzyWs = nil
        sessionXorKey = nil
        task.wait(3)
        connectRexzyWS()
    end)
end

local function submitLogToRexzy(name, generation, players, jobId)
    if not rexzyWs or not sessionXorKey then return end
    pcall(function()
        local plaintext = name .. "." .. generation .. "." .. players .. "." .. (jobId or game.JobId)
        rexzyWs:Send("useridcheck_" .. xorEncryptToHex(plaintext, FIXED_OUTBOUND_KEY))
    end)
end

-- ========================
-- BRAINROT SCANNER
-- ========================
local sentBrainrots = {}

local function getValue(text)
    if not text then return 0 end
    local num = tonumber(text:match("[%d%.]+")) or 0
    if text:find("[Mm]") then return num * 1000000
    elseif text:find("[Kk]") then return num * 1000
    else return num end
end

local function getUniqueKey(name, generation)
    return (name or "Unknown") .. "|" .. (generation or "")
end

local function scanAndSend()
    local currentHighValue = {}
    local debris = Workspace:FindFirstChild("Debris")
    if debris then
        for _, obj in ipairs(debris:GetChildren()) do
            local genLabel = obj:FindFirstChild("Generation", true) or obj:FindFirstChildWhichIsA("TextLabel")
            if genLabel and genLabel.Text and genLabel.Text:find("%$") then
                local value = getValue(genLabel.Text)
                if value >= 10000000 then
                    local name = "Unknown"
                    local display = obj:FindFirstChild("DisplayName", true) or obj:FindFirstChild("Displayname", true)
                    if display and display.Text then name = display.Text end
                    local key = getUniqueKey(name, genLabel.Text)
                    if not sentBrainrots[key] then table.insert(currentHighValue, {name = name, gen = genLabel.Text, key = key}) end
                end
            end
        end
    end
    local plots = Workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, pod in ipairs(podiums:GetChildren()) do
                    local gen = pod:FindFirstChild("Generation", true)
                    if gen and gen:IsA("TextLabel") and gen.Text:find("%$") then
                        local value = getValue(gen.Text)
                        if value >= 10000000 then
                            local name = "Podium Animal"
                            local display = pod:FindFirstChild("DisplayName", true) or pod:FindFirstChild("Displayname", true)
                            if display and display.Text then name = display.Text end
                            local key = getUniqueKey(name, gen.Text)
                            if not sentBrainrots[key] then table.insert(currentHighValue, {name = name, gen = gen.Text, key = key}) end
                        end
                    end
                end
            end
        end
    end
    if #currentHighValue > 0 then
        local players = #Players:GetPlayers() .. "/" .. Players.MaxPlayers
        for _, item in ipairs(currentHighValue) do
            sentBrainrots[item.key] = true
            submitLogToRexzy(item.name, item.gen, players, game.JobId)
        end
    end
end

-- ========================
-- INIT
-- ========================
showPage("Logs")
connectRexzyWS()

startBtn.MouseButton1Click:Connect(function()
    print("[Rexzy] Start toggled:", isStarted)
end)

task.spawn(function()
    while task.wait(2) do
        if not Workspace:FindFirstChild("Debris") then Instance.new("Folder", Workspace).Name = "Debris" end
    end
end)

task.spawn(function()
    while task.wait(3) do
        pcall(function()
            local req = game:HttpGet(FIREBASE_URL)
            if req and req ~= "null" then
                local data = HttpService:JSONDecode(req)
                for key, info in pairs(data) do
                    if type(info) == "table" and info.jobId and info.jobId ~= "" then
                        CreateLogNotification(key, info.name, info.value, info.numValue, info.jobId, info.placeId)
                    end
                end
            end
        end)
        ApplyFilter()
    end
end)

task.spawn(function() while true do pcall(scanAndSend) task.wait(5) end end)

task.spawn(function()
    while true do
        task.wait(5)
        if not rexzyWs then connectRexzyWS() end
    end
end)