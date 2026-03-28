-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- Giữ trạng thái sau khi hop
_G.AutoHop = _G.AutoHop or false

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 170)
frame.Position = UDim2.new(0.5, -130, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 15)

-- Drag (kéo GUI)
local dragging, dragInput, dragStart, startPos

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

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
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

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Brainrot Auto Hop"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- Button creator
local function createBtn(text, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.8,0,0,40)
    btn.Position = UDim2.new(0.1,0,0,y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true

    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 12)

    return btn
end

-- Buttons
local hopBtn = createBtn("Hop 1 Lần", 40)
local autoBtn = createBtn("Auto Hop: OFF", 90)

--------------------------------------------------
-- 🔵 Hop 1 lần
hopBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

--------------------------------------------------
-- 🔁 Auto Hop toggle
autoBtn.MouseButton1Click:Connect(function()
    _G.AutoHop = not _G.AutoHop
    autoBtn.Text = "Auto Hop: " .. (_G.AutoHop and "ON" or "OFF")

    if _G.AutoHop then
        task.wait(2)
        TeleportService:Teleport(game.PlaceId, player)
    end
end)

--------------------------------------------------
-- 🔥 Tự động chạy lại sau khi vào server mới
task.spawn(function()
    task.wait(5) -- đợi load game

    if _G.AutoHop then
        TeleportService:Teleport(game.PlaceId, player)
    end
end)
