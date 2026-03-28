--// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 180)
frame.Position = UDim2.new(0.5, -130, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Brainrot FIX"
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

local hopBtn = btn("Hop Server", 50)
local autoBtn = btn("Auto Hop OFF", 110)

local auto = false

-- HOP
hopBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

-- AUTO
autoBtn.MouseButton1Click:Connect(function()
    auto = not auto
    autoBtn.Text = auto and "Auto Hop ON" or "Auto Hop OFF"

    while auto do
        task.wait(5)
        TeleportService:Teleport(game.PlaceId, player)
    end
end)
