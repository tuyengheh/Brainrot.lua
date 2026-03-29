local player = game.Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Parent = pg

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,260)
frame.Position = UDim2.new(0.5,-130,0.4,-130)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
Instance.new("UICorner",frame)

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "AUTO FARM 🔥"
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
-- 🎯 LIST PET
local rareList = {
    "Ketchuru","Lavadorito","Tang","Tictac","Spaghetti",
    "Eviledon","Spooky","Strawberry","Meowl","Skibidi",
    "Cigno","admin","Rainbow","radioactive",
    "Tiger","Kitsune","Yeti","Fruits"
}

local function isRare(name)
    name = string.lower(name)
    for _,v in pairs(rareList) do
        if string.find(name, string.lower(v)) then
            return true
        end
    end
    return false
end

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
    return b
end

local flyBtn  = btn("FLY SPAWN 🚀",80)
local scanBtn = btn("SCAN PET 🔍",125)
local hopBtn  = btn("SERVER MỚI 🆕",170)

--------------------------------------------------
-- DRAG
local UIS = game:GetService("UserInputService")
local dragging, startPos, dragStart

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
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

--------------------------------------------------
-- 💾 LƯU SPAWN
local spawnCFrame = nil

player.CharacterAdded:Connect(function(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    spawnCFrame = hrp.CFrame
end)

--------------------------------------------------
-- 🚀 FLY SPAWN (MƯỢT)
local function flyToSpawn()
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not spawnCFrame then return end

    log.Text = "🚀 BAY VỀ SPAWN..."

    local spd = 5 -- tốc độ mặc định

    for i = 1, (20 / spd) do
        hrp.CFrame = hrp.CFrame:Lerp(spawnCFrame, 0.15 * spd)
        task.wait(0.03)
    end

    hrp.CFrame = spawnCFrame
    log.Text = "✅ DONE"
end

--------------------------------------------------
-- 🧲 FLY PET
local function flyToPet(obj)
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local part = obj:FindFirstChildWhichIsA("BasePart")

    if hrp and part then
        hrp.CFrame = part.CFrame + Vector3.new(0,3,0)
    end
end

--------------------------------------------------
-- 🔍 SCAN
local function scanPet()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and isRare(v.Name) then
            return v
        end
    end
end

scanBtn.MouseButton1Click:Connect(function()
    log.Text = "SCANNING..."

    task.spawn(function()
        task.wait(0.5)

        local pet = scanPet()

        if pet then
            log.Text = "🔥 "..pet.Name
            flyToPet(pet)
        else
            log.Text = "❌ KHÔNG CÓ"
        end
    end)
end)

--------------------------------------------------
-- 🔥 HOP SERVER
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local function hopNew()
    log.Text = "🔎 FIND NEW..."

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
