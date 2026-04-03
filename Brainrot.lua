--// INTRO ANIME PREMIUM

local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

-- GUI
local intro = Instance.new("ScreenGui", game.CoreGui)
intro.Name = "INTRO_ANIME"
intro.IgnoreGuiInset = true

local bg = Instance.new("Frame", intro)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(10,10,15)

-- LOGO TEXT
local title = Instance.new("TextLabel", bg)
title.Size = UDim2.new(1,0,0.2,0)
title.Position = UDim2.new(0,0,0.35,0)
title.Text = "✨ TIENHUB ✨"
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.TextTransparency = 1

-- USER NAME
local user = Instance.new("TextLabel", bg)
user.Size = UDim2.new(1,0,0.1,0)
user.Position = UDim2.new(0,0,0.55,0)
user.Text = "User: "..game.Players.LocalPlayer.Name
user.TextScaled = true
user.Font = Enum.Font.GothamBold
user.TextColor3 = Color3.fromRGB(0,170,255)
user.BackgroundTransparency = 1
user.TextTransparency = 1

-- LOADING BAR
local barBG = Instance.new("Frame", bg)
barBG.Size = UDim2.new(0.4,0,0.02,0)
barBG.Position = UDim2.new(0.3,0,0.7,0)
barBG.BackgroundColor3 = Color3.fromRGB(40,40,50)
Instance.new("UICorner", barBG)

local bar = Instance.new("Frame", barBG)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
Instance.new("UICorner", bar)

-- SOUND (anime vibe)
local sound = Instance.new("Sound", SoundService)
sound.SoundId = "rbxassetid://1843520824" -- anime whoosh
sound.Volume = 2
sound:Play()

-- EFFECT: FADE IN TEXT
TweenService:Create(title, TweenInfo.new(1), {TextTransparency = 0}):Play()
TweenService:Create(user, TweenInfo.new(1.2), {TextTransparency = 0}):Play()

-- LOADING ANIMATION
TweenService:Create(bar, TweenInfo.new(2.5, Enum.EasingStyle.Sine), {
    Size = UDim2.new(1,0,1,0)
}):Play()

-- GLOW EFFECT (nhấp nháy anime)
task.spawn(function()
    while intro.Parent do
        title.TextColor3 = Color3.fromHSV(tick()%5/5,1,1)
        task.wait()
    end
end)

-- END INTRO
task.wait(3)

TweenService:Create(bg, TweenInfo.new(1), {
    BackgroundTransparency = 1
}):Play()

TweenService:Create(title, TweenInfo.new(1), {
    TextTransparency = 1
}):Play()

TweenService:Create(user, TweenInfo.new(1), {
    TextTransparency = 1
}):Play()

task.wait(1)
intro:Destroy()

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
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
-- SAVE SPAWN
local spawnCF
local function setSpawn()
    local char = player.Character or player.CharacterAdded:Wait()
    spawnCF = char:WaitForChild("HumanoidRootPart").CFrame
end
setSpawn()
player.CharacterAdded:Connect(function()
    task.wait(1)
    setSpawn()
end)

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
gui.Name = "BRAINROT_UI"
gui.ResetOnSpawn = false

--------------------------------------------------
-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,320,0,400)
main.Position = UDim2.new(0.5,-160,0.5,-200)
main.BackgroundColor3 = Color3.fromRGB(30,30,35)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

--------------------------------------------------
-- INFO PANEL
local info = Instance.new("Frame", gui)
info.Size = UDim2.new(0,200,0,400)
info.Position = UDim2.new(0.5,-380,0.5,-200)
info.BackgroundColor3 = Color3.fromRGB(30,30,35)
Instance.new("UICorner", info)

local infoText = Instance.new("TextLabel", info)
infoText.Size = UDim2.new(1,0,1,0)
infoText.BackgroundTransparency = 1
infoText.TextColor3 = Color3.new(1,1,1)
infoText.TextScaled = true

--------------------------------------------------
-- CLOSE + ☯
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,60,0,60)
toggleBtn.Position = UDim2.new(0.85,0,0.5,0)
toggleBtn.Text = "☯"
toggleBtn.Visible = false

--------------------------------------------------
-- INPUT
local input = Instance.new("TextBox", main)
input.Size = UDim2.new(0.8,0,0,35)
input.Position = UDim2.new(0.1,0,0,50)
input.PlaceholderText = "Nhập tên pet..."
input.BackgroundColor3 = Color3.fromRGB(45,45,50)
input.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", input)

