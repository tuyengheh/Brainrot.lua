-- LOAD
repeat task.wait() until game:IsLoaded()

local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

--------------------------------------------------
-- INTRO
local intro = Instance.new("ScreenGui", game.CoreGui)
intro.IgnoreGuiInset = true

local bg = Instance.new("Frame", intro)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(10,10,15)

local title = Instance.new("TextLabel", bg)
title.Size = UDim2.new(1,0,0.2,0)
title.Position = UDim2.new(0,0,0.35,0)
title.Text = "✨ TIENHUB ✨"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextTransparency = 1

TweenService:Create(title,TweenInfo.new(1),{TextTransparency=0}):Play()

task.wait(2.5)

TweenService:Create(bg,TweenInfo.new(1),{BackgroundTransparency=1}):Play()
task.wait(1)
intro:Destroy()

--------------------------------------------------
-- SERVICES
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

--------------------------------------------------
-- SOUND
local function playSound(id)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://"..id
    s.Volume = 2
    s.Parent = SoundService
    s:Play()
    game.Debris:AddItem(s,2)
end

--------------------------------------------------
-- SPAWN
local spawnCF
local function setSpawn()
    local char = player.Character or player.CharacterAdded:Wait()
    spawnCF = char:WaitForChild("HumanoidRootPart").CFrame
end
setSpawn()

--------------------------------------------------
-- NOCLIP
local noclip = false
RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

--------------------------------------------------
-- SPEED
local speed = 16
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
    end
end)

--------------------------------------------------
-- GUI ROOT
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TIENHUB_UI"

--------------------------------------------------
-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,320,0,420)
main.Position = UDim2.new(0.5,-160,0.5,-210)
main.BackgroundColor3 = Color3.fromRGB(30,30,35)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

--------------------------------------------------
-- INFO PANEL (FIX CHUẨN)
local info = Instance.new("Frame", gui)
info.Size = UDim2.new(0,200,0,420)
info.Position = UDim2.new(0.5,-380,0.5,-210)
info.BackgroundColor3 = Color3.fromRGB(25,25,30)
Instance.new("UICorner", info)

local infoText = Instance.new("TextLabel", info)
infoText.Size = UDim2.new(1,0,1,0)
infoText.BackgroundTransparency = 1
infoText.TextColor3 = Color3.new(1,1,1)
infoText.TextScaled = true

--------------------------------------------------
-- ☯ TOGGLE BUTTON (FIX)
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,60,0,60)
toggleBtn.Position = UDim2.new(0.85,0,0.5,0)
toggleBtn.Text = "☯"
toggleBtn.TextScaled = true
toggleBtn.Visible = false
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
Instance.new("UICorner", toggleBtn)

--------------------------------------------------
-- CLOSE
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255,80,80)

--------------------------------------------------
-- TOGGLE GUI (FIX)
close.MouseButton1Click:Connect(function()
    playSound(6026984223)
    main.Visible = false
    info.Visible = false
    toggleBtn.Visible = true
end)

toggleBtn.MouseButton1Click:Connect(function()
    playSound(6026984224)
    main.Visible = true
    info.Visible = true
    toggleBtn.Visible = false
end)

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.K then
        local state = not main.Visible
        main.Visible = state
        info.Visible = state
        toggleBtn.Visible = not state
    end
end)

--------------------------------------------------
-- INFO UPDATE (FIX)
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        infoText.Text =
            "👤 "..player.Name..
            "\n❤️ HP: "..math.floor(char.Humanoid.Health)..
            "\n⚡ Speed: "..speed
    end
end)

--------------------------------------------------
-- BUTTON
local function toggle(txt,y)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.8,0,0,40)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = txt.." OFF"
    b.BackgroundColor3 = Color3.fromRGB(45,45,50)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)

    b:SetAttribute("state", false)

    b.MouseButton1Click:Connect(function()
        local s = not b:GetAttribute("state")
        b:SetAttribute("state", s)
        b.Text = txt.." "..(s and "ON" or "OFF")
        b.BackgroundColor3 = s and Color3.fromRGB(0,170,255) or Color3.fromRGB(45,45,50)
        playSound(s and 6026984224 or 6026984223)
    end)

    return b
end

local farmBtn = toggle("AUTO FARM 🤖",80)
local scanBtn = toggle("SCAN 🔍",130)
local aimBtn  = toggle("AIM 🎯",180)
local espBtn  = toggle("ESP 👁",230)
local noclipBtn = toggle("NOCLIP 🚶",280)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = noclipBtn:GetAttribute("state")
end)

--------------------------------------------------
-- SPEED SLIDER
local slider = Instance.new("Frame", main)
slider.Size = UDim2.new(0.8,0,0,25)
slider.Position = UDim2.new(0.1,0,0,330)
slider.BackgroundColor3 = Color3.fromRGB(45,45,50)

local bar = Instance.new("Frame", slider)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)

local dragging = false

slider.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

slider.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging then
        local x = math.clamp((i.Position.X - slider.AbsolutePosition.X)/slider.AbsoluteSize.X,0,1)
        bar.Size = UDim2.new(x,0,1,0)
        speed = math.floor(x*200)
    end
end)

--------------------------------------------------
-- ESP (FIX KHÔNG MẤT)
local esp = {}

RunService.RenderStepped:Connect(function()
    for _,v in pairs(esp) do if v then v:Destroy() end end
    esp = {}

    if not espBtn:GetAttribute("state") then return end

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart

            local bill = Instance.new("BillboardGui", game.CoreGui)
            bill.Size = UDim2.new(0,120,0,40)
            bill.Adornee = hrp
            bill.AlwaysOnTop = true

            local txt = Instance.new("TextLabel", bill)
            txt.Size = UDim2.new(1,0,1,0)
            txt.BackgroundTransparency = 1
            txt.Text = plr.Name
            txt.TextScaled = true

            table.insert(esp, bill)
        end
    end
end)

--------------------------------------------------
-- AIM (GIỮ NGUYÊN)
local holding = false

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.UserInputType == Enum.UserInputType.MouseButton1 then
        holding = true
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        holding = false
    end
end)

local function getClosest()
    local closest,dist=nil,math.huge
    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr~=player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos,vis = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if vis then
                local d=(Vector2.new(pos.X,pos.Y)-UIS:GetMouseLocation()).Magnitude
                if d<dist then
                    dist=d
                    closest=plr.Character.HumanoidRootPart
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimBtn:GetAttribute("state") and holding then
        local t = getClosest()
        if t then
            camera.CFrame = camera.CFrame:Lerp(
                CFrame.new(camera.CFrame.Position,t.Position),
                0.3
            )
        end
    end
end)
