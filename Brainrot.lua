local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlaceID = game.PlaceId

-- PET LIST
local PET_LIST = {
    "griffin",
    "hydra dragon cannelloni",
    "dragon gingerini",
    "skibidi toilet",
    "garama",
    "madundung",
    "la secret combination",
    "ketchuru",
    "musturu",
    "tictac sahur",
    "tang tang keletang"
}

local selectedPet = "griffin"
local ESP_ON = true
local running = false

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,260)
frame.Position = UDim2.new(0.35,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0,255,150)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "🔥 SĂN PET PRO"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.BackgroundTransparency = 1

-- status
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,30)
status.Position = UDim2.new(0,0,0,35)
status.Text = "Sẵn sàng"
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1

-- dropdown
local dropdownBtn = Instance.new("TextButton", frame)
dropdownBtn.Size = UDim2.new(1,-20,0,35)
dropdownBtn.Position = UDim2.new(0,10,0,70)
dropdownBtn.Text = "Pet: "..selectedPet
dropdownBtn.BackgroundColor3 = Color3.fromRGB(30,30,40)
dropdownBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", dropdownBtn)

local dropdown = Instance.new("Frame", frame)
dropdown.Size = UDim2.new(1,-20,0,0)
dropdown.Position = UDim2.new(0,10,0,110)
dropdown.BackgroundColor3 = Color3.fromRGB(25,25,35)
dropdown.ClipsDescendants = true
Instance.new("UICorner", dropdown)

local layout = Instance.new("UIListLayout", dropdown)

for _,pet in pairs(PET_LIST) do
    local btn = Instance.new("TextButton", dropdown)
    btn.Size = UDim2.new(1,0,0,30)
    btn.Text = pet
    btn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    btn.TextColor3 = Color3.new(1,1,1)

    btn.MouseButton1Click:Connect(function()
        selectedPet = pet
        dropdownBtn.Text = "Pet: "..pet
        TweenService:Create(dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1,-20,0,0)}):Play()
    end)
end

local open = false
dropdownBtn.MouseButton1Click:Connect(function()
    open = not open
    TweenService:Create(dropdown, TweenInfo.new(0.3), {
        Size = UDim2.new(1,-20,0, open and 120 or 0)
    }):Play()
end)

-- ESP
local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(1,-20,0,30)
espBtn.Position = UDim2.new(0,10,0,200)
espBtn.Text = "ESP: ON"
espBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
espBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", espBtn)

espBtn.MouseButton1Click:Connect(function()
    ESP_ON = not ESP_ON
    espBtn.Text = ESP_ON and "ESP: ON" or "ESP: OFF"
end)

-- START / STOP
local startBtn = Instance.new("TextButton", frame)
startBtn.Size = UDim2.new(0.48,-5,0,35)
startBtn.Position = UDim2.new(0,10,0,235)
startBtn.Text = "▶ START"
startBtn.BackgroundColor3 = Color3.fromRGB(50,200,100)

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(0.48,-5,0,35)
stopBtn.Position = UDim2.new(0.52,5,0,235)
stopBtn.Text = "⛔ STOP"
stopBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)

-- highlight
local function Highlight(plr)
    if not ESP_ON then return end
    if plr.Character and not plr.Character:FindFirstChild("Highlight") then
        local hl = Instance.new("Highlight")
        hl.FillColor = Color3.fromRGB(255,0,0)
        hl.Parent = plr.Character
    end
end

-- detect
local function HasPet(plr)
    for _,v in pairs(plr:GetDescendants()) do
        if string.find(string.lower(v.Name), selectedPet) then
            return true
        end
    end
end

-- server hop
local function ServerHop()
    local req = Http:JSONDecode(game:HttpGet(
        "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
    ))

    for _,v in pairs(req.data) do
        if v.playing < v.maxPlayers then
            TeleportService:TeleportToPlaceInstance(PlaceID, v.id)
            break
        end
    end
end

-- MAIN
startBtn.MouseButton1Click:Connect(function()
    running = true

    while running do
        status.Text = "Đang tìm: "..selectedPet

        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and HasPet(plr) then
                status.Text = "🔥 Tìm thấy: "..plr.Name
                Highlight(plr)
                return
            end
        end

        status.Text = "❌ Không thấy server → chuyển..."
        wait(1)
        ServerHop()
        break
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    status.Text = "Đã dừng"
end)
