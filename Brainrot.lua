--// PLAYER
local player = game.Players.LocalPlayer

--// GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "AUTO_FARM"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,260)
frame.Position = UDim2.new(0.5,-130,0.4,-130)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,420)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4

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
    local hrp = char:WaitForChild("HumanoidRootPart")
    spawnCFrame = hrp.CFrame
end

setSpawn()
player.CharacterAdded:Connect(function()
    task.wait(1)
    setSpawn()
end)

--------------------------------------------------
-- FLY SPAWN
local function flyToSpawn()
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not spawnCFrame then return end

    for i = 1,30 do
        hrp.CFrame = hrp.CFrame:Lerp(spawnCFrame, 0.15)
        task.wait(0.03)
    end

    hrp.CFrame = spawnCFrame
end

--------------------------------------------------
-- FLY TO PET (MƯỢT - KHÔNG GIẬT)
local function flyToPet(part)
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    noclip = true

    local start = tick()

    while part and part.Parent do
        local target = part.Position + Vector3.new(0,3,0)
        local dist = (hrp.Position - target).Magnitude

        if dist < 3 then break end
        if tick() - start > 4 then break end -- chống kẹt

        local speed = math.clamp(dist/40, 0.04, 0.1) -- bay vừa

        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(target), speed)

        task.wait(0.03)
    end

    noclip = false
end

--------------------------------------------------
-- AUTO NHẶT NHANH
local function autoPickup(part)
    for i = 1,6 do
        if not part or not part.Parent then break end

        for _,v in pairs(part:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
                v.RequiresLineOfSight = false
                fireproximityprompt(v)
            end
        end

        task.wait(0.2)
    end
end

--------------------------------------------------
-- SCAN PET
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
-- 🎯 AIM PLAYER GẦN NHẤT (MƯỢT)
local aimEnabled = false

local function getClosestPlayer()
    local closest = nil
    local shortest = math.huge

    local myChar = player.Character
    if not myChar then return end

    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (myHRP.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = plr
            end
        end
    end

    return closest
end

-- AIM LOOP
task.spawn(function()
    while true do
        if aimEnabled then
            local target = getClosestPlayer()

            if target and target.Character then
                local myChar = player.Character
                local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

                local enemyHRP = target.Character:FindFirstChild("HumanoidRootPart")

                if hrp and enemyHRP then
                    local look = CFrame.new(hrp.Position, enemyHRP.Position)
                    
                    -- xoay mượt (không giật)
                    hrp.CFrame = hrp.CFrame:Lerp(look, 0.15)
                end
            end
        end

        task.wait(0.03)
    end
end)

--------------------------------------------------
-- ⌨️ PHÍM Q BẬT/TẮT AIM
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.Q then
        aimEnabled = not aimEnabled

        if aimEnabled then
            log.Text = "🎯 AIM ON"
        else
            log.Text = "❌ AIM OFF"
        end
    end
end)
--------------------------------------------------
-- SCAN BUTTON (1 LẦN)
scanBtn.MouseButton1Click:Connect(function()
    log.Text = "🔍 SCANNING..."

    task.spawn(function()
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
