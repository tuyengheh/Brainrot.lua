--// PLAYER
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--------------------------------------------------
-- GUI MAIN
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PREMIUM_UI"
gui.ResetOnSpawn = false

-- ICON MỞ GUI
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,50,0,50)
toggleBtn.Position = UDim2.new(0,20,0.5,-25)
toggleBtn.Text = "☯"
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleBtn.TextScaled = true

-- FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,350,0,300)
frame.Position = UDim2.new(0.5,-175,0.5,-150)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner",frame)

-- CLOSE
local close = Instance.new("TextButton",frame)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,50,50)

close.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- KEY K
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.K then
        frame.Visible = not frame.Visible
    end
end)

--------------------------------------------------
-- INPUT
local input = Instance.new("TextBox",frame)
input.Size = UDim2.new(0.8,0,0,30)
input.Position = UDim2.new(0.1,0,0,10)
input.PlaceholderText = "Tên pet (vd: egg)"

--------------------------------------------------
-- BUTTON STYLE 🌈
local function btn(name,y)
    local b = Instance.new("TextButton",frame)
    b.Size = UDim2.new(0.8,0,0,30)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(0,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true

    local stroke = Instance.new("UIStroke",b)
    stroke.Thickness = 2

    task.spawn(function()
        while b.Parent do
            stroke.Color = Color3.fromHSV(tick()%5/5,1,1)
            task.wait()
        end
    end)

    return b
end

local farmBtn = btn("AUTO FARM OFF",50)
local scanBtn = btn("SCAN + NHẶT",90)
local aimBtn  = btn("AIM OFF",130)
local espBtn  = btn("ESP PLAYER",170)
local infoBtn = btn("INFO PLAYER",210)

--------------------------------------------------
-- INFO PLAYER (FIX)
local infoOn = false
local infoGui

local function createInfo()
    if infoGui then infoGui:Destroy() end

    infoGui = Instance.new("BillboardGui", game.CoreGui)
    infoGui.Size = UDim2.new(0,200,0,60)
    infoGui.AlwaysOnTop = true

    RunService.RenderStepped:Connect(function()
        if not infoOn then return end

        local char = player.Character
        if char and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") then
            infoGui.Adornee = char.Head

            if not infoGui:FindFirstChild("txt") then
                local txt = Instance.new("TextLabel", infoGui)
                txt.Name = "txt"
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.TextScaled = true
                txt.TextColor3 = Color3.new(1,1,1)
            end

            infoGui.txt.Text =
                player.Name.." | HP: "..math.floor(char.Humanoid.Health)
        end
    end)
end

infoBtn.MouseButton1Click:Connect(function()
    infoOn = not infoOn
    infoBtn.Text = infoOn and "INFO ON" or "INFO PLAYER"

    if infoOn then
        createInfo()
    else
        if infoGui then infoGui:Destroy() end
    end
end)

--------------------------------------------------
-- ESP PLAYER (FIX FULL)
local espOn = false
local espList = {}

local function clearESP()
    for _,v in pairs(espList) do
        if v then v:Destroy() end
    end
    espList = {}
end

local function createESP()
    clearESP()

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local beam = Instance.new("Beam", game.CoreGui)

                local att0 = Instance.new("Attachment", camera)
                local att1 = Instance.new("Attachment", hrp)

                beam.Attachment0 = att0
                beam.Attachment1 = att1
                beam.Color = ColorSequence.new(Color3.new(1,1,1))
                beam.Width0 = 0.1
                beam.Width1 = 0.1

                table.insert(espList, beam)
            end
        end
    end
end

espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    espBtn.Text = espOn and "ESP ON" or "ESP PLAYER"

    if espOn then
        createESP()
    else
        clearESP()
    end
end)

--------------------------------------------------
-- SCAN + FARM (FIX INPUT)
local function scanPet()
    local keyword = string.lower(input.Text)

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            local p = v:FindFirstChildWhichIsA("BasePart")
            if p then
                if keyword == "" or string.find(string.lower(v.Name), keyword) then
                    return v,p
                end
            end
        end
    end
end

local function fly(part)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for i=1,40 do
        if not part then break end
        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(part.Position + Vector3.new(0,3,0)),0.1)
        task.wait()
    end
end

local function pickup(part)
    for _,v in pairs(part:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v)
        end
    end
end

--------------------------------------------------
-- AUTO FARM
local farming = false

task.spawn(function()
    while true do
        if farming then
            local pet, part = scanPet()
            if pet then
                fly(part)
                pickup(part)
            end
        end
        task.wait(0.5)
    end
end)

farmBtn.MouseButton1Click:Connect(function()
    farming = not farming
    farmBtn.Text = farming and "AUTO FARM ON" or "AUTO FARM OFF"
end)

--------------------------------------------------
-- SCAN BUTTON
scanBtn.MouseButton1Click:Connect(function()
    local pet, part = scanPet()
    if pet then
        fly(part)
        pickup(part)
    end
end)

--------------------------------------------------
-- AIM LOCK (XỊN)
local aimOn = false
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

local function getTarget()
    local closest, dist = nil, math.huge

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos = plr.Character.HumanoidRootPart.Position
            local screen, vis = camera:WorldToViewportPoint(pos)

            if vis then
                local diff = (Vector2.new(screen.X,screen.Y) - UIS:GetMouseLocation()).Magnitude
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
    if aimOn and holding then
        local t = getTarget()
        if t then
            camera.CFrame = camera.CFrame:Lerp(
                CFrame.new(camera.CFrame.Position, t.Position + t.Velocity*0.1),
                0.25
            )
        end
    end
end)

aimBtn.MouseButton1Click:Connect(function()
    aimOn = not aimOn
    aimBtn.Text = aimOn and "AIM ON" or "AIM OFF"
end)
