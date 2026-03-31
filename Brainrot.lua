--// PLAYER
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

--// GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "AUTO_FARM"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,340)
frame.Position = UDim2.new(0.5,-130,0.4,-130)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,550)
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
local hopBtn  = btn("HOP NHANH ⚡",300)

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
-- FLY SPAWN
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
        if not part then break end

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
-- AIM
local aimEnabled = false
local holdingMouse = false
local UIS = game:GetService("UserInputService")

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
-- 👁 ESP DÂY (MÀU THEO KHOẢNG CÁCH)
local espEnabled = false
local beams = {}

local function clearBeams()
    for _,v in pairs(beams) do
        if v.beam then v.beam:Destroy() end
        if v.att0 then v.att0:Destroy() end
        if v.att1 then v.att1:Destroy() end
    end
    beams = {}
end

local function getColor(distance)
    local max = 200
    local ratio = math.clamp(distance/max,0,1)

    return Color3.new(ratio, 1-ratio, 0)
end

local function createBeam(plr)
    if not player.Character then return end
    if plr == player then return end
    if not plr.Character then return end

    local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
    local enemyHRP = plr.Character:FindFirstChild("HumanoidRootPart")

    if not myHRP or not enemyHRP then return end

    local dist = (myHRP.Position - enemyHRP.Position).Magnitude

    local att0 = Instance.new("Attachment", myHRP)
    local att1 = Instance.new("Attachment", enemyHRP)

    local beam = Instance.new("Beam")
    beam.Attachment0 = att0
    beam.Attachment1 = att1
    beam.Width0 = 0.12
    beam.Width1 = 0.12
    beam.Color = ColorSequence.new(getColor(dist))
    beam.FaceCamera = true
    beam.Parent = game.CoreGui

    table.insert(beams, {beam=beam,att0=att0,att1=att1})
end

task.spawn(function()
    while true do
        if espEnabled then
            clearBeams()
            for _,plr in pairs(game.Players:GetPlayers()) do
                createBeam(plr)
            end
        end
        task.wait(1)
    end
end)

--------------------------------------------------
-- HOP SERVER
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local function hopServer()
    local placeId = game.PlaceId

    local s,res = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100")
    end)

    if s then
        local data = HttpService:JSONDecode(res)

        for _,v in pairs(data.data) do
            if v.playing < v.maxPlayers then
                TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
                return
            end
        end
    end

    TeleportService:Teleport(placeId)
end

--------------------------------------------------
-- BUTTONS
scanBtn.MouseButton1Click:Connect(function()
    local pet, part = scanPet()
    if pet then
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

hopBtn.MouseButton1Click:Connect(function()
    log.Text = "⚡ ĐANG HOP..."
    hopServer()
end)

--------------------------------------------------
-- KEY K
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.K then
        gui.Enabled = not gui.Enabled
    end
end)

log.Text = "READY ✅"
