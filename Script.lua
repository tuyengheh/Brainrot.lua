# Brainrot.lua
--// PLAYER
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--------------------------------------------------
-- 🌈 GUI XỊN (STYLE FUI)
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BRAINROT_UI"
gui.ResetOnSpawn = false

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,320,0,360)
frame.Position = UDim2.new(0.5,-160,0.4,-180)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

-- CLOSE X
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,25,0,25)
close.Position = UDim2.new(1,-30,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(50,50,50)

close.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- TOGGLE ICON (BÊN PHẢI)
local toggleIcon = Instance.new("TextButton", gui)
toggleIcon.Size = UDim2.new(0,50,0,50)
toggleIcon.Position = UDim2.new(1,-60,0.5,-25)
toggleIcon.Text = "☯"
toggleIcon.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", toggleIcon)

toggleIcon.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- PANEL TRÁI (INFO PLAYER)
local info = Instance.new("Frame", gui)
info.Size = UDim2.new(0,120,0,360)
info.Position = UDim2.new(0.5,-290,0.4,-180)
info.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner",info)

local nameLabel = Instance.new("TextLabel", info)
nameLabel.Size = UDim2.new(1,0,0,40)
nameLabel.Text = player.Name
nameLabel.BackgroundTransparency = 1
nameLabel.TextScaled = true

-- AVATAR
local avatar = Instance.new("ImageLabel", info)
avatar.Size = UDim2.new(1,-20,0,120)
avatar.Position = UDim2.new(0,10,0,50)
avatar.BackgroundTransparency = 1
avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"

--------------------------------------------------
-- SCROLL MENU
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,0,1,0)
scroll.BackgroundTransparency = 1

--------------------------------------------------
-- 🌈 BUTTON ĐẸP
local function btn(txt,y)
    local b = Instance.new("TextButton",scroll)
    b.Size = UDim2.new(0.8,0,0,35)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(0,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true

    Instance.new("UICorner",b)

    local stroke = Instance.new("UIStroke", b)
    stroke.Thickness = 2

    task.spawn(function()
        while b.Parent do
            stroke.Color = Color3.fromHSV((tick()%5)/5,1,1)
            task.wait()
        end
    end)

    return b
end

local farmBtn = btn("AUTO FARM OFF 🤖",50)
local aimBtn  = btn("AIM OFF 🎯",100)
local espBtn  = btn("ESP PLAYER OFF 👁",150)
local hopBtn  = btn("HOP SERVER ⚡",200)

--------------------------------------------------
-- AUTO FARM (GIỮ NGUYÊN LOGIC)
local farming = false

farmBtn.MouseButton1Click:Connect(function()
    farming = not farming
    farmBtn.Text = farming and "AUTO FARM ON 🤖" or "AUTO FARM OFF 🤖"
end)

--------------------------------------------------
-- 🔥 AIM LOCK (GIỮ)
local aimEnabled = false
local holdingMouse = false

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingMouse = true
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingMouse = false
    end
end)

local function getClosestPlayer()
    local closest, dist = nil, math.huge

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos = plr.Character.HumanoidRootPart.Position
            local screenPos, onScreen = camera:WorldToViewportPoint(pos)

            if onScreen then
                local diff = (Vector2.new(screenPos.X,screenPos.Y) - UIS:GetMouseLocation()).Magnitude
                if diff < dist then
                    dist = diff
                    closest = plr.Character.HumanoidRootPart
                end
            end
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    if aimEnabled and holdingMouse then
        local target = getClosestPlayer()
        if target then
            camera.CFrame = camera.CFrame:Lerp(
                CFrame.new(camera.CFrame.Position, target.Position),
                0.25
            )
        end
    end
end)

aimBtn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    aimBtn.Text = aimEnabled and "AIM ON 🎯" or "AIM OFF 🎯"
end)

--------------------------------------------------
-- 🔥 ESP PLAYER XỊN (DÂY TRẮNG)
local espEnabled = false
local lines = {}

local function clearESP()
    for _,l in pairs(lines) do
        if l then l:Remove() end
    end
    lines = {}
end

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end

    clearESP()

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)

            if vis then
                local line = Drawing.new("Line")
                line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Color = Color3.new(1,1,1)
                line.Thickness = 1.5
                line.Visible = true

                table.insert(lines, line)
            end
        end
    end
end)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ESP PLAYER ON 👁" or "ESP PLAYER OFF 👁"
    if not espEnabled then clearESP() end
end)

--------------------------------------------------
-- HOP SERVER
local TeleportService = game:GetService("TeleportService")
hopBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId)
end)

--------------------------------------------------
-- KEY K
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.K then
        frame.Visible = not frame.Visible
        info.Visible = frame.Visible
    end
end)
