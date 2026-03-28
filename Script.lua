# Brainrot.lua 
-         --// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local currentServerId = game.JobId

--------------------------------------------------
-- 🎯 PET HIẾM (bạn có thể thêm)
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

--------------------------------------------------
-- 🎨 GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 180)
frame.Position = UDim2.new(0.5, -140, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Auto Scan Server 🔥"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local log = Instance.new("TextLabel", frame)
log.Size = UDim2.new(1,0,0,80)
log.Position = UDim2.new(0,0,0,30)
log.BackgroundTransparency = 1
log.TextColor3 = Color3.new(1,1,1)
log.Text = "Ready..."
log.TextWrapped = true
log.Font = Enum.Font.Gotham
log.TextScaled = true

local function createBtn(text,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.8,0,0,35)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(80,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

local startBtn = createBtn("Start Scan 🔥", 120)

--------------------------------------------------
-- 🔍 CHECK PET HIẾM
local function isRare(name)
    for _,v in pairs(rareList) do
        if string.lower(name) == string.lower(v) then
            return true
        end
    end
    return false
end

local function scanPets()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name

            if string.find(string.lower(name),"brain") 
            or string.find(string.lower(name),"pet") then

                if isRare(name) then
                    return true, name
                end
            end
        end
    end
    return false, nil
end

--------------------------------------------------
-- 🔁 HOP SERVER
local function hopServer()
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
-- 🚀 AUTO LOOP
local running = false

startBtn.MouseButton1Click:Connect(function()
    running = not running

    if running then
        startBtn.Text = "Running..."
        log.Text = "🔍 Đang scan server..."

        task.spawn(function()
            task.wait(2) -- đợi load map

            local found, petName = scanPets()

            if found then
                log.Text = "🔥 FOUND: "..petName
                startBtn.Text = "FOUND!"
                running = false
            else
                log.Text = "❌ Không có pet hiếm → hop..."
                task.wait(1)
                hopServer()
            end
        end)

    else
        startBtn.Text = "Start Scan 🔥"
        log.Text = "Stopped"
    end
end)
