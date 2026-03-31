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
frame.Position = UDim2.new(0.5,-130,0.4,-130)
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
local aimBtn  = btn("AIM OFF 🎯",210)
local espBtn  = btn("ESP OFF 👁",255)

--------------------------------------------------
-- CHECK BASE
local function isMyBase(obj)
    local owner = obj:FindFirstChild("Owner")
    return owner and owner.Value == player
end

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
        hrp.CFrame = hrp.CFrame:Lerp(spawnCFrame,0.15)
        task.wait(0.03)
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

        if dist < 3 or tick()-start > 4 then break end

        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(target),0.08)
        task.wait(0.03)
    end

    noclip = false
end

--------------------------------------------------
-- AUTO PICKUP
local function autoPickup(part)
    for i = 1,6 do
        if not part or not part.Parent then break end

        for _,v in pairs(part:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
                fireproximityprompt(v)
            end
        end
        task.wait(0.2)
    end
end

--------------------------------------------------
-- SCAN
local function scanPet()
    local keyword = string.lower(input.Text)

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and not isMyBase(v) then
            if keyword == "" or string.find(string.lower(v.Name), keyword) then
                local part = v:FindFirstChildWhichIsA("BasePart")
                if part then
                    return v, part
                end
            end
        end
    end
end

--------------------------------------------------
-- 🎯 AIM (GIỮ CHUỘT MỚI HOẠT ĐỘNG)
local aimEnabled = false
local holdingMouse = false
local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input,gp)
    if not gp and input.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingMouse = true
    end
end)

UIS.InputEnded:Connect(function(input,gp)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingMouse = false
    end
end)

local function getClosestPlayer()
    local closest,dist = nil,math.huge
    local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

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

task.spawn(function()
    while true do
        if aimEnabled and holdingMouse then
            local target = getClosestPlayer()
            if target and target.Character then
                local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    camera.CFrame = camera.CFrame:Lerp(
                        CFrame.new(camera.CFrame.Position, hrp.Position),
                        0.25
                    )
                end
            end
        end
        task.wait(0.02)
    end
end)

--------------------------------------------------
-- 👁 ESP DÂY (FIX LAG)
local espEnabled = false
local beams = {}

local function clearBeams()
    for _,b in pairs(beams) do
        if b then b:Destroy() end
    end
    beams = {}
end

task.spawn(function()
    while true do
        if espEnabled and player.Character then
            clearBeams()

            for _,plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local att0 = Instance.new("Attachment", player.Character.HumanoidRootPart)
                    local att1 = Instance.new("Attachment", plr.Character.HumanoidRootPart)

                    local beam = Instance.new("Beam")
                    beam.Attachment0 = att0
                    beam.Attachment1 = att1
                    beam.Width0 = 0.1
                    beam.Width1 = 0.1
                    beam.Color = ColorSequence.new(Color3.new(1,0,0))
                    beam.Parent = game.CoreGui

                    table.insert(beams, beam)
                end
            end
        end

        task.wait(1)
    end
end)

--------------------------------------------------
-- BUTTONS
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

flyBtn.MouseButton1Click:Connect(flyToSpawn)

aimBtn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimBtn.Text = aimEnabled and "AIM ON 🎯" or "AIM OFF 🎯"
end)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ESP ON 👁" or "ESP OFF 👁"
    if not espEnabled then clearBeams() end
end)

--------------------------------------------------
-- KEY K
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.K then
        gui.Enabled = not gui.Enabled
    end
end)

log.Text = "READY ✅"
