--// PLAYER
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

--// GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "AUTO_FARM"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,420)
frame.Position = UDim2.new(0.5,-130,0.4,-130)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,750)
scroll.BackgroundTransparency = 1

local title = Instance.new("TextLabel",scroll)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Premium 🔥"
title.BackgroundTransparency = 1
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

local log = Instance.new("TextLabel",scroll)
log.Size = UDim2.new(1,0,0,40)
log.Position = UDim2.new(0,0,0,30)
log.BackgroundTransparency = 1
log.Text = "READY"
log.TextScaled = true
log.TextColor3 = Color3.new(1,1,1)

-- INPUT PET
local input = Instance.new("TextBox",scroll)
input.Size = UDim2.new(0.8,0,0,35)
input.Position = UDim2.new(0.1,0,0,75)
input.PlaceholderText = "Nhập tên pet..."

-- BUTTON
local function btn(txt,y)
    local b = Instance.new("TextButton",scroll)
    b.Size = UDim2.new(0.8,0,0,35)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(0,0,0)
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",b)
    return b
end

local flyBtn   = btn("FLY SPAWN 🚀",120)
local scanBtn  = btn("SCAN + NHẶT 🔍",165)
local aimBtn   = btn("AIM OFF 🎯",210)
local espBtn   = btn("ESP OFF 👁",255)
local hopBtn   = btn("HOP NHANH ⚡",300)

--------------------------------------------------
-- ⚡ SPEED INPUT (1-100)
local speedValue = 16

local speedBox = Instance.new("TextBox", scroll)
speedBox.Size = UDim2.new(0.8,0,0,35)
speedBox.Position = UDim2.new(0.1,0,0,345)
speedBox.PlaceholderText = "Nhập speed (1-100)"
speedBox.Text = "16"
speedBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.TextScaled = true
Instance.new("UICorner", speedBox)

local speedBtn = btn("SET SPEED ⚡",390)

speedBtn.MouseButton1Click:Connect(function()
    local num = tonumber(speedBox.Text)

    if num then
        num = math.clamp(num,1,100)
        speedValue = num

        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = speedValue end

        log.Text = "⚡ SPEED: "..speedValue
    else
        log.Text = "❌ SAI SỐ"
    end
end)

-- giữ speed
task.spawn(function()
    while true do
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= speedValue then
            hum.WalkSpeed = speedValue
        end
        task.wait(0.2)
    end
end)

--------------------------------------------------
-- NOCLIP
local noclip = false
game:GetService("RunService").Stepped:Connect(function()
    if noclip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

--------------------------------------------------
-- SPAWN
local spawnCFrame
local function setSpawn()
    local char = player.Character or player.CharacterAdded:Wait()
    spawnCFrame = char:WaitForChild("HumanoidRootPart").CFrame
end

setSpawn()
player.CharacterAdded:Connect(function()
    task.wait(1)
    setSpawn()
end)

local function flyToSpawn()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not spawnCFrame then return end

    for i = 1,30 do
        hrp.CFrame = hrp.CFrame:Lerp(spawnCFrame,0.15)
        task.wait(0.03)
    end
end

--------------------------------------------------
-- SCAN + NHẶT (GIỮ NGUYÊN)
local function scanPet()
    local keyword = string.lower(input.Text)
    local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    local closest, part, dist = nil, nil, math.huge

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            local p = v:FindFirstChildWhichIsA("BasePart")
            if p then
                local d = (myHRP.Position - p.Position).Magnitude
                if d < 250 and (keyword=="" or string.find(string.lower(v.Name), keyword)) then
                    if d < dist then
                        dist = d
                        closest = v
                        part = p
                    end
                end
            end
        end
    end

    return closest, part
end

local function autoPickup(part)
    for i=1,6 do
        for _,v in pairs(part:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
                fireproximityprompt(v)
            end
        end
        task.wait(0.2)
    end
end

scanBtn.MouseButton1Click:Connect(function()
    local pet, part = scanPet()
    if pet then
        log.Text = "🔥 "..pet.Name
        autoPickup(part)
    else
        log.Text = "❌ KHÔNG CÓ"
    end
end)

--------------------------------------------------
-- AIM
local aimEnabled = false
local holdingMouse = false

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingMouse = true
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingMouse = false
    end
end)

task.spawn(function()
    while true do
        if aimEnabled and holdingMouse then
            local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            for _,plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        camera.CFrame = CFrame.new(camera.CFrame.Position, hrp.Position)
                        break
                    end
                end
            end
        end
        task.wait(0.02)
    end
end)

aimBtn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimBtn.Text = aimEnabled and "AIM ON 🎯" or "AIM OFF 🎯"
end)

--------------------------------------------------
-- HOP SERVER
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

hopBtn.MouseButton1Click:Connect(function()
    local s,res = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100")
    end)

    if s then
        local data = HttpService:JSONDecode(res)
        for _,v in pairs(data.data) do
            if v.playing < v.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, player)
                break
            end
        end
    end
end)

--------------------------------------------------
-- KEY
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.K then
        gui.Enabled = not gui.Enabled
    end
end)

log.Text = "READY ✅"
