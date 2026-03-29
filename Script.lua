# Brainrot.lua 
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

--// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local currentServerId = game.JobId

--------------------------------------------------
-- 🎯 LIST PET (CHUẨN THEO BẠN)
local rareList = {
    "Ketchuru","Lavadorito",
    "Tang","Tictac","Spaghetti","Eviledon",
    "Spooky","Strawberry","Meowl","Skibidi",
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
-- ⚡ TP BASE
local function tpBase()
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local base = findBase()
    if not base then return end

    hrp.CFrame = hrp.CFrame + Vector3.new(0,5,0)
    task.wait(0.1)
    hrp.CFrame = CFrame.new(base + Vector3.new(0,3,0))
end

--------------------------------------------------
-- 🔁 HOP SERVER KHÔNG TRÙNG
local visited = {}

local function hop()
    local placeId = game.PlaceId

    local s,res = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100")
    end)

    if s then
        local data = HttpService:JSONDecode(res)

        for _,v in pairs(data.data) do
            if v.id ~= currentServerId
            and v.playing < v.maxPlayers
            and not visited[v.id] then

                visited[v.id] = true
                TeleportService:TeleportToPlaceInstance(placeId,v.id,player)
                return
            end
        end
    end

    TeleportService:Teleport(placeId)
end

--------------------------------------------------
-- 🤖 AUTO CẦM PET → TP BASE
task.spawn(function()
    while true do
        task.wait(0.5)

        local char = player.Character
        if not char then continue end

        for _,tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and isRare(tool.Name) then
                tpBase()
                task.wait(2)
            end
        end
    end
end)

--------------------------------------------------
-- 🎨 GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 160)
frame.Position = UDim2.new(0.5,-125,0.4,-80)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
Instance.new("UICorner",frame)

-- DRAG MOBILE
local dragging, dragStart, startPos

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

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "AUTO FARM"
title.BackgroundTransparency = 1
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

-- BUTTON
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(0.8,0,0,35)
tpBtn.Position = UDim2.new(0.1,0,0,50)
tpBtn.Text = "TP BASE ⚡"
tpBtn.TextScaled = true
tpBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
tpBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",tpBtn)

tpBtn.MouseButton1Click:Connect(tpBase)

local hopBtn = Instance.new("TextButton", frame)
hopBtn.Size = UDim2.new(0.8,0,0,35)
hopBtn.Position = UDim2.new(0.1,0,0,100)
hopBtn.Text = "HOP SERVER 🔁"
hopBtn.TextScaled = true
hopBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
hopBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",hopBtn)

hopBtn.MouseButton1Click:Connect(hop)
