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
local scanBtn = btn("AUTO FARM 🔥",165)
local hopBtn  = btn("SERVER MỚI 🆕",210)
local espBtn  = btn("PLAYER ESP 👤",255)

--------------------------------------------------
-- BASE CHECK
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
        hrp.CFrame = hrp.CFrame:Lerp(spawnCFrame, 0.2)
        task.wait(0.03)
    end
    hrp.CFrame = spawnCFrame
end

--------------------------------------------------
-- ESP PET
local currentESP
local function createESP(obj)
    if currentESP then currentESP:Destroy() end
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(255,0,0)
    hl.FillTransparency = 0.4
    hl.Adornee = obj
    hl.Parent = game.CoreGui
    currentESP = hl
end

--------------------------------------------------
-- FLY TO PET (FIX KẸT)
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
        if tick() - start > 5 then break end -- chống kẹt

        local speed = math.clamp(dist/30, 0.05, 0.12)
        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(target), speed)

        task.wait(0.03)
    end

    noclip = false
end

--------------------------------------------------
-- AUTO PICKUP
local function autoPickup(part)
    for i = 1,5 do
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
-- AUTO FARM
local farming = false

scanBtn.MouseButton1Click:Connect(function()
    farming = not farming

    if farming then
        log.Text = "🔥 AUTO FARM ON"
    else
        log.Text = "⛔ AUTO FARM OFF"
        return
    end

    task.spawn(function()
        while farming do
            local pet, part = scanPet()

            if pet and part then
                log.Text = "🔥 "..pet.Name

                createESP(pet)
                flyToPet(part)
                autoPickup(part)

                -- chống kẹt
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame += Vector3.new(0,5,0)
                end

                task.wait(0.3)
            else
                log.Text = "❌ KHÔNG CÓ"
                task.wait(1)
            end
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
hopBtn.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

log.Text = "READY ✅"
