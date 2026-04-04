repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

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
-- GUI ROOT
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

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
-- INFO PANEL
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
-- ☯ BUTTON (FIX LUÔN HIỆN)
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

close.MouseButton1Click:Connect(function()
    main.Visible = false
    info.Visible = false
    toggleBtn.Visible = true
end)

toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    info.Visible = true
    toggleBtn.Visible = false
end)

--------------------------------------------------
-- INPUT PET (FIX QUAN TRỌNG 🔥)
local input = Instance.new("TextBox", main)
input.Size = UDim2.new(0.8,0,0,35)
input.Position = UDim2.new(0.1,0,0,50)
input.PlaceholderText = "Nhập tên pet..."
input.BackgroundColor3 = Color3.fromRGB(45,45,50)
input.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", input)

--------------------------------------------------
-- INFO UPDATE
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        infoText.Text =
            "👤 "..player.Name..
            "\n❤️ "..math.floor(char.Humanoid.Health)
    end
end)

--------------------------------------------------
-- TOGGLE
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

local farmBtn = toggle("AUTO FARM 🤖",100)
local scanBtn = toggle("SCAN 🔍",150)
local aimBtn  = toggle("AIM 🎯",200)
local espBtn  = toggle("ESP 👁",250)

--------------------------------------------------
-- SCAN PET (FIX CÓ KEYWORD)
local function scanPet()
    local keyword = string.lower(input.Text)

    if keyword == "" then return nil end -- ❗ bắt buộc nhập

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            local p = v:FindFirstChildWhichIsA("BasePart")
            if p and string.find(string.lower(v.Name), keyword) then
                return v,p
            end
        end
    end
end

--------------------------------------------------
-- FLY
local function fly(part)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for i=1,40 do
        if not part then break end
        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(part.Position + Vector3.new(0,3,0)),0.1)
        task.wait(0.03)
    end
end

--------------------------------------------------
-- AUTO FARM
task.spawn(function()
    while true do
        if farmBtn:GetAttribute("state") then
            local pet,part = scanPet()
            if pet then
                fly(part)
            end
        end
        task.wait(0.5)
    end
end)

--------------------------------------------------
-- SCAN + NHẶT
task.spawn(function()
    while true do
        if scanBtn:GetAttribute("state") then
            local pet,part = scanPet()
            if pet then
                fly(part)
                for _,v in pairs(part:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        fireproximityprompt(v)
                    end
                end
            end
        end
        task.wait(1)
    end
end)

--------------------------------------------------
-- AIM (GIỮ NGUYÊN)
local holding=false

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.UserInputType==Enum.UserInputType.MouseButton1 then
        holding=true
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then
        holding=false
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
        local t=getClosest()
        if t then
            camera.CFrame = camera.CFrame:Lerp(
                CFrame.new(camera.CFrame.Position,t.Position),
                0.3
            )
        end
    end
end)
