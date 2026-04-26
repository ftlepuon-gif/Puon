----------------------------------------------------------------
-- STEAL BRAINROT - CYBER CYAN EDITION (MAX SPEED & UI)
----------------------------------------------------------------
repeat task.wait() until game:IsLoaded()

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

-- ✅ CONFIG (GIỮ NGUYÊN TỪ FILE GỐC)
local API_BASE = "https://joine-82ca0-default-rtdb.firebaseio.com/Servers.json"
local AutoJoinTarget = nil

-- ✅ THEME MÀU (CYAN TRONG SUỐT - GIỐNG ẢNH)
local THEME = {
    Bg = Color3.fromRGB(10, 12, 16),
    Panel = Color3.fromRGB(18, 22, 28),
    Cyan = Color3.fromRGB(0, 255, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Trans = 0.15
}

-- ✅ FULL LIST BRAINROT (KHÔNG THIẾU MỘT CHỮ)
local allBrainrots = {"Los Nooo My Hotspotsitos","Serafinna Medusella","La Grande Combinassion","La Easter Grande","Rang Ring Bus","Guest 666","Los Mi Gatitos","Los Chicleteiras","Noo My Eggs","67","Donkeyturbo Express","Mariachi Corazoni","Los Burritos","Los 25","Tacorillo Crocodillo","Swag Soda","Noo my Heart","Chimnino","Los Combinasionas","Chicleteira Noelteira","Fishino Clownino","Baskito","Tacorita Bicicleta","Los Sweethearts","Spinny Hammy","Nuclearo Dinosauro","Las Sis","DJ Panda","Chicleteira Cupideira","La Karkerkar Combinasion","Chillin Chili","Chipso and Queso","Money Money Reindeer","Money Money Puggy","Churrito Bunnito","Celularcini Viciosini","Los Planitos","Los Mobilis","Los 67","Mieteteira Bicicleteira","Tuff Toucan","La Spooky Grande","Los Spooky Combinasionas","Cigno Fulgoro","Los Candies","Los Hotspositos","Los Jolly Combinasionas","Los Cupids","Los Puggies","W or L","Tralalalaledon","La Extinct Grande Combinasion","Tralaledon","La Jolly Grande","Los Primos","Bacuru and Egguru","Eviledon","Los Tacoritas","Lovin Rose","Tang Tang Kelentang","Ketupat Kepat","Los Bros","Tictac Sahur","La Romantic Grande","Gingerat Gerat","Orcaledon","La Lucky Grande","Ketchuru and Masturu","Jolly Jolly Sahur","Garama and Madundung","Rosetti Tualetti","Nacho Spyder","Hopilikalika Hopilikalako","Festive 67","Sammyni Fattini","Love Love Bear","La Ginger Sekolah","Spooky and Pumpky","Boppin Bunny","Lavadorito Spinito","La Food Combinasion","Los Spaghettis","La Casa Boo","Fragrama and Chocrama","Los Sekolahs","Foxini Lanternini","La Secret Combinasion","Los Amigos","Reinito Sleighito","Ketupat Bros","Burguro and Fryuro","Cooki and Milki","Capitano Moby","Rosey and Teddy","Popcuru and Fizzuru","Hydra Bunny","Celestial Pegasus","Cerberus","La Supreme Combinasion","Dragon Cannelloni","Dragon Gingerini","Headless Horseman","Hydra Dragon Cannelloni","Griffin","Skibidi Toilet","Meowl","Strawberry Elephant","La Vacca Saturno Saturnita","Pandanini Frostini","Bisonte Giuppitere","Blackhole Goat","Jackorilla","Agarrini Ia Palini","Chachechi","Karkerkar Kurkur","Los Tortus","Los Matteos","Sammyni Spyderini","Trenostruzzo Turbo 4000","Chimpanzini Spiderini","Boatito Auratito","Fragola La La La","Dul Dul Dul","La Vacca Prese Presente","Frankentteo","Los Trios","Karker Sahur","Torrtuginni Dragonfrutini (Lucky Block)","Los Tralaleritos","Zombie Tralala","La Cucaracha","Vulturino Skeletono","Guerriro Digitale","Extinct Tralalero","Yess My Examine","Extinct Matteo","Las Tralaleritas","Rocco Disco","Reindeer Tralala","Las Vaquitas Saturnitas","Pumpkin Spyderini","Job Job Job Sahur","Los Karkeritos","Graipuss Medussi","Santteo","Fishboard","Buntteo","La Vacca Jacko Linterino","Triplito Tralaleritos","Trickolino","Paradiso Axolottino","GOAT","Giftini Spyderini","Los Spyderinis","Love Love Love Sahur","Perrito Burrito","1x1x1x1","Los Cucarachas","Easter Easter Sahur","Please My Present","Cuadramat and Pakrahmatmamat","Los Jobcitos","Nooo My Hotspot","Pot Hotspot (Lucky Block)","Noo My Examine","Telemorte","La Sahur Combinasion","List List List Sahur","Bunny Bunny Bunny Sahur","To To To Sahur","Pirulitoita Bicicletaire","25","Santa Hotspot","Horegini Boom","Quesadilla Crocodila","Pot Pumpkin","Naughty Naughty","Cupid Cupid Sahur","Ho Ho Ho Sahur","Mi Gatito","Chicleteira Bicicleteira","Eid Eid Eid Sahur","Cupid Hotspot","Spaghetti Tualetti (Lucky Block)","Esok Sekolah (Lucky Block)","Quesadillo Vampiro","Brunito Marsito","Chill Puppy","Burrito Bandito","Chicleteirina Bicicletaire","Granny","Los Bunitos","Los Quesadillas","Bunito Bunito Spinito","Noo My Candy"}
local Selected = {}
for _,v in pairs(allBrainrots) do Selected[v] = true end

-- ✅ UI CONSTRUCTION
local Gui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local Main = Instance.new("Frame", Gui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 700, 0, 450)
Main.Position = UDim2.new(0.5, -350, 0.5, -225)
Main.BackgroundColor3 = THEME.Bg
Main.BackgroundTransparency = THEME.Trans
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = THEME.Cyan
Stroke.Thickness = 2.5
Stroke.Transparency = 0.4

-- ✅ TOGGLE BUTTON (NÚT UI)
local Tgl = Instance.new("TextButton", Gui)
Tgl.Size = UDim2.new(0, 50, 0, 30)
Tgl.Position = UDim2.new(0, 15, 0, 15)
Tgl.BackgroundColor3 = THEME.Cyan
Tgl.Text = "UI"
Tgl.Font = Enum.Font.GothamBold
Tgl.TextColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 8)
Tgl.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- ✅ SIDEBAR (DANH SÁCH PET NHÌN BẰNG MẮT)
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 230, 1, -80)
Side.Position = UDim2.new(0, 15, 0, 15)
Side.BackgroundColor3 = THEME.Panel
Instance.new("UICorner", Side)

