
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
local crazyBtn = btn("CRAZY MODE 💀",345) -- 👈 NÚT MỚI

--------------------------------------------------
-- 💀 CRAZY MODE (FAKE LAG + XOAY ĐIÊN)
local crazyEnabled = false

task.spawn(function()
    while true do
        if crazyEnabled and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- xoay điên
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(math.random(30,120)), 0)

                -- giật nhẹ (fake lag)
                hrp.CFrame = hrp.CFrame + Vector3.new(
                    math.random(-2,2)/5,
                    math.random(-1,1)/5,
                    math.random(-2,2)/5
                )
            end
        end
        task.wait(0.05)
    end
end)

crazyBtn.MouseButton1Click:Connect(function()
    crazyEnabled = not crazyEnabled

    if crazyEnabled then
        crazyBtn.Text = "CRAZY ON 💀"
        log.Text = "💀 FAKE LAG ON"
    else
        crazyBtn.Text = "CRAZY MODE 💀"
        log.Text = "❌ CRAZY OFF"
    end
end)

-----------------------------------------------
-- (GIỮ NGUYÊN TOÀN BỘ CODE CŨ CỦA BẠN BÊN DƯỚI)
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
-- AIM (GIỮ CHUỘT)
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
-- 🟩 ESP BOX (FIX FULL)
local espEnabled = false
local highlights = {}

local function clearESP()
    for _,v in pairs(highlights) do
        if v then v:Destroy() end
    end
    highlights = {}
end

local function getColor(dist)
    local max = 200
    local ratio = math.clamp(dist/max,0,1)
    return Color3.new(ratio, 1-ratio, 0)
end

task.spawn(function()
    while true do
        if espEnabled then
            clearESP()

            local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

            for _,plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character and myHRP then
                    local enemyHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                    if enemyHRP then
                        local dist = (myHRP.Position - enemyHRP.Position).Magnitude

                        local hl = Instance.new("Highlight")
                        hl.Adornee = plr.Character
                        hl.FillColor = getColor(dist)
                        hl.FillTransparency = 0.5
                        hl.OutlineColor = Color3.new(1,1,1)
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = game.CoreGui

                        table.insert(highlights, hl)
                    end
                end
            end
        end

        task.wait(0.5)
    end
end)

--------------------------------------------------
-- ⚡ HOP SERVER
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
flyBtn.MouseButton1Click:Connect(flyToSpawn)

aimBtn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimBtn.Text = aimEnabled and "AIM ON 🎯" or "AIM OFF 🎯"
end)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled

    if espEnabled then
        espBtn.Text = "ESP ON 👁"
        log.Text = "👁 ESP ON"
    else
        espBtn.Text = "ESP OFF 👁"
        log.Text = "❌ ESP OFF"
        clearESP()
    end
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
