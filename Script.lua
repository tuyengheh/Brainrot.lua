# Brainrot.lua
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- ===== PET LIST =====
local PET_LIST = {
    "griffin",
    "hydra dragon cannelloni",
    "dragon gingerini",
    "skibidi toilet",
    "garama",
    "madundung",
    "la secret combination"
}

local selectedPet = "griffin"
local ESP_ON = true

-- ===== UI =====
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,280,0,200)
frame.Position = UDim2.new(0.35,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0,255,150)
stroke.Thickness = 2

-- title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "🔥 SĂN PET PRO"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.BackgroundTransparency = 1

-- dropdown button
local dropdownBtn = Instance.new("TextButton", frame)
dropdownBtn.Size = UDim2.new(1,-20,0,35)
dropdownBtn.Position = UDim2.new(0,10,0,40)
dropdownBtn.Text = "Pet: "..selectedPet
dropdownBtn.BackgroundColor3 = Color3.fromRGB(30,30,40)
dropdownBtn.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0,8)

-- dropdown list
local dropdown = Instance.new("Frame", frame)
dropdown.Size = UDim2.new(1,-20,0,0)
dropdown.Position = UDim2.new(0,10,0,80)
dropdown.BackgroundColor3 = Color3.fromRGB(25,25,35)
dropdown.ClipsDescendants = true

Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0,8)

local layout = Instance.new("UIListLayout", dropdown)

-- tạo item
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

-- toggle dropdown
local open = false
dropdownBtn.MouseButton1Click:Connect(function()
    open = not open
    local size = open and 120 or 0

    TweenService:Create(dropdown, TweenInfo.new(0.3), {
        Size = UDim2.new(1,-20,0,size)
    }):Play()
end)

-- ESP toggle
local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(1,-20,0,35)
espBtn.Position = UDim2.new(0,10,0,170)
espBtn.Text = "ESP: ON"
espBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
espBtn.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0,8)

espBtn.MouseButton1Click:Connect(function()
    ESP_ON = not ESP_ON
    espBtn.Text = ESP_ON and "ESP: ON" or "ESP: OFF"
end)

-- highlight
local function Highlight(plr)
    if not ESP_ON then return end

    if plr.Character and not plr.Character:FindFirstChild("Highlight") then
        local hl = Instance.new("Highlight")
        hl.FillColor = Color3.fromRGB(255,0,0)
        hl.Parent = plr.Character
    end
end

-- test loop (demo)
task.spawn(function()
    while true do
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                Highlight(plr)
            end
        end
        task.wait(2)
    end
end)