local ScrollPet = Instance.new("ScrollingFrame", Side)
ScrollPet.Size = UDim2.new(1, -10, 1, -10)
ScrollPet.Position = UDim2.new(0, 5, 0, 5)
ScrollPet.BackgroundTransparency = 1
ScrollPet.ScrollBarThickness = 1
local PetLayout = Instance.new("UIListLayout", ScrollPet)
PetLayout.Padding = UDim.new(0, 5)

for _, name in pairs(allBrainrots) do
    local b = Instance.new("TextButton", ScrollPet)
    b.Size = UDim2.new(1, -5, 0, 32)
    b.BackgroundColor3 = THEME.Cyan
    b.Text = name
    b.TextColor3 = Color3.fromRGB(0,0,0)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        Selected[name] = not Selected[name]
        b.BackgroundColor3 = Selected[name] and THEME.Cyan or Color3.fromRGB(40, 45, 55)
        b.TextColor3 = Selected[name] and Color3.fromRGB(0,0,0) or THEME.Text
    end)
end

-- ✅ SERVER CONTAINER (BẢNG JOINE)
local ServScroll = Instance.new("ScrollingFrame", Main)
ServScroll.Size = UDim2.new(1, -270, 1, -100)
ServScroll.Position = UDim2.new(0, 260, 0, 15)
ServScroll.BackgroundTransparency = 1
ServScroll.ScrollBarThickness = 2
Instance.new("UIListLayout", ServScroll).Padding = UDim.new(0, 10)

