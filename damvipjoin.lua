local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local firebaseURL = "https://joine-82ca0-default-rtdb.firebaseio.com/Servers.json"

-- ✅ GIỮ NGUYÊN DANH SÁCH PET VIP CỦA BẠN
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

local SelectedPets = {}
for _, v in pairs(allBrainrots) do SelectedPets[v] = true end

local AutoJoinTarget = nil -- Biến lưu JobId để Spam Join

-- ✅ HÀM FORMAT TIỀN CHUẨN VIDEO
local function formatMoney(val)
    val = tonumber(val) or 0
    if val >= 1e9 then return string.format("$%.2fB/s", val / 1e9)
    elseif val >= 1e6 then return string.format("$%.2fM/s", val / 1e6)
    elseif val >= 1e3 then return string.format("$%.2fK/s", val / 1e3)
    else return "$" .. tostring(math.floor(val)) .. "/s" end
end

-- ✅ GIAO DIỆN CHÍNH
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 650, 0, 450); Main.Position = UDim2.new(0.5, -325, 0.5, -225); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Main)

-- PANEL TRÁI: DANH SÁCH PET (NHÌN BẰNG MẮT)
local PetPanel = Instance.new("Frame", Main)
PetPanel.Size = UDim2.new(0, 200, 1, -20); PetPanel.Position = UDim2.new(0, 10, 0, 10); PetPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", PetPanel)

local PetScroll = Instance.new("ScrollingFrame", PetPanel)
PetScroll.Size = UDim2.new(1, -10, 1, -40); PetScroll.Position = UDim2.new(0, 5, 0, 35); PetScroll.BackgroundTransparency = 1; PetScroll.ScrollBarThickness = 2
Instance.new("UIListLayout", PetScroll).Padding = UDim.new(0, 2)

for _, name in pairs(allBrainrots) do
    local btn = Instance.new("TextButton", PetScroll)
    btn.Size = UDim2.new(1, -5, 0, 28); btn.BackgroundColor3 = Color3.fromRGB(255, 60, 60); btn.Text = name; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.TextSize = 10; btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        SelectedPets[name] = not SelectedPets[name]
        btn.BackgroundColor3 = SelectedPets[name] and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(40, 40, 40)
    end)
end

-- PANEL PHẢI: SERVER LIST
local ServerScroll = Instance.new("ScrollingFrame", Main)
ServerScroll.Size = UDim2.new(1, -230, 1, -80); ServerScroll.Position = UDim2.new(0, 220, 0, 20); ServerScroll.BackgroundTransparency = 1; ServerScroll.ScrollBarThickness = 2
Instance.new("UIListLayout", ServerScroll).Padding = UDim.new(0, 5)

-- ✅ NÚT SPAM JOIN TRẠNG THÁI
local StatusLbl = Instance.new("TextLabel", Main)
StatusLbl.Size = UDim2.new(0, 410, 0, 30); StatusLbl.Position = UDim2.new(0, 220, 1, -40); StatusLbl.BackgroundColor3 = Color3.fromRGB(25, 25, 25); StatusLbl.Text = "Spam Join: OFF"; StatusLbl.TextColor3 = Color3.fromRGB(150, 150, 150); StatusLbl.Font = Enum.Font.GothamBold
Instance.new("UICorner", StatusLbl)

-- ✅ HÀM THỰC THI SPAM JOIN
task.spawn(function()
    while true do
        if AutoJoinTarget then
            StatusLbl.Text = "🔥 ĐANG SPAM JOIN SERVER: " .. AutoJoinTarget:sub(1,8) .. "..."
            StatusLbl.TextColor3 = Color3.fromRGB(255, 60, 60)
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, AutoJoinTarget)
            end)
        end
        task.wait(0.5) -- Thử lại sau mỗi 0.5 giây
    end
end)

-- VÒNG LẶP CẬP NHẬT DỮ LIỆU
task.spawn(function()
    while true do
        local ok, res = pcall(function() return game:HttpGet(firebaseURL) end)
        if ok and res ~= "null" then
            local data = HttpService:JSONDecode(res)
            ServerScroll:ClearAllChildren()
            Instance.new("UIListLayout", ServerScroll).Padding = UDim.new(0, 5)
            
            for _, v in pairs(data) do
                if SelectedPets[v.pet_name] then
                    local Row = Instance.new("Frame", ServerScroll)
                    Row.Size = UDim2.new(1, -10, 0, 45); Row.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", Row)
                    
                    local txt = Instance.new("TextLabel", Row)
                    txt.Text = " " .. v.pet_name .. "\n " .. formatMoney(v.value); txt.Size = UDim2.new(0.6, 0, 1, 0); txt.TextColor3 = Color3.fromRGB(255, 255, 255); txt.TextXAlignment = Enum.TextXAlignment.Left; txt.BackgroundTransparency = 1; txt.Font = Enum.Font.GothamBold; txt.TextSize = 12

                    local JoinBtn = Instance.new("TextButton", Row)
                    JoinBtn.Text = "SPAM JOIN"; JoinBtn.Size = UDim2.new(0, 80, 0, 30); JoinBtn.Position = UDim2.new(1, -90, 0.5, -15); JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60); JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255); JoinBtn.Font = Enum.Font.GothamBold
                    Instance.new("UICorner", JoinBtn)

                    JoinBtn.MouseButton1Click:Connect(function()
                        AutoJoinTarget = v.job_id -- Kích hoạt spam join vào server này
                    end)
                end
            end
        end
        task.wait(3)
    end
end)
