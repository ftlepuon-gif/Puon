--[[ 
    STEAL BRAINROT - ULTIMATE DARK EDITION 
    Features: Dark UI, Auto-Format Value, Pet List Visual, Spam Joiner, Encrypted
]]

local _0x1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
function _d(d) d=string.gsub(d,'[^'.._0x1..'=]','')return(d:gsub('.',function(x)if(x=='=')then return''end local r,f='',(_0x1:find(x)-1)for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and'1' or '0')end return r end):gsub('%d%d%d%d%d%d%d%d',function(x)local c=0 for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0)end return string.char(c)end))end
local _C = _d("aHR0cHM6Ly9qb2luZS04MmNhMC1kZWZhdWx0LXJ0ZGIuZmlyZWJhc2Vpby5jb20vU2VydmVycy5qc29u")

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local AutoJoinTarget = nil

-- DANH SÁCH PET BRAINROT (FULL)
local allBrainrots = {"Los Nooo My Hotspotsitos","Serafinna Medusella","La Grande Combinassion","La Easter Grande","Rang Ring Bus","Guest 666","Los Mi Gatitos","Los Chicleteiras","Noo My Eggs","67","Donkeyturbo Express","Mariachi Corazoni","Los Burritos","Los 25","Tacorillo Crocodillo","Swag Soda","Noo my Heart","Chimnino","Los Combinasionas","Chicleteira Noelteira","Fishino Clownino","Baskito","Tacorita Bicicleta","Los Sweethearts","Spinny Hammy","Nuclearo Dinosauro","Las Sis","DJ Panda","Chicleteira Cupideira","La Karkerkar Combinasion","Chillin Chili","Chipso and Queso","Money Money Reindeer","Money Money Puggy","Churrito Bunnito","Celularcini Viciosini","Los Planitos","Los Mobilis","Los 67","Mieteteira Bicicleteira","Tuff Toucan","La Spooky Grande","Los Spooky Combinasionas","Cigno Fulgoro","Los Candies","Los Hotspositos","Los Jolly Combinasionas","Los Cupids","Los Puggies","W or L","Tralalalaledon","La Extinct Grande Combinasion","Tralaledon","La Jolly Grande","Los Primos","Bacuru and Egguru","Eviledon","Los Tacoritas","Lovin Rose","Tang Tang Kelentang","Ketupat Kepat","Los Bros","Tictac Sahur","La Romantic Grande","Gingerat Gerat","Orcaledon","La Lucky Grande","Ketchuru and Masturu","Jolly Jolly Sahur","Garama and Madundung","Rosetti Tualetti","Nacho Spyder","Hopilikalika Hopilikalako","Festive 67","Sammyni Fattini","Love Love Bear","La Ginger Sekolah","Spooky and Pumpky","Boppin Bunny","Lavadorito Spinito","La Food Combinasion","Los Spaghettis","La Casa Boo","Fragrama and Chocrama","Los Sekolahs","Foxini Lanternini","La Secret Combinasion","Los Amigos","Reinito Sleighito","Ketupat Bros","Burguro and Fryuro","Cooki and Milki","Capitano Moby","Rosey and Teddy","Popcuru and Fizzuru","Hydra Bunny","Celestial Pegasus","Cerberus","La Supreme Combinasion","Dragon Cannelloni","Dragon Gingerini","Headless Horseman","Hydra Dragon Cannelloni","Griffin","Skibidi Toilet","Meowl","Strawberry Elephant","La Vacca Saturno Saturnita","Pandanini Frostini","Bisonte Giuppitere","Blackhole Goat","Jackorilla","Agarrini Ia Palini","Chachechi","Karkerkar Kurkur","Los Tortus","Los Matteos","Sammyni Spyderini","Trenostruzzo Turbo 4000","Chimpanzini Spiderini","Boatito Auratito","Fragola La La La","Dul Dul Dul","La Vacca Prese Presente","Frankentteo","Los Trios","Karker Sahur","Torrtuginni Dragonfrutini (Lucky Block)","Los Tralaleritos","Zombie Tralala","La Cucaracha","Vulturino Skeletono","Guerriro Digitale","Extinct Tralalero","Yess My Examine","Extinct Matteo","Las Tralaleritas","Rocco Disco","Reindeer Tralala","Las Vaquitas Saturnitas","Pumpkin Spyderini","Job Job Job Sahur","Los Karkeritos","Graipuss Medussi","Santteo","Fishboard","Buntteo","La Vacca Jacko Linterino","Triplito Tralaleritos","Trickolino","Paradiso Axolottino","GOAT","Giftini Spyderini","Los Spyderinis","Love Love Love Sahur","Perrito Burrito","1x1x1x1","Los Cucarachas","Easter Easter Sahur","Please My Present","Cuadramat and Pakrahmatmamat","Los Jobcitos","Nooo My Hotspot","Pot Hotspot (Lucky Block)","Noo My Examine","Telemorte","La Sahur Combinasion","List List List Sahur","Bunny Bunny Bunny Sahur","To To To Sahur","Pirulitoita Bicicletaire","25","Santa Hotspot","Horegini Boom","Quesadilla Crocodila","Pot Pumpkin","Naughty Naughty","Cupid Cupid Sahur","Ho Ho Ho Sahur","Mi Gatito","Chicleteira Bicicleteira","Eid Eid Eid Sahur","Cupid Hotspot","Spaghetti Tualetti (Lucky Block)","Esok Sekolah (Lucky Block)","Quesadillo Vampiro","Brunito Marsito","Chill Puppy","Burrito Bandito","Chicleteirina Bicicletaire","Granny","Los Bunitos","Los Quesadillas","Bunito Bunito Spinito","Noo My Candy"}
local Selected = {}
for _,v in pairs(allBrainrots) do Selected[v] = true end

