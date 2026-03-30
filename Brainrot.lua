--// PLAYER
local player = game.Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

--// GUI
local gui = Instance.new("ScreenGui", pg)
gui.Name = "AUTO_FARM"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,260)
frame.Position = UDim2.new(0.5,-130,0.4,-130)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

-- 📱 SCROLL MOBILE
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,0,1,0)
scroll.CanvasSize = UDim2.new(0,0,0,400)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4

-- UI
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

--------------------------------------------------
-- 🎯 PET LIST
local targetList = {
"Void","Toxic","zioles","egg","Rainbow","cele","Strawberry","Meowl"
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
-- 🧠 FIX TRÁNH PET CŨ
local lastPet = nil

--------------------------------------------------
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

local flyBtn  = btn("FLY SPAWN 🚀",80)
local scanBtn = btn("SCAN + ESP 🔍",125)
local hopBtn  = btn("SERVER MỚI 🆕",170)
local espBtn  = btn("PLAYER ESP 👤",215)
local resetBtn = btn("RESET PET ♻️",260)

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
-- 🚀 FLY SPAWN
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
-- 👁 ESP PET
local currentESP = nil

local function createESP(obj)
    if currentESP then
        currentESP:Destroy()
    end

    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(255,0,0)
    hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.4
    hl.Adornee = obj
    hl.Parent = game.CoreGui

    currentESP = hl
end

--------------------------------------------------
-- 👤 ESP PLAYER (FIX TÀNG HÌNH)
local espEnabled = false
local playerESP = {}

local function applyESP(plr, char)
    if not espEnabled then return end
    if plr == player then return end
    if not char then return end

    if playerESP[plr] then
        playerESP[plr]:Destroy()
    end

    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(0,170,255)
    hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.3
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- xuyên tường

    hl.Adornee = char
    hl.Parent = game.CoreGui

    playerESP[plr] = hl
end

local function clearESP()
    for _,v in pairs(playerESP) do
        v:Destroy()
    end
    playerESP = {}
end

-- refresh ESP
task.spawn(function()
    while true do
        if espEnabled then
            for _,plr in pairs(game.Players:GetPlayers()) do
                if plr.Character then
                    applyESP(plr, plr.Character)
                end
            end
        end
        task.wait(2)
    end
end)

--------------------------------------------------
-- 🧲 FLY PET
local function flyToPet(part)
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local target = part.Position + Vector3.new(0,3,0)

    while (hrp.Position - target).Magnitude > 2 do
        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(target), 0.08)
        task.wait(0.02)
    end

    hrp.CFrame = CFrame.new(target)
end

--------------------------------------------------
-- ⚡ AUTO NHẶT
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
-- 🔍 SCAN (FIX)
local function scanPet()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and isTarget(v.Name) and not isMyBase(v) then
            if v ~= lastPet then
                local part = v:FindFirstChildWhichIsA("BasePart")
                if part then
                    return v, part
                end
            end
        end
    end
end

--------------------------------------------------
-- 🔥 SCAN
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

            lastPet = pet -- ❗ nhớ pet

            log.Text = "✅ DONE"
        else
            log.Text = "❌ KHÔNG CÓ"
        end
    end)
end)

--------------------------------------------------
-- RESET PET
resetBtn.MouseButton1Click:Connect(function()
    lastPet = nil
    log.Text = "♻️ RESET PET"
end)

--------------------------------------------------
-- ESP PLAYER BUTTON
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled

    if espEnabled then
        log.Text = "👤 ESP PLAYER ON"
    else
        log.Text = "❌ ESP OFF"
        clearESP()
    end
end)

--------------------------------------------------
-- 🔥 HOP SERVER
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

function hopNew()
    local placeId = game.PlaceId

    local s,res = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100")
    end)

    if s then
        local data = HttpService:JSONDecode(res)

        for _,v in pairs(data.data) do
            if v.playing <= 2 then
                TeleportService:TeleportToPlaceInstance(placeId,v.id,player)
                return
            end
        end
    end

    TeleportService:Teleport(placeId)
end

--------------------------------------------------
-- ⌨️ KEY K
local UIS = game:GetService("UserInputService")
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
