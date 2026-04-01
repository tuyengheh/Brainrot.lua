# Brainrot.lua
--// PLAYER
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

--// GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "AUTO_FARM"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,380)
frame.Position = UDim2.new(0.5,-130,0.4,-130)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,650)
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

-- INPUT
local input = Instance.new("TextBox",scroll)
input.Size = UDim2.new(0.8,0,0,35)
input.Position = UDim2.new(0.1,0,0,75)
input.PlaceholderText = "Nhập tên (vd: egg)..."

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

local farmBtn  = btn("AUTO FARM OFF 🤖",120)
local scanBtn  = btn("SCAN + NHẶT 🔍",165)
local aimBtn   = btn("AIM OFF 🎯",210)
local espBtn   = btn("ESP NAME 👁",255)
local hopBtn   = btn("HOP NHANH ⚡",300)

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
-- FLY MƯỢT (ANTI KICK)
local function smoothFly(part)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    noclip = true
    local start = tick()

    while part and part.Parent do
        local target = part.Position + Vector3.new(0,3,0)
        local dist = (hrp.Position - target).Magnitude

        if dist < 3 or tick() - start > 5 then break end

        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(target), 0.08)
        task.wait(0.03)
    end

    noclip = false
end

--------------------------------------------------
-- SCAN FULL MAP
local function scanPet()
    local keyword = string.lower(input.Text)

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            local p = v:FindFirstChildWhichIsA("BasePart")
            if p then
                if keyword == "" or string.find(string.lower(v.Name), keyword) then
                    return v, p
                end
            end
        end
    end
end

--------------------------------------------------
-- AUTO PICKUP
local function autoPickup(part)
    for i = 1,5 do
        if not part then break end
        for _,v in pairs(part:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
                fireproximityprompt(v)
            end
        end
        task.wait(0.3)
    end
end

--------------------------------------------------
-- AUTO FARM (BAY MƯỢT)
local farming = false

task.spawn(function()
    while true do
        if farming then
            local pet, part = scanPet()

            if pet then
                log.Text = "🤖 "..pet.Name
                smoothFly(part)
                autoPickup(part)
            else
                log.Text = "❌ KHÔNG CÓ"
            end
        end
        task.wait(0.5)
    end
end)

farmBtn.MouseButton1Click:Connect(function()
    farming = not farming
    farmBtn.Text = farming and "AUTO FARM ON 🤖" or "AUTO FARM OFF 🤖"
end)

--------------------------------------------------
-- SCAN BUTTON
scanBtn.MouseButton1Click:Connect(function()
    local pet, part = scanPet()
    if pet then
        smoothFly(part)
        autoPickup(part)
    end
end)

--------------------------------------------------
-- AIM (GIỮ NGUYÊN)
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

local function getClosestPlayer()
    local closest, dist = nil, math.huge
    local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (myHRP.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = plr.Character.HumanoidRootPart
            end
        end
    end

    return closest
end

task.spawn(function()
    while true do
        if aimEnabled and holdingMouse then
            local target = getClosestPlayer()
            if target then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
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
-- ESP (GIỮ)
local espEnabled = false
local espObjects = {}

local function clearESP()
    for _,v in pairs(espObjects) do
        if v then v:Destroy() end
    end
    espObjects = {}
end

local function createESP()
    clearESP()
    local keyword = string.lower(input.Text)

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            if keyword ~= "" and string.find(string.lower(v.Name), keyword) then
                local part = v:FindFirstChildWhichIsA("BasePart")
                if part then
                    local bill = Instance.new("BillboardGui", game.CoreGui)
                    bill.Adornee = part
                    bill.Size = UDim2.new(0,200,0,50)
                    bill.AlwaysOnTop = true

                    local txt = Instance.new("TextLabel", bill)
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.BackgroundTransparency = 1
                    txt.Text = v.Name
                    txt.TextScaled = true

                    table.insert(espObjects, bill)
                end
            end
        end
    end
end

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        espBtn.Text = "ESP ON 👁"
        createESP()
    else
        espBtn.Text = "ESP NAME 👁"
        clearESP()
    end
end)

--------------------------------------------------
-- HOP
local TeleportService = game:GetService("TeleportService")
hopBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId)
end)

--------------------------------------------------
-- KEY K
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.K then
        gui.Enabled = not gui.Enabled
    end
end)

log.Text = "READY ✅"