-- ✅ STATUS BAR (PHẦN SPAM JOIN)
local StatFrame = Instance.new("Frame", Main)
StatFrame.Size = UDim2.new(1, -30, 0, 45)
StatFrame.Position = UDim2.new(0, 15, 1, -60)
StatFrame.BackgroundColor3 = THEME.Panel
Instance.new("UICorner", StatFrame)

local StatText = Instance.new("TextLabel", StatFrame)
StatText.Size = UDim2.new(1, 0, 1, 0)
StatText.BackgroundTransparency = 1
StatText.Text = "WAITING FOR TARGET..."
StatText.TextColor3 = THEME.Cyan
StatText.Font = Enum.Font.GothamBold
StatText.TextSize = 14

-- ✅ HÀM ĐỊNH DẠNG TIỀN (GIỮ NGUYÊN CODE CŨ)
local function format(val)
    val = tonumber(val) or 0
    if val >= 1e6 then return string.format("$%.2fM/s", val / 1e6) end
    return "$" .. tostring(math.floor(val)) .. "/s"
end

-- ✅ SPAM JOIN THREAD (CỰC GẮT)
task.spawn(function()
    while true do
        if AutoJoinTarget then
            StatText.Text = "⚡ SPAMMING JOIN: " .. AutoJoinTarget:sub(1,15) .. "..."
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, AutoJoinTarget)
            end)
        end
        task.wait(0.3) -- Tốc độ spam 0.3s
    end
end)

-- ✅ REFRESH DATA VÀ VẼ DÒNG (GIỮ LOGIC JOINE)
task.spawn(function()
    while true do
        local ok, res = pcall(function() return game:HttpGet(API_BASE) end)
        if ok and res ~= "null" then
            local data = HttpService:JSONDecode(res)
            ServScroll:ClearAllChildren()
            Instance.new("UIListLayout", ServScroll).Padding = UDim.new(0, 10)
            
            for _, v in pairs(data) do
                if Selected[v.pet_name] then
                    local Row = Instance.new("Frame", ServScroll)
                    Row.Size = UDim2.new(1, -10, 0, 60)
                    Row.BackgroundColor3 = THEME.Panel
                    Instance.new("UICorner", Row)
                    local s = Instance.new("UIStroke", Row); s.Color = THEME.Cyan; s.Transparency = 0.7
                    
                    local Txt = Instance.new("TextLabel", Row)
                    Txt.Size = UDim2.new(0.65, 0, 1, 0)
                    Txt.Position = UDim2.new(0, 10, 0, 0)
                    Txt.Text = "Pet: " .. v.pet_name .. "\nValue: <font color='#00FFFF'>" .. format(v.value) .. "</font>"
                    Txt.RichText = true
                    Txt.TextColor3 = THEME.Text
                    Txt.TextXAlignment = 0
                    Txt.Font = Enum.Font.GothamBold
                    Txt.BackgroundTransparency = 1

                    local JoinBtn = Instance.new("TextButton", Row)
                    JoinBtn.Size = UDim2.new(0, 100, 0, 35)
                    JoinBtn.Position = UDim2.new(1, -110, 0.5, -17)
                    JoinBtn.BackgroundColor3 = THEME.Cyan
                    JoinBtn.Text = "SPAM JOIN"
                    JoinBtn.Font = Enum.Font.GothamBold
                    JoinBtn.TextColor3 = Color3.fromRGB(0,0,0)
                    Instance.new("UICorner", JoinBtn)

                    JoinBtn.MouseButton1Click:Connect(function()
                        AutoJoinTarget = v.job_id
                        JoinBtn.Text = "ACTIVE"
                        JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    end)
                end
            end
        end
        task.wait(3)
    end
end)
