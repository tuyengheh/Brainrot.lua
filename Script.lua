# Brainrot.lua 
--// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--// AUTO EXECUTE SAU TELEPORT (DELTA)
if queue_on_teleport then
    queue_on_teleport(game:HttpGet("https://pastebin.com/raw/REPLACE_LINK"))
end

--// GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "BrainrotPro"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 220)
frame.Position = UDim2.new(0.5, -140, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Brainrot PRO"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- DRAG MOBILE
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

-- BUTTON CREATOR
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

    -- hiệu ứng click
    b.MouseButton1Down:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(90,90,90)
    end)
    b.MouseButton1Up:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(70,70,70)
    end)

    return b
end

-- BUTTONS
local hopNew = btn("Hop NEW", 40)
local hopOld = btn("Hop OLD", 80)
local scanBtn = btn("Scan Brainrot", 120)
local autoBtn = btn("Auto Hop: OFF", 160)

local auto = false

--------------------------------------------------
-- 🔵 HOP NEW (ít người)
hopNew.MouseButton1Click:Connect(function()
    local placeId = game.PlaceId

    local data = HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100")
    )

    for _,v in pairs(data.data) do
        if v.playing <= 3 then
            print("JOIN SERVER:", v.playing.."/"..v.maxPlayers)
            TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
            break
        end
    end
end)

--------------------------------------------------
-- 🟣 HOP OLD (đông người)
hopOld.MouseButton1Click:Connect(function()
    local placeId = game.PlaceId

    local data = HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Desc&limit=100")
    )

    for _,v in pairs(data.data) do
        if v.playing >= (v.maxPlayers * 0.7) then
            print("JOIN SERVER:", v.playing.."/"..v.maxPlayers)
            TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
            break
        end
    end
end)

--------------------------------------------------
-- 🧠 SCAN GẦN ĐÚNG
scanBtn.MouseButton1Click:Connect(function()
    print("=== SCAN START ===")
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            if string.find(string.lower(obj.Name), "brain") 
            or string.find(string.lower(obj.Name), "pet")
            or string.find(string.lower(obj.Name), "egg") then
                print("Found:", obj.Name)
            end
        end
    end
end)

--------------------------------------------------
-- 🔁 AUTO HOP
autoBtn.MouseButton1Click:Connect(function()
    auto = not auto
    autoBtn.Text = "Auto Hop: "..(auto and "ON" or "OFF")

    while auto do
        task.wait(5)
        TeleportService:Teleport(game.PlaceId, player)
    end
end)
