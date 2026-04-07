repeat task.wait() until game:IsLoaded()
task.wait(1)

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

--------------------------------------------------
-- GUI PARENT
local parentGui = gethui and gethui() or game:GetService("CoreGui")

--------------------------------------------------
-- INTRO
local intro = Instance.new("ScreenGui", parentGui)
intro.IgnoreGuiInset = true

local bg = Instance.new("Frame", intro)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(10,10,15)

local title = Instance.new("TextLabel", bg)
title.Size = UDim2.new(1,0,0.2,0)
title.Position = UDim2.new(0,0,0.4,0)
title.Text = "✨ TIENHUB ✨"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextTransparency = 1

TweenService:Create(title, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
task.wait(2)
TweenService:Create(bg, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
task.wait(1)
intro:Destroy()

--------------------------------------------------
-- GUI ROOT
local gui = Instance.new("ScreenGui")
gui.Parent = parentGui
gui.ResetOnSpawn = false

--------------------------------------------------
-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,320,0,450)
main.Position = UDim2.new(0.5,-160,0.5,-225)
main.BackgroundColor3 = Color3.fromRGB(30,30,35)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

--------------------------------------------------
-- TOGGLE
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,60,0,60)
toggleBtn.Position = UDim2.new(0.88,0,0.5,0)
toggleBtn.Text = "☠️"
toggleBtn.Visible = false
Instance.new("UICorner", toggleBtn)

local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"

close.MouseButton1Click:Connect(function()
    main.Visible = false
    toggleBtn.Visible = true
end)

toggleBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    toggleBtn.Visible = false
end)

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
-- SPEED
local speed = 16

local slider = Instance.new("Frame", main)
slider.Size = UDim2.new(0.8,0,0,30)
slider.Position = UDim2.new(0.1,0,0,350)
slider.BackgroundColor3 = Color3.fromRGB(45,45,50)
Instance.new("UICorner", slider)

local fill = Instance.new("Frame", slider)
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
Instance.new("UICorner", fill)

local dragging = false

local function updateSlider(xPos)
    local x = math.clamp((xPos - slider.AbsolutePosition.X)/slider.AbsoluteSize.X,0,1)
    fill.Size = UDim2.new(x,0,1,0)
    speed = math.floor(x*200)
end

slider.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        updateSlider(i.Position.X)
    end
end)

slider.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(i)
    if dragging then updateSlider(i.Position.X) end
end)

--------------------------------------------------
-- APPLY SPEED (SAFE)
task.spawn(function()
    while true do
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = speed
        end
        task.wait(0.3)
    end
end)

--------------------------------------------------
-- INFO
local info = Instance.new("TextLabel", main)
info.Size = UDim2.new(1,0,0,40)
info.BackgroundTransparency = 1
info.TextScaled = true
info.TextColor3 = Color3.new(1,1,1)

task.spawn(function()
    while true do
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            info.Text = player.Name.." | HP "..math.floor(char.Humanoid.Health).." | Speed "..speed
        end
        task.wait(0.5)
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
    end)

    return b
end

local farmBtn = toggle("AUTO FARM",100)
local espBtn  = toggle("ESP PLAYER",150)
local aimBtn  = toggle("AIM",200)
local eventBtn = toggle("AUTO EVENT",250)

--------------------------------------------------
-- NOCLIP
RunService.Stepped:Connect(function()
    if farmBtn:GetAttribute("state") then
        local char = player.Character
        if char then
            for _,v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

--------------------------------------------------
-- AUTO FARM (FLY NHẸ)
local function getPet()
    local keyword = string.lower(input.Text)
    if keyword == "" then return end

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and string.find(string.lower(v.Name), keyword) then
            return v:FindFirstChildWhichIsA("BasePart")
        end
    end
end

task.spawn(function()
    while true do
        if farmBtn:GetAttribute("state") then
            local part = getPet()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

            if part and hrp then
                hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(part.Position+Vector3.new(0,3,0)),0.2)

                for _,v in pairs(part:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        fireproximityprompt(v)
                    end
                end
            end
        end
        task.wait(0.3)
    end
end)

--------------------------------------------------
-- ESP PLAYER (NHẸ)
local espList = {}

task.spawn(function()
    while true do
        for _,v in pairs(espList) do if v then v:Destroy() end end
        espList = {}

        if espBtn:GetAttribute("state") then
            for _,plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local bill = Instance.new("BillboardGui", gui)
                        bill.Size = UDim2.new(0,120,0,40)
                        bill.Adornee = hrp
                        bill.AlwaysOnTop = true

                        local txt = Instance.new("TextLabel", bill)
                        txt.Size = UDim2.new(1,0,1,0)
                        txt.BackgroundTransparency = 1
                        txt.TextScaled = true
                        txt.Text = plr.Name

                        table.insert(espList, bill)
                    end
                end
            end
        end

        task.wait(1)
    end
end)

--------------------------------------------------
-- AIM
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
    local closest,dist=nil,4000
    local myChar=player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

    local myPos=myChar.HumanoidRootPart.Position

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr~=player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp=plr.Character.HumanoidRootPart
            local d=(myPos-hrp.Position).Magnitude
            if d<dist then
                dist=d
                closest=hrp
            end
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    if aimBtn:GetAttribute("state") and holding then
        local t=getClosest()
        if t then
            camera.CFrame = CFrame.new(camera.CFrame.Position, t.Position)
        end
    end
end)

--------------------------------------------------
-- AUTO EVENT (SAFE)
task.spawn(function()
    while true do
        if eventBtn:GetAttribute("state") then
            for _,v in pairs(workspace:GetDescendants()) do
                if v.Name == "EasterBaseSkinPedestal" then
                    for _,p in pairs(v:GetDescendants()) do
                        if p:IsA("ProximityPrompt") then
                            fireproximityprompt(p)
                        end
                    end
                end
            end
        end
        task.wait(3)
    end
end)
--------------------------------------------------
-- 🎯 HOP SERVER TÌM PET

local targetPet = "" -- nhập tên pet cần tìm (ví dụ: dragon)
local found = false

local function findPetInServer()
    local keyword = string.lower(targetPet)

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            if string.find(string.lower(v.Name), keyword) then
                print("FOUND PET:", v.Name)
                found = true
                return true
            end
        end
    end

    return false
end

local function hopServer()
    local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(
        "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
    ))

    for _,s in pairs(data.data) do
        if s.playing < s.maxPlayers then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end
    end
end

-- 🔁 LOOP
task.spawn(function()
    while true do
        task.wait(3)

        if targetPet ~= "" and not found then
            if not findPetInServer() then
                print("Không có → hop tiếp")
                hopServer()
            else
                print("ĐÃ TÌM THẤY PET → DỪNG")
                break
            end
        end
    end
end)
