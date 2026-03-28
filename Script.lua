# Brainrot.lua 
-         --// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local currentServerId = game.JobId

--------------------------------------------------
-- 🎯 LIST PET HIẾM
local rareList = {
    "Garama and Madundung",
    "Ketchuru and Musturu",
    "La Secret Combinasion",
    "Lavadorito Spinito",
    "Tang Tang Keletang",
    "Tictac Sahur",
    "Spaghetti Tualetti",
    "Eviledon",
    "Los Spaghettis",
    "Spooky and Pumpky",
    "La Grande Combinasion",
    "Strawberry Elephant",
    "Meowl",
    "Skibidi Toilet",
    "Cigno Fulgoro"
}

local function isRare(name)
    for _,v in pairs(rareList) do
        if string.lower(name) == string.lower(v) then
            return true
        end
    end
    return false
end

--------------------------------------------------
-- 🌈 GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 180)
frame.Position = UDim2.new(0.5, -140, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "RAINBOW FARM 🌈"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- 🌈 Rainbow effect
RunService.RenderStepped:Connect(function()
    local t = tick()
    local color = Color3.fromHSV((t % 5)/5,1,1)
    frame.BackgroundColor3 = color
end)

local log = Instance.new("TextLabel", frame)
log.Size = UDim2.new(1,0,0,80)
log.Position = UDim2.new(0,0,0,30)
log.BackgroundTransparency = 1
log.TextColor3 = Color3.new(1,1,1)
log.Text = "Ready..."
log.TextWrapped = true
log.Font = Enum.Font.Gotham
log.TextScaled = true

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.8,0,0,35)
btn.Position = UDim2.new(0.1,0,0,120)
btn.Text = "START 🔥"
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

--------------------------------------------------
-- ✨ ESP CHỈ PET HIẾM
local function createESP(obj)
    if not obj:IsA("Model") then return end
    if not isRare(obj.Name) then return end

    local part = obj:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    local hl = Instance.new("Highlight")
    hl.Adornee = obj
    hl.FillColor = Color3.fromRGB(255,0,0)
    hl.FillTransparency = 0.3
    hl.OutlineTransparency = 0
    hl.Parent = obj

    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0,120,0,40)
    bill.Adornee = part
    bill.AlwaysOnTop = true

    local txt = Instance.new("TextLabel", bill)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = "🔥 "..obj.Name
    txt.TextColor3 = Color3.new(1,0,0)
    txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold

    bill.Parent = obj
end

--------------------------------------------------
-- 🔍 SCAN
local function scan()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            if isRare(v.Name) then
                createESP(v)
                return true, v.Name
            end
        end
    end
    return false, nil
end

--------------------------------------------------
-- 🚀 HOP NHANH
local function hop()
    local placeId = game.PlaceId

    local success, result = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=50")
    end)

    if success then
        local data = HttpService:JSONDecode(result)

        for _,v in pairs(data.data) do
            if v.id ~= currentServerId and v.playing < v.maxPlayers then
                TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
                return
            end
        end
    end

    TeleportService:Teleport(placeId, player)
end

--------------------------------------------------
-- 🔁 LOOP
local running = false

btn.MouseButton1Click:Connect(function()
    running = not running

    if running then
        btn.Text = "RUNNING..."
        log.Text = "🔍 Scan..."

        task.spawn(function()
            task.wait(1.5)

            local found, name = scan()

            if found then
                log.Text = "🔥 FOUND: "..name
                btn.Text = "FOUND!"
                running = false
            else
                log.Text = "❌ Không có → hop"
                task.wait(0.5)
                hop()
            end
        end)
    else
        btn.Text = "START 🔥"
        log.Text = "Stopped"
    end
end)
