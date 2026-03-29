# Brainrot.lua 
--// PLAYER
local player = game.Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

--// GUI
local gui = Instance.new("ScreenGui", pg)
gui.Name = "AUTO_FARM"

-- 🌫 BLUR
local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 0
task.spawn(function()
    for i = 1,20 do
        blur.Size = i
        task.wait(0.02)
    end
end)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,260)
frame.Position = UDim2.new(0.5,-130,0.4,-130)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
Instance.new("UICorner",frame)

-- 🌈 ANIMATION
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    frame.BackgroundColor3 = Color3.fromHSV((tick()%5)/5,0.6,1)
end)

-- ✨ DRAG MƯỢT
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
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

UIS.InputEnded:Connect(function()
    dragging = false
end)

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "AUTO FARM PRO 🔥"
title.BackgroundTransparency = 1
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

local log = Instance.new("TextLabel",frame)
log.Size = UDim2.new(1,0,0,40)
log.Position = UDim2.new(0,0,0,30)
log.BackgroundTransparency = 1
log.Text = "READY"
log.TextScaled = true
log.TextColor3 = Color3.new(1,1,1)

--------------------------------------------------
-- 🎯 PET LIST
local targetList = {
    "Kitsune","Yeti","Tiger","Fruits","Rainbow","radioactive","Strawberry","Meowl"
}

local function isTarget(name)
    name = string.lower(name)
    for _,v in pairs(targetList) do
        if string.find(name, string.lower(v)) then
            return true
        end
    end
    return false
end

--------------------------------------------------
-- ❌ BỎ BASE
local function isMyBase(obj)
    local owner = obj:FindFirstChild("Owner")
    return owner and owner.Value == player
end
--------------------------------------------------
-- 📱 MOBILE DRAG (KÉO MƯỢT)
local UIS = game:GetService("UserInputService")

local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
--------------------------------------------------
-- BUTTON
local function btn(txt,y)
    local b = Instance.new("TextButton",frame)
    b.Size = UDim2.new(0.8,0,0,35)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(0,0,0)
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",b)

    -- hover effect
    b.MouseEnter:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(80,80,80)
    end)
    b.MouseLeave:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(0,0,0)
    end)

    return b
end

local flyBtn  = btn("FLY SPAWN 🚀",80)
local scanBtn = btn("SCAN + ESP 🔍",125)
local hopBtn  = btn("SERVER MỚI 🆕",170)

--------------------------------------------------
-- 💾 SPAWN
local spawnCFrame

local function setSpawn()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    spawnCFrame = hrp.CFrame
end

setSpawn()
player.CharacterAdded:Connect(function()
    task.wait(1)
    setSpawn()
end)

--------------------------------------------------
-- 🚀 FLY SPAWN (GIỮ NGUYÊN)
local function flyToSpawn()
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not spawnCFrame then return end

    for i = 1,30 do
        hrp.CFrame = hrp.CFrame:Lerp(spawnCFrame, 0.2)
        task.wait(0.03)
    end

    hrp.CFrame = spawnCFrame
end

--------------------------------------------------
-- 👁 ESP
local currentESP = nil

local function createESP(obj)
    if currentESP then
        currentESP:Destroy()
    end

    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(255,0,0)
    hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.5
    hl.Parent = obj

    currentESP = hl
end

--------------------------------------------------
-- 🧲 FLY PET
local function flyToPet(part)
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for i = 1,12 do
        hrp.CFrame = hrp.CFrame:Lerp(part.CFrame + Vector3.new(0,3,0), 0.35)
        task.wait(0.02)
    end

    hrp.CFrame = part.CFrame + Vector3.new(0,3,0)
end

--------------------------------------------------
-- ⚡ AUTO NHẶT (FIX)
local function autoPickup(part)
    for _,v in pairs(part:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            v.HoldDuration = 0
            v.RequiresLineOfSight = false
            fireproximityprompt(v)
        end
    end
end

--------------------------------------------------
-- 🔍 SCAN
local function scanPet()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and isTarget(v.Name) and not isMyBase(v) then
            local part = v:FindFirstChildWhichIsA("BasePart")
            if part then
                return v, part
            end
        end
    end
end

--------------------------------------------------
-- 🔥 SCAN + ESP + BAY
scanBtn.MouseButton1Click:Connect(function()
    log.Text = "🔍 SCANNING..."

    task.spawn(function()
        task.wait(0.3)

        local pet, part = scanPet()

        if pet and part then
            log.Text = "🔥 "..pet.Name
            createESP(pet)

            task.wait(0.2)

            flyToPet(part)

            task.wait(0.3)

            autoPickup(part)

            log.Text = "✅ DONE"
        else
            log.Text = "❌ KHÔNG CÓ"
        end
    end)
end)

--------------------------------------------------
-- 📊 FAKE PET SERVER
local fakePets = {"Kitsune","Yeti","Tiger","Nothing","Rainbow"}

local function randomPet()
    return fakePets[math.random(1,#fakePets)]
end

--------------------------------------------------
-- 🔥 HOP SERVER (HUB STYLE)
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

function hopNew()
    log.Text = "🔎 SCANNING SERVER..."

    local placeId = game.PlaceId
    local s,res = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100")
    end)

    if s then
        local data = HttpService:JSONDecode(res)

        for i,v in pairs(data.data) do
            local pet = randomPet()

            log.Text = "SV"..i.." | "..v.playing.."/"..v.maxPlayers.." | 🐾 "..pet
            task.wait(0.08)

            if v.playing <= 2 then
                log.Text = "🆕 JOIN ("..pet..")"
                task.wait(0.2)

                TeleportService:TeleportToPlaceInstance(placeId,v.id,player)
                return
            end
        end
    end

    TeleportService:Teleport(placeId)
end

--------------------------------------------------
-- ⌨️ KEY K
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.K then
        gui.Enabled = not gui.Enabled
    end
end)

--------------------------------------------------
-- CONNECT
flyBtn.MouseButton1Click:Connect(flyToSpawn)
hopBtn.MouseButton1Click:Connect(hopNew)

log.Text = "READY ✅"
