# Brainrot.lua 
-            repeat task.wait() until game:IsLoaded()

--// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local currentServerId = game.JobId

--------------------------------------------------
-- 🎯 LIST PET
local rareList = {
    "admin","Ketchuru","Combinasion","Lavadorito",
    "Tang","Tictac","Spaghetti","Eviledon",
    "Spooky","Strawberry","Meowl","Skibidi",
    "Cigno","Lava","Rainbow","Galaxy"
}

local function isRare(name)
    name = string.lower(name)
    for _,v in pairs(rareList) do
        if string.find(name, string.lower(v)) then
            return true
        end
    end
    return false
end

--------------------------------------------------
-- ❌ BASE CHECK
local function isMyBase(obj)
    local owner = obj:FindFirstChild("Owner")
    return owner and owner.Value == player
end

--------------------------------------------------
-- 🎨 GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 250)
frame.Position = UDim2.new(0.5, -130, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
Instance.new("UICorner", frame)

-- DRAG
local dragging, dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input == dragInput then
        dragging = false
    end
end)

-- ⌨️ PHÍM K
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.K then
        gui.Enabled = not gui.Enabled
    end
end)

-- 🌈 RAINBOW
RunService.RenderStepped:Connect(function()
    frame.BackgroundColor3 = Color3.fromHSV((tick()%5)/5,1,1)
end)

-- TEXT
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "RAINBOW FARM 🌈"
title.BackgroundTransparency = 1
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

local log = Instance.new("TextLabel", frame)
log.Size = UDim2.new(1,0,0,60)
log.Position = UDim2.new(0,0,0,30)
log.BackgroundTransparency = 1
log.Text = "Ready..."
log.TextScaled = true
log.TextColor3 = Color3.new(1,1,1)

-- BUTTON
local function btn(txt,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.8,0,0,35)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(0,0,0)
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    return b
end

local startBtn = btn("START AUTO",100)
local hopBtn   = btn("HOP SERVER",145)
local flyBtn   = btn("FLY BASE ⚡",190)

--------------------------------------------------
-- 🏠 FIND BASE
local function findBase()
    for _,v in pairs(workspace:GetDescendants()) do
        local owner = v:FindFirstChild("Owner")
        if owner and owner.Value == player then
            local p = v:FindFirstChildWhichIsA("BasePart")
            if p then return p.Position end
        end
    end
end

--------------------------------------------------
-- ✈️ BAY ANTI (NÚT)
local function flyToBaseFast()
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local base = findBase()
    if not base then return end

    -- bay lên ~5m
    local up = hrp.Position + Vector3.new(0,15,0)

    for i=1,10 do
        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(up),0.4)
        task.wait(0.02)
    end

    task.wait(0.1)

    -- bay về base
    for i=1,20 do
        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(base + Vector3.new(0,3,0)),0.35)
        task.wait(0.02)
    end
end

flyBtn.MouseButton1Click:Connect(flyToBaseFast)

--------------------------------------------------
-- 🤖 AUTO DETECT CẦM PET
task.spawn(function()
    while true do
        task.wait(0.5)

        local char = player.Character
        if not char then continue end

        for _,tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and isRare(tool.Name) then
                log.Text = "📦 "..tool.Name
                flyToBaseFast()
                task.wait(2)
            end
        end
    end
end)

--------------------------------------------------
-- 🔍 SCAN
local function scan()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and not isMyBase(v) then
            if isRare(v.Name) then
                return v
            end
        end
    end
end

--------------------------------------------------
-- 🧲 NHẶT
local function takePet(obj)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local part = obj:FindFirstChildWhichIsA("BasePart")

    if hrp and part then
        hrp.CFrame = part.CFrame + Vector3.new(0,3,0)
    end
end

--------------------------------------------------
-- 🔁 HOP
local function hop()
    local placeId = game.PlaceId

    local s,res = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=50")
    end)

    if s then
        local data = HttpService:JSONDecode(res)

        for _,v in pairs(data.data) do
            if v.id ~= currentServerId and v.playing < v.maxPlayers then
                TeleportService:TeleportToPlaceInstance(placeId,v.id,player)
                return
            end
        end
    end

    TeleportService:Teleport(placeId)
end

hopBtn.MouseButton1Click:Connect(hop)

--------------------------------------------------
-- 🔁 AUTO
startBtn.MouseButton1Click:Connect(function()
    log.Text = "Đang scan..."

    task.spawn(function()
        task.wait(1)

        local pet = scan()

        if pet then
            log.Text = "🔥 "..pet.Name
            takePet(pet)
        else
            log.Text = "❌ Không có → hop"
            hop()
        end
    end)
end)
