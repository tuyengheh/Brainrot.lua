-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotHelper"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.5, -125, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
mainFrame.AnchorPoint = Vector2.new(0.5, 0)

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Brainrot Helper"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = mainFrame

-- Function to create buttons
local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.Text = text

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    btn.Parent = mainFrame
    return btn
end

-- Buttons
local hopBtn = createButton("Server Hop", 40)
local checkBtn = createButton("Check Brainrots", 90)

-- Server Hop (simple, chắc chắn chạy mobile)
hopBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

-- Check Brainrots
checkBtn.MouseButton1Click:Connect(function()
    local found = {}

    -- Tìm đúng folder brainrots trong game
    local brainrotFolder = workspace:FindFirstChild("BrainrotsFolder") -- Thay đúng tên
    if brainrotFolder then
        for _, obj in pairs(brainrotFolder:GetChildren()) do
            table.insert(found, obj.Name)
        end
        print("Brainrots trong server: "..table.concat(found, ", "))
    else
        print("Không tìm thấy Brainrot folder!")
    end
end)