--------------------------------------------------
-- BUTTON
local function toggle(txt,y)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.8,0,0,40)
    btn.Position = UDim2.new(0.1,0,0,y)
    btn.Text = txt.." OFF"
    btn.BackgroundColor3 = Color3.fromRGB(45,45,50)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)

    btn:SetAttribute("state", false)

    btn.MouseButton1Click:Connect(function()
        local s = not btn:GetAttribute("state")
        btn:SetAttribute("state", s)
        btn.Text = txt.." "..(s and "ON" or "OFF")
        btn.BackgroundColor3 = s and Color3.fromRGB(0,170,255) or Color3.fromRGB(45,45,50)
        playSound(s and 6026984224 or 6026984223)
    end)

    return btn
end

local farmBtn = toggle("AUTO FARM 🤖",100)
local scanBtn = toggle("SCAN 🔍",150)
local aimBtn  = toggle("AIM 🎯",200)
local espBtn  = toggle("ESP 👁",250)
local noclipBtn = toggle("NOCLIP 🚶",300)

--------------------------------------------------
-- HOP
local hopBtn = Instance.new("TextButton", main)
hopBtn.Size = UDim2.new(0.8,0,0,40)
hopBtn.Position = UDim2.new(0.1,0,0,350)
hopBtn.Text = "HOP SERVER ⚡"

--------------------------------------------------
-- GUI TOGGLE
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

--------------------------------------------------
-- NOCLIP BTN
noclipBtn.MouseButton1Click:Connect(function()
    noclip = noclipBtn:GetAttribute("state")
end)

--------------------------------------------------
-- INFO UPDATE
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        infoText.Text = player.Name.." | HP: "..math.floor(char.Humanoid.Health)
    end
end)

--------------------------------------------------
-- SCAN
local function scanPet()
    local keyword = string.lower(input.Text)
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            local p = v:FindFirstChildWhichIsA("BasePart")
            if p and (keyword=="" or string.find(string.lower(v.Name),keyword)) then
                return v,p
            end
        end
    end
end

--------------------------------------------------
-- FLY (CHẬM + ANTI KICK)
local function fly(cf)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    noclip = true
    for i=1,60 do
        hrp.CFrame = hrp.CFrame:Lerp(cf,0.05)
        task.wait(0.05)
    end
    noclip = false
end

--------------------------------------------------
-- PICKUP
local function pickup(part)
    local picked = false

    for _,v in pairs(part:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v)
            picked = true
            task.wait(0.1)
        end
    end

    if picked then
        playSound(9114487369)
    end
end

--------------------------------------------------
-- SCAN + NHẶT + VỀ SPAWN
task.spawn(function()
    while true do
        if scanBtn:GetAttribute("state") then
            local pet,part = scanPet()
            if pet then
                fly(CFrame.new(part.Position + Vector3.new(0,3,0)))
                pickup(part)
                task.wait(0.5)
                if spawnCF then
                    fly(spawnCF)
                end
            end
        end
        task.wait(1)
    end
end)

--------------------------------------------------
-- AUTO FARM
task.spawn(function()
    while true do
        if farmBtn:GetAttribute("state") then
            local pet,part = scanPet()
            if pet then
                fly(CFrame.new(part.Position + Vector3.new(0,3,0)))
            end
        end
        task.wait(0.5)
    end
end)

--------------------------------------------------
-- AIM (GIỮ NGUYÊN XỊN)
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

--------------------------------------------------
-- ESP (BOX + HP + DIST)
local espList = {}

RunService.RenderStepped:Connect(function()
    for _,v in pairs(espList) do if v then v:Destroy() end end
    espList = {}

    if not espBtn:GetAttribute("state") then return end

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr~=player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local char = plr.Character
            local hrp = char.HumanoidRootPart
            local hum = char:FindFirstChild("Humanoid")

            local box = Instance.new("BoxHandleAdornment")
            box.Adornee = char
            box.Size = Vector3.new(4,6,2)
            box.AlwaysOnTop = true
            box.Color3 = Color3.new(1,1,1)
            box.Parent = game.CoreGui

            local bill = Instance.new("BillboardGui",game.CoreGui)
            bill.Size = UDim2.new(0,120,0,40)
            bill.Adornee = hrp
            bill.AlwaysOnTop = true

            local txt = Instance.new("TextLabel",bill)
            txt.Size = UDim2.new(1,0,1,0)
            txt.BackgroundTransparency = 1
            txt.TextColor3 = Color3.new(1,1,1)
            txt.TextScaled = true

            local dist = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            txt.Text = plr.Name.." | "..math.floor(hum.Health).." ["..math.floor(dist).."]"

            table.insert(espList, box)
            table.insert(espList, bill)
        end
    end
end)

--------------------------------------------------
-- HOP SERVER
hopBtn.MouseButton1Click:Connect(function()
    playSound(9118828564)

    local data = HttpService:JSONDecode(game:HttpGet(
        "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
    ))

    for _,s in pairs(data.data) do
        if s.playing < s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end
    end
end)
