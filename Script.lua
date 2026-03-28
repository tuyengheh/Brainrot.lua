# Brainrot.lua 
    --// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--------------------------------------------------
-- 📜 LIST RARE
local rareList = {
    "Garama and Madundung","Ketchuru and Musturu","La Secret Combinasion",
    "Lavadorito Spinito","Tang Tang Keletang","Tictac Sahur",
    "Spaghetti Tualetti","Eviledon","Los Spaghettis","Spooky and Pumpky",
    "67","Esok Sekolah","La Grande Combinasion","Strawberry Elephant",
    "Meowl","Skibidi Toilet","Cigno Fulgoro"
}

local function isRare(name)
    for _,v in pairs(rareList) do
        if string.lower(name):find(string.lower(v)) then
            return true
        end
    end
    return false
end

--------------------------------------------------
-- 📦 ESP CACHE
local espCache = {}

local function createESP(obj)
    if espCache[obj] then return end
    espCache[obj] = true

    local part = obj:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    local rare = isRare(obj.Name)

    local hl = Instance.new("Highlight")
    hl.Adornee = obj
    hl.FillTransparency = 0.4
    hl.OutlineTransparency = 0
    hl.FillColor = rare and Color3.fromRGB(255,50,50) or Color3.fromRGB(0,170,255)
    hl.Parent = obj

    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0,120,0,40)
    bill.AlwaysOnTop = true
    bill.Adornee = part
    bill.StudsOffset = Vector3.new(0,3,0)

    local text = Instance.new("TextLabel", bill)
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Text = obj.Name
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.TextColor3 = rare and Color3.new(1,0,0) or Color3.new(1,1,1)

    if rare then
        warn("🔥 FOUND RARE:", obj.Name)
    end

    bill.Parent = obj
end

--------------------------------------------------
-- 🔍 AUTO SCAN
task.spawn(function()
    while true do
        task.wait(3)
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart") then
                createESP(obj)
            end
        end
    end
end)

--------------------------------------------------
-- 🎨 GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 200)
frame.Position = UDim2.new(0.5, -130, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

-- DRAG
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Brainrot MENU"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- BUTTON
local function btn(text,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.8,0,0,35)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(70,70,70)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

local hopNew = btn("Hop NEW", 40)
local hopOld = btn("Hop OLD", 80)

--------------------------------------------------
-- 🔵 HOP NEW
hopNew.MouseButton1Click:Connect(function()
    local placeId = game.PlaceId
    local data = HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100")
    )

    for _,v in pairs(data.data) do
        if v.playing <= 3 then
            print("JOIN:", v.playing.."/"..v.maxPlayers)
            TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
            break
        end
    end
end)

--------------------------------------------------
-- 🟣 HOP OLD
hopOld.MouseButton1Click:Connect(function()
    local placeId = game.PlaceId
    local data = HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Desc&limit=100")
    )

    for _,v in pairs(data.data) do
        if v.playing >= (v.maxPlayers * 0.7) then
            print("JOIN:", v.playing.."/"..v.maxPlayers)
            TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
            break
        end
    end
end)