-- UI CREATION
local Gui = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 680, 0, 420); Main.Position = UDim2.new(0.5, -340, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(255, 40, 40)

-- SIDEBAR (PET LIST)
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 220, 1, -20); Side.Position = UDim2.new(0, 10, 0, 10); Side.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Instance.new("UICorner", Side)

local ScrollPet = Instance.new("ScrollingFrame", Side)
ScrollPet.Size = UDim2.new(1, -10, 1, -50); ScrollPet.Position = UDim2.new(0, 5, 0, 40); ScrollPet.BackgroundTransparency = 1; ScrollPet.ScrollBarThickness = 1
Instance.new("UIListLayout", ScrollPet).Padding = UDim.new(0, 3)

for _, name in pairs(allBrainrots) do
    local b = Instance.new("TextButton", ScrollPet)
    b.Size = UDim2.new(1, -5, 0, 30); b.BackgroundColor3 = Color3.fromRGB(255, 45, 45); b.Text = name; b.TextColor3 = Color3.fromRGB(255,255,255); b.Font = Enum.Font.GothamBold; b.TextSize = 10
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        Selected[name] = not Selected[name]
        b.BackgroundColor3 = Selected[name] and Color3.fromRGB(255, 45, 45) or Color3.fromRGB(35, 35, 40)
    end)
end

-- SERVER DISPLAY
local ServScroll = Instance.new("ScrollingFrame", Main)
ServScroll.Size = UDim2.new(1, -250, 1, -70); ServScroll.Position = UDim2.new(0, 240, 0, 15); ServScroll.BackgroundTransparency = 1; ServScroll.ScrollBarThickness = 2
Instance.new("UIListLayout", ServScroll).Padding = UDim.new(0, 6)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(1, -250, 0, 35); Status.Position = UDim2.new(0, 240, 1, -45); Status.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Status.Text = "WAITING FOR CLONES..."; Status.TextColor3 = Color3.fromRGB(255, 45, 45); Status.Font = Enum.Font.GothamBold
Instance.new("UICorner", Status)

local function format(v)
    v = tonumber(v) or 0
    if v >= 1e9 then return string.format("$%.2fB/s",v/1e9) elseif v >= 1e6 then return string.format("$%.2fM/s",v/1e6) end
    return "$" .. math.floor(v) .. "/s"
end

-- SPAM JOIN THREAD
task.spawn(function()
    while task.wait(0.4) do
        if AutoJoinTarget then
            Status.Text = "SPAMMING JOIN: " .. AutoJoinTarget:sub(1,12)
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, AutoJoinTarget) end)
        end
    end
end)

-- UPDATE LOOP
task.spawn(function()
    while task.wait(3) do
        local ok, res = pcall(function() return game:HttpGet(_C) end)
        if ok and res ~= "null" then
            local data = HttpService:JSONDecode(res)
            ServScroll:ClearAllChildren()
            Instance.new("UIListLayout", ServScroll).Padding = UDim.new(0, 6)
            for _, v in pairs(data) do
                if Selected[v.pet_name] then
                    local r = Instance.new("Frame", ServScroll)
                    r.Size = UDim2.new(1, -10, 0, 50); r.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
                    Instance.new("UICorner", r)
                    local t = Instance.new("TextLabel", r); t.Text = " " .. v.pet_name .. "\n " .. format(v.value); t.TextColor3 = Color3.fromRGB(255,255,255); t.Size = UDim2.new(0.6,0,1,0); t.BackgroundTransparency = 1; t.TextXAlignment = 0; t.Font = 17
                    local j = Instance.new("TextButton", r); j.Text = "SPAM JOIN"; j.Size = UDim2.new(0, 90, 0, 30); j.Position = UDim2.new(1,-100,0.5,-15); j.BackgroundColor3 = Color3.fromRGB(255,45,45); j.TextColor3 = Color3.fromRGB(255,255,255); j.Font = 17
                    Instance.new("UICorner", j)
                    j.MouseButton1Click:Connect(function() AutoJoinTarget = v.job_id end)
                end
            end
        end
    end
end)
