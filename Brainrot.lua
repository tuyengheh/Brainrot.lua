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
-- GUI PARENT (FIX 100% KHÔNG MẤT MENU)
local parentGui = gethui and gethui() or game:GetService("CoreGui")

--------------------------------------------------
-- INTRO
local intro = Instance.new("ScreenGui")
intro.Parent = parentGui
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
gui.Name = "TIENHUB_UI"
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
-- ☯ BUTTON
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,60,0,60)
toggleBtn.Position = UDim2.new(0.88,0,0.5,0)
toggleBtn.Text = "☯"
toggleBtn.TextScaled = true
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
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
------------------------------
task.spawn(function()
    while true do
        if eventBtn:GetAttribute("state") then

            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart

                for _,v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        
                        local part = v.Parent
                        if part and part:IsA("BasePart") then
                            
                            local dist = (hrp.Position - part.Position).Magnitude
                            
                            -- chỉ lấy gần (tránh spam toàn map)
                            if dist < 20 then
                                
                                -- debug để bạn biết nó là gì
                                print("FOUND:", v.ObjectText, v.ActionText)

                                fireproximityprompt(v)
                                task.wait(0.5)
                            end
                        end
                    end
                end
            end
        end

        task.wait(0.5)
    end
end)
                            
--------------------------------------------------
-- SPEED SLIDER
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
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        updateSlider(i.Position.X)
    end
end)

UIS.TouchMoved:Connect(function(i)
    if dragging then
        updateSlider(i.Position.X)
    end
end)

RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
    end
end)

--------------------------------------------------
-- INFO
local info = Instance.new("TextLabel", main)
info.Size = UDim2.new(1,0,0,40)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.new(1,1,1)
info.TextScaled = true

RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        info.Text = player.Name.." | HP "..math.floor(char.Humanoid.Health).." | Speed "..speed
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
local eventBtn = toggle("AUTO EVENT 🥚",300)
local farmBtn = toggle("AUTO FARM",100)
local scanBtn = toggle("SCAN",150)
local espBtn  = toggle("ESP",200)
local aimBtn  = toggle("AIM",250)

--------------------------------------------------
-- SCAN
local function scanPet()
    local keyword = string.lower(input.Text)
    if keyword == "" then return end

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
        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(part.Position+Vector3.new(0,3,0)),0.1)
        task.wait(0.03)
    end
end

--------------------------------------------------
-- FARM
task.spawn(function()
    while true do
        if farmBtn:GetAttribute("state") or scanBtn:GetAttribute("state") then
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
        task.wait(0.6)
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
-- ESP
local espList={}
RunService.RenderStepped:Connect(function()
    for _,v in pairs(espList) do v:Destroy() end
    espList={}

    if not espBtn:GetAttribute("state") then return end

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr~=player and plr.Character then
            local char=plr.Character
            local hrp=char:FindFirstChild("HumanoidRootPart")
            local hum=char:FindFirstChild("Humanoid")

            if hrp and hum then
                local box=Instance.new("BoxHandleAdornment")
                box.Adornee=char
                box.Size=Vector3.new(4,6,2)
                box.AlwaysOnTop=true
                box.Parent=gui

                local bill=Instance.new("BillboardGui",gui)
                bill.Size=UDim2.new(0,120,0,40)
                bill.Adornee=hrp
                bill.AlwaysOnTop=true

                local txt=Instance.new("TextLabel",bill)
                txt.Size=UDim2.new(1,0,1,0)
                txt.BackgroundTransparency=1
                txt.TextScaled=true

                local dist=(player.Character.HumanoidRootPart.Position-hrp.Position).Magnitude
                txt.Text=plr.Name.." | "..math.floor(hum.Health).." ["..math.floor(dist).."]"

                table.insert(espList,box)
                table.insert(espList,bill)
            end
        end
    end
end)

--------------------------------------------------
-- HOP SERVER
local hopBtn = Instance.new("TextButton", main)
hopBtn.Size = UDim2.new(0.8,0,0,40)
hopBtn.Position = UDim2.new(0.1,0,0,300)
hopBtn.Text = "HOP SERVER"

hopBtn.MouseButton1Click:Connect(function()
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
