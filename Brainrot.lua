--// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--------------------------------------------------
-- 🎨 GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 180)
frame.Position = UDim2.new(0.5, -130, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Server + Base PRO"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- DRAG
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
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

-- BUTTON
local function createBtn(text,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.8,0,0,40)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(70,70,70)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

local hopBtn = createBtn("Tìm Server Ngon", 40)
local baseBtn = createBtn("TP Base Của Mình", 95)

--------------------------------------------------
-- 🔍 HOP SERVER NGON
local function findGoodServer()
    local placeId = game.PlaceId

    local success, result = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100")
    end)

    if not success then
        TeleportService:Teleport(placeId, player)
        return
    end

    local data = HttpService:JSONDecode(result)

    for _,v in pairs(data.data) do
        if v.playing >= 4 and v.playing <= 8 then
            print("✅ Server:", v.playing.."/"..v.maxPlayers)
            TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
            return
        end
    end

    TeleportService:Teleport(placeId, player)
end

hopBtn.MouseButton1Click:Connect(findGoodServer)

--------------------------------------------------
-- 🧠 TÌM BASE CỦA BẠN
local function findMyBase()
    local myName = string.lower(player.Name)

    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Folder") then
            local name = string.lower(obj.Name)

            if name:find(myName) then
                local part = obj:FindFirstChildWhichIsA("BasePart")
                if part then return part.Position end
            end

            local owner = obj:FindFirstChild("Owner")
            if owner and owner.Value == player then
                local part = obj:FindFirstChildWhichIsA("BasePart")
                if part then return part.Position end
            end
        end
    end

    return nil
end

--------------------------------------------------
-- 🚀 TELEPORT BASE (STEP BYPASS - KHÔNG CHẾT)
local function teleportBase(pos)
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local startPos = hrp.Position
    local distance = (pos - startPos).Magnitude

    -- chia nhỏ quãng đường
    local steps = math.clamp(math.floor(distance / 25), 10, 50)

    for i = 1, steps do
        local nextPos = startPos:Lerp(pos, i / steps)
        hrp.CFrame = CFrame.new(nextPos + Vector3.new(0,2,0))
        task.wait(0.08)
    end

    hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
end

--------------------------------------------------
-- BUTTON TP BASE
baseBtn.MouseButton1Click:Connect(function()
    local pos = findMyBase()

    if pos then
        print("🚀 Đang về base...")
        teleportBase(pos)
        print("🏠 Đã về base an toàn")
    else
        warn("❌ Không tìm thấy base của bạn")
    end
end)
