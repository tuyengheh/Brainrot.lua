# Brainrot.lua
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlaceID = game.PlaceId

-- CONFIG
local MIN_M = 50
local MAX_M = 300

local function M(v)
    return v * 1000000
end

-- PET DATA
local PET_DATA = {
    ["griffin"] = 400,
    ["hydra dragon cannelloni"] = 300,
    ["dragon gingerini"] = 300,
    ["skibidi toilet"] = 330,
    ["garama"] = 50,
    ["madundung"] = 50,
    ["la secret combination"] = 125,
    ["ketchuru"] = 42.5,
    ["musturu"] = 42.5,
    ["tictac sahur"] = 37.5,
    ["tang tang keletang"] = 33.5
}

local selectedPet = "all"
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
Instance.new("UICorner", frame)

local visible = true

-- toggle UI
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        visible = not visible
        frame.Visible = visible
    end
end)

-- title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🔥 SĂN PET 50M-300M"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.BackgroundTransparency = 1

-- status
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,30)
status.Position = UDim2.new(0,0,0,30)
status.Text = "Sẵn sàng"
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1

-- dropdown
local dropdownBtn = Instance.new("TextButton", frame)
dropdownBtn.Size = UDim2.new(1,-20,0,35)
dropdownBtn.Position = UDim2.new(0,10,0,65)
dropdownBtn.Text = "Pet: ALL"

local dropdown = Instance.new("Frame", frame)
dropdown.Size = UDim2.new(1,-20,0,0)
dropdown.Position = UDim2.new(0,10,0,100)
dropdown.ClipsDescendants = true

local layout = Instance.new("UIListLayout", dropdown)

-- add ALL option
local function createBtn(name)
    local btn = Instance.new("TextButton", dropdown)
    btn.Size = UDim2.new(1,0,0,30)
    btn.Text = name

    btn.MouseButton1Click:Connect(function()
        selectedPet = name:lower()
        dropdownBtn.Text = "Pet: "..name
        dropdown.Size = UDim2.new(1,-20,0,0)
    end)
end

createBtn("ALL")

for pet,_ in pairs(PET_DATA) do
    createBtn(pet)
end

local open = false
dropdownBtn.MouseButton1Click:Connect(function()
    open = not open
    TweenService:Create(dropdown, TweenInfo.new(0.3), {
        Size = UDim2.new(1,-20,0, open and 150 or 0)
    }):Play()
end)

-- ESP
local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(1,-20,0,30)
espBtn.Position = UDim2.new(0,10,0,200)
espBtn.Text = "ESP: ON"

espBtn.MouseButton1Click:Connect(function()
    ESP_ON = not ESP_ON
    espBtn.Text = ESP_ON and "ESP: ON" or "ESP: OFF"
end)

-- start/stop
local startBtn = Instance.new("TextButton", frame)
startBtn.Size = UDim2.new(0.48,-5,0,30)
startBtn.Position = UDim2.new(0,10,0,230)
startBtn.Text = "START"

local stopBtn = Instance.new("TextButton", frame)
stopBtn.Size = UDim2.new(0.48,-5,0,30)
stopBtn.Position = UDim2.new(0.52,5,0,230)
stopBtn.Text = "STOP"

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
        local name = string.lower(v.Name)

        for pet, val in pairs(PET_DATA) do
            if string.find(name, pet) then
                if val >= MIN_M and val <= MAX_M then
                    if selectedPet == "all" or string.find(name, selectedPet) then
                        return true
                    end
                end
            end
        end
    end
end

-- hop
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

-- loop
startBtn.MouseButton1Click:Connect(function()
    running = true

    while running do
        status.Text = "Đang tìm..."

        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and HasPet(plr) then
                status.Text = "🔥 Tìm thấy: "..plr.Name
                Highlight(plr)
                return
            end
        end

        status.Text = "❌ Không thấy → chuyển server"
        wait(1)
        ServerHop()
        break
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    running = false
    status.Text = "Đã dừng"
end)
