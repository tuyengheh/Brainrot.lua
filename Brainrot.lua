--// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local currentServerId = game.JobId

--------------------------------------------------
-- 🎯 LIST PET HIẾM
local rareList = {
    "Garama and Madundung","Ketchuru and Musturu","La Secret Combinasion",
    "Lavadorito Spinito","Tang Tang Keletang","Tictac Sahur",
    "Spaghetti Tualetti","Eviledon","Los Spaghettis",
    "Spooky and Pumpky","La Grande Combinasion","Strawberry Elephant",
    "Meowl","Skibidi Toilet","Cigno Fulgoro",
    "Lava","Rainbow","Galaxy"
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
-- ❌ KHÔNG SCAN BASE
local function isMyBase(obj)
    local owner = obj:FindFirstChild("Owner")
    return owner and owner.Value == player
end

--------------------------------------------------
-- 🎨 GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 240)
frame.Position = UDim2.new(0.5, -140, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

-- 🖐️ DRAG
local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        dragInput = input
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input == dragInput then
        dragging = false
    end
end)

-- ⌨️ TOGGLE GUI (phím K)
UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.K then
        gui.Enabled = not gui.Enabled
    end
end)

-- 🌈 Rainbow
RunService.RenderStepped:Connect(function()
    frame.BackgroundColor3 = Color3.fromHSV((tick()%5)/5,1,1)
end)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "RAINBOW FARM 🌈"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- LOG
local log = Instance.new("TextLabel", frame)
log.Size = UDim2.new(1,0,0,80)
log.Position = UDim2.new(0,0,0,30)
log.BackgroundTransparency = 1
log.Text = "Ready..."
log.TextColor3 = Color3.new(1,1,1)
log.TextScaled = true

-- BUTTON
local function createBtn(text,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.8,0,0,35)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(0,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

local startBtn = createBtn("START AUTO 🔥", 120)
local hopBtn   = createBtn("HOP SERVER NEW 🔁", 170)

--------------------------------------------------
-- 🧠 TÌM BASE
local function findMyBase()
    for _,obj in pairs(workspace:GetDescendants()) do
        local owner = obj:FindFirstChild("Owner")
        if owner and owner.Value == player then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then return part.Position end
        end
    end
end

-- 🚀 BAY MƯỢT
local function flyTo(pos)
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for i=1,20 do
        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(pos + Vector3.new(0,5,0)),0.2)
        task.wait(0.05)
    end
end

--------------------------------------------------
-- 🧲 NHẶT + VỀ BASE
local function moveToPet(obj)
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local part = obj:FindFirstChildWhichIsA("BasePart")

    if hrp and part then
        hrp.CFrame = part.CFrame + Vector3.new(0,3,0)

        -- đợi nhặt
        task.wait(1)

        -- bay về base
        local base = findMyBase()
        if base then
            flyTo(base)
        end
    end
end

--------------------------------------------------
-- 🔍 SCAN
local function scan()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and not isMyBase(v) then
            if isRare(v.Name) then
                return true, v
            end
        end
    end
    return false, nil
end

--------------------------------------------------
-- 🔁 HOP
local function hopServer()
    local placeId = game.PlaceId

    local success, result = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=50")
    end)

    if success then
        local data = HttpService:JSONDecode(result)

        for _,v in pairs(data.data) do
            if v.id ~= currentServerId and v.playing < v.maxPlayers then
                TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
                return
            end
        end
    end

    TeleportService:Teleport(placeId, player)
end

hopBtn.MouseButton1Click:Connect(hopServer)

--------------------------------------------------
-- 🔁 AUTO
local running = false

startBtn.MouseButton1Click:Connect(function()
    running = not running

    if running then
        startBtn.Text = "RUNNING..."

        task.spawn(function()
            task.wait(1.5)

            local found, obj = scan()

            if found then
                log.Text = "🔥 "..obj.Name
                moveToPet(obj)
                running = false
                startBtn.Text = "FOUND!"
            else
                log.Text = "❌ Không có → hop"
                task.wait(0.5)
                hopServer()
            end
        end)
    else
        startBtn.Text = "START AUTO 🔥"
    end
end)
