# Brainrot.lua 
-                    -- 🧠 CHỜ GAME LOAD KỸ
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")

--// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local currentServerId = game.JobId

--------------------------------------------------
-- 🧹 XOÁ GUI CŨ (TRÁNH BUG)
pcall(function()
    if player.PlayerGui:FindFirstChild("RAINBOW_GUI") then
        player.PlayerGui.RAINBOW_GUI:Destroy()
    end
end)

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
-- 🎨 GUI (FIX CHẮC CHẮN)
local gui = Instance.new("ScreenGui")
gui.Name = "RAINBOW_GUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 260, 0, 240)
frame.Position = UDim2.new(0.5,-130,0.4,-120)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
Instance.new("UICorner",frame)

-- TEST TEXT (đảm bảo hiện)
local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "GUI OK ✅"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

--------------------------------------------------
-- DRAG (FIX)
local dragging = false
local dragStart, startPos

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
-- 🌈 RAINBOW
RunService.RenderStepped:Connect(function()
    frame.BackgroundColor3 = Color3.fromHSV((tick()%5)/5,1,1)
end)

--------------------------------------------------
-- BUTTON TEST
local btn = Instance.new("TextButton",frame)
btn.Size = UDim2.new(0.8,0,0,40)
btn.Position = UDim2.new(0.1,0,0,60)
btn.Text = "TP BASE ⚡"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",btn)

--------------------------------------------------
-- FIND BASE
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
-- TP BASE
btn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local base = findBase()
    if not base then return end

    hrp.CFrame = hrp.CFrame + Vector3.new(0,5,0)
    task.wait(0.1)
    hrp.CFrame = CFrame.new(base + Vector3.new(0,3,0))
end)

--------------------------------------------------
print("✅ GUI LOADED SUCCESS")
