# Brainrot.lua
--// PLAYER
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

--// GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "AUTO_FARM"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,300)
frame.Position = UDim2.new(0.5,-130,0.4,-150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,500)
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
input.PlaceholderText = "Nhập tên pet..."
input.BackgroundColor3 = Color3.fromRGB(20,20,20)
input.TextColor3 = Color3.new(1,1,1)
input.TextScaled = true
Instance.new("UICorner",input)

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

local flyBtn  = btn("FLY SPAWN 🚀",120)
local scanBtn = btn("SCAN + NHẶT 🔍",165)
local aimBtn  = btn("AIM 🎯 OFF",210)

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

--------------------------------------------------
-- FLY SPAWN
local function flyToSpawn()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not spawnCFrame then return end

    for i = 1,30 do
        hrp.CFrame = hrp.CFrame:Lerp(spawnCFrame, 0.15)
        task.wait(0.03)
    end
end

--------------------------------------------------
-- SCAN PET
local function isMyBase(obj)
    local owner = obj:FindFirstChild("Owner")
    return owner and owner.Value == player
end

local function scanPet()
    local keyword = string.lower(input.Text)
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and not isMyBase(v) then
            if keyword == "" or string.find(string.lower(v.Name), keyword) then
                local part = v:FindFirstChildWhichIsA("BasePart")
                if part then return v, part end
            end
        end
    end
end

--------------------------------------------------
-- FLY PET
local function flyToPet(part)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    noclip = true
    local start = tick()

    while part and part.Parent do
        local target = part.Position + Vector3.new(0,3,0)
        local dist = (hrp.Position - target).Magnitude

        if dist < 3 then break end
        if tick() - start > 4 then break end

        local speed = math.clamp(dist/40, 0.04, 0.1)
        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(target), speed)

        task.wait(0.03)
    end

    noclip = false
end

--------------------------------------------------
-- AUTO PICKUP
local function autoPickup(part)
    for i = 1,6 do
        if not part then break end
        for _,v in pairs(part:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                fireproximityprompt(v)
            end
        end
        task.wait(0.2)
    end
end

--------------------------------------------------
-- 🎯 AIM + ESP DÂY
local aimEnabled = false
local currentBeam

local function getClosestPlayer()
    local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    local closest,dist = nil,math.huge

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = (myHRP.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = plr
            end
        end
    end

    return closest
end

local function createBeam(targetHRP)
    if currentBeam then currentBeam:Destroy() end

    local att0 = Instance.new("Attachment", player.Character.HumanoidRootPart)
    local att1 = Instance.new("Attachment", targetHRP)

    local beam = Instance.new("Beam")
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    beam.Parent = att0

    currentBeam = beam
end

task.spawn(function()
    while true do
        if aimEnabled then
            local target = getClosestPlayer()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

            if target and target.Character then
                local enemyHRP = target.Character:FindFirstChild("HumanoidRootPart")

                if hrp and enemyHRP then
                    hrp.CFrame = hrp.CFrame:Lerp(
                        CFrame.new(hrp.Position, enemyHRP.Position),
                        0.15
                    )

                    createBeam(enemyHRP)
                end
            end
        end
        task.wait(0.03)
    end
end)

--------------------------------------------------
-- AIM TOGGLE
local function toggleAim()
    aimEnabled = not aimEnabled

    if aimEnabled then
        log.Text = "🎯 AIM ON"
        aimBtn.Text = "AIM 🎯 ON"
    else
        log.Text = "❌ AIM OFF"
        aimBtn.Text = "AIM 🎯 OFF"
        if currentBeam then currentBeam:Destroy() end
    end
end

aimBtn.MouseButton1Click:Connect(toggleAim)

game:GetService("UserInputService").InputBegan:Connect(function(input,gp)
    if not gp and input.KeyCode == Enum.KeyCode.U then
        toggleAim()
    end
end)

--------------------------------------------------
-- SCAN BUTTON
scanBtn.MouseButton1Click:Connect(function()
    local pet, part = scanPet()
    if pet and part then
        log.Text = "🔥 "..pet.Name
        flyToPet(part)
        autoPickup(part)
        log.Text = "✅ DONE"
    else
        log.Text = "❌ KHÔNG CÓ"
    end
end)

--------------------------------------------------
-- KEY K
game:GetService("UserInputService").InputBegan:Connect(function(input,gp)
    if not gp and input.KeyCode == Enum.KeyCode.K then
        gui.Enabled = not gui.Enabled
    end
end)

--------------------------------------------------
-- CONNECT
flyBtn.MouseButton1Click:Connect(flyToSpawn)

log.Text = "READY ✅"
