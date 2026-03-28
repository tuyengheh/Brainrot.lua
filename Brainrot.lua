--// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "BrainrotFix"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 260)
frame.Position = UDim2.new(0.5, -140, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Brainrot PRO FIX"
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
local function btn(text,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.8,0,0,35)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(70,70,70)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

local hopNew = btn("Hop NEW", 40)
local hopOld = btn("Hop OLD", 80)
local espBrain = btn("ESP Brainrot", 120)
local espPlayer = btn("ESP Player", 160)

--------------------------------------------------
-- 🔵 HOP NEW
hopNew.MouseButton1Click:Connect(function()
    local placeId = game.PlaceId
    local data = HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100")
    )

    for _,v in pairs(data.data) do
        if v.playing <= 3 then
            print("JOIN:", v.playing.."/"..v.maxPlayers)
            TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
            break
        end
    end
end)

--------------------------------------------------
-- 🟣 HOP OLD
hopOld.MouseButton1Click:Connect(function()
    local placeId = game.PlaceId
    local data = HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Desc&limit=100")
    )

    for _,v in pairs(data.data) do
        if v.playing >= (v.maxPlayers * 0.7) then
            print("JOIN:", v.playing.."/"..v.maxPlayers)
            TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
            break
        end
    end
end)

--------------------------------------------------
-- 🧠 ESP BRAINROT (gần đúng)
espBrain.MouseButton1Click:Connect(function()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            if string.find(string.lower(obj.Name),"brain") then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = obj:GetExtentsSize()
                box.Adornee = obj
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Color3 = Color3.new(1,0,0)
                box.Parent = obj
            end
        end
    end
end)

--------------------------------------------------
-- 👤 ESP PLAYER
espPlayer.MouseButton1Click:Connect(function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local char = plr.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = Vector3.new(4,6,2)
                box.Adornee = hrp
                box.AlwaysOnTop = true
                box.Color3 = Color3.new(0,1,0)
                box.Parent = hrp
            end
        end
    end
end)
