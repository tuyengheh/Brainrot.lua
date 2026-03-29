--------------------------------------------------
-- 🎨 GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 300) -- 🔥 đủ chỗ cho 3 nút
frame.Position = UDim2.new(0.5, -140, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

--------------------------------------------------
-- 🖐️ DRAG GUI (MƯỢT)
local UIS = game:GetService("UserInputService")

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

--------------------------------------------------
-- 🌈 TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "RAINBOW FARM 🌈"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

--------------------------------------------------
-- 📄 LOG
local log = Instance.new("TextLabel", frame)
log.Size = UDim2.new(1,0,0,80)
log.Position = UDim2.new(0,0,0,30)
log.BackgroundTransparency = 1
log.Text = "Ready..."
log.TextColor3 = Color3.new(1,1,1)
log.TextScaled = true

--------------------------------------------------
-- 🔘 BUTTON FUNCTION
local function createBtn(text,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.8,0,0,40)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(0,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

--------------------------------------------------
-- 🔥 3 NÚT CHUẨN
local startBtn = createBtn("START AUTO 🔥", 120)
local hopBtn   = createBtn("HOP SERVER NEW 🔁", 170)
local baseBtn  = createBtn("🏠 BAY VỀ BASE", 220)
