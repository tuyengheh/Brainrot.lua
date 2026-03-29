# Brainrot.lua 
-- GUI LOAD FIRST
local player = game.Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Parent = pg

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,230)
frame.Position = UDim2.new(0.5,-130,0.4,-115)
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
    "Cigno","Lava","Rainbow","Galaxy",
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

local tpBtn   = btn("TP BASE ⚡",90)
local scanBtn = btn("SCAN PET 🔍",135)
local hopBtn  = btn("HOP SERVER 🔁",180)

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
-- 🏠 FIND BASE
local function findBase()
    for _,v in pairs(workspace:GetDescendants()) do
        local owner = v:FindFirstChild("Owner")
        if owner and owner.Value == player then
            local p = v:FindFirstChildWhichIsA("BasePart")
            if p then return p.Position end
        end
    end
end

--------------------------------------------------
-- ⚡ TP BASE (FIX MẠNH)
local function tpBase()
    pcall(function()
        log.Text = "TP BASE..."

        local char = player.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local base = findBase()
        if not base then
            log.Text = "NO BASE"
            return
        end

        -- tp trực tiếp (bỏ anti lỗi)
        hrp.CFrame = CFrame.new(base + Vector3.new(0,3,0))

        log.Text = "DONE ✅"
    end)
end

--------------------------------------------------
-- 🧲 BAY TỚI PET
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
-- 🔍 SCAN PET
local function scanPet()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            if isRare(v.Name) then
                return v
            end
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
-- 🔁 HOP
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local currentServerId = game.JobId
local visited = {}

local function hop()
    pcall(function()
        log.Text = "HOP..."

        local placeId = game.PlaceId
        local res = game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=50")
        local data = HttpService:JSONDecode(res)

        for _,v in pairs(data.data) do
            if v.id ~= currentServerId and not visited[v.id] then
                visited[v.id] = true
                TeleportService:TeleportToPlaceInstance(placeId,v.id,player)
                return
            end
        end

        TeleportService:Teleport(placeId)
    end)
end

--------------------------------------------------
-- CONNECT
tpBtn.MouseButton1Click:Connect(tpBase)
hopBtn.MouseButton1Click:Connect(hop)

log.Text = "READY ✅"
