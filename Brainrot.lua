--// SERVICES
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

--------------------------------------------------
-- SAVE SPAWN
local spawnCF
local function setSpawn()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    spawnCF = hrp.CFrame
end

setSpawn()
player.CharacterAdded:Connect(function()
    task.wait(1)
    setSpawn()
end)

--------------------------------------------------
-- GUI ROOT
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BRAINROT_UI"
gui.ResetOnSpawn = false

--------------------------------------------------
-- MAIN UI
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,320,0,360)
main.Position = UDim2.new(0.5,-160,0.5,-180)
main.BackgroundColor3 = Color3.fromRGB(35,35,40)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

--------------------------------------------------
-- INPUT
local input = Instance.new("TextBox", main)
input.Size = UDim2.new(0.8,0,0,35)
input.Position = UDim2.new(0.1,0,0,50)
input.PlaceholderText = "Nhập tên pet..."
input.BackgroundColor3 = Color3.fromRGB(50,50,55)
input.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", input)

--------------------------------------------------
-- BUTTON TOGGLE
local function toggle(txt,y)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.8,0,0,40)
    btn.Position = UDim2.new(0.1,0,0,y)
    btn.Text = txt.." OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50,50,55)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)

    btn:SetAttribute("state", false)

    btn.MouseButton1Click:Connect(function()
        local state = not btn:GetAttribute("state")
        btn:SetAttribute("state", state)
        btn.Text = txt.." "..(state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(50,50,55)
    end)

    return btn
end

local farmBtn = toggle("AUTO FARM 🤖",100)
local scanBtn = toggle("SCAN + NHẶT 🔍",150)
local aimBtn  = toggle("AIM 🎯",200)
local espBtn  = toggle("ESP PLAYER 👁",250)

--------------------------------------------------
-- HOP
local hopBtn = Instance.new("TextButton", main)
hopBtn.Size = UDim2.new(0.8,0,0,40)
hopBtn.Position = UDim2.new(0.1,0,0,300)
hopBtn.Text = "HOP SERVER ⚡"
hopBtn.BackgroundColor3 = Color3.fromRGB(100,100,255)
hopBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", hopBtn)

--------------------------------------------------
-- SCAN
local function scanPet()
    local keyword = string.lower(input.Text)

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            local p = v:FindFirstChildWhichIsA("BasePart")
            if p and (keyword == "" or string.find(string.lower(v.Name), keyword)) then
                return v, p
            end
        end
    end
end

--------------------------------------------------
-- FLY
local function flyTo(cf)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for i=1,40 do
        hrp.CFrame = hrp.CFrame:Lerp(cf,0.1)
        task.wait(0.03)
    end
end

--------------------------------------------------
-- PICKUP
local function pickup(part)
    for _,v in pairs(part:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            v.HoldDuration = 0
            fireproximityprompt(v)
        end
    end
end

--------------------------------------------------
-- SCAN + NHẶT + VỀ SPAWN
task.spawn(function()
    while true do
        if scanBtn:GetAttribute("state") then
            local pet,part = scanPet()

            if pet and part then
                flyTo(CFrame.new(part.Position + Vector3.new(0,3,0)))
                pickup(part)
                task.wait(0.3)
                if spawnCF then
                    flyTo(spawnCF)
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
                flyTo(CFrame.new(part.Position + Vector3.new(0,3,0)))
            end
        end
        task.wait(0.4)
    end
end)

--------------------------------------------------
-- AIM
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
                local diff=(Vector2.new(pos.X,pos.Y)-UIS:GetMouseLocation()).Magnitude
                if diff<dist then
                    dist=diff
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
                CFrame.new(camera.CFrame.Position, t.Position),
                0.3
            )
        end
    end
end)

--------------------------------------------------
-- ESP BOX + DISTANCE
local espList={}

local function clearESP()
    for _,v in pairs(espList) do
        v:Destroy()
    end
    espList={}
end

local function createESP()
    clearESP()

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr~=player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp=plr.Character.HumanoidRootPart

            local bill=Instance.new("BillboardGui",game.CoreGui)
            bill.Size=UDim2.new(0,120,0,60)
            bill.Adornee=hrp
            bill.AlwaysOnTop=true

            local box=Instance.new("Frame",bill)
            box.Size=UDim2.new(1,0,1,0)
            box.BackgroundTransparency=1
            box.BorderSizePixel=2
            box.BorderColor3=Color3.new(1,1,1)

            local txt=Instance.new("TextLabel",bill)
            txt.Size=UDim2.new(1,0,0.4,0)
            txt.Position=UDim2.new(0,0,-0.4,0)
            txt.BackgroundTransparency=1
            txt.TextColor3=Color3.new(1,1,1)
            txt.TextScaled=true

            table.insert(espList,{gui=bill,player=plr,text=txt})
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not espBtn:GetAttribute("state") then
        clearESP()
        return
    end

    if #espList==0 then
        createESP()
    end

    for _,v in pairs(espList) do
        if v.player.Character and v.player.Character:FindFirstChild("HumanoidRootPart") then
            local dist=(player.Character.HumanoidRootPart.Position - v.player.Character.HumanoidRootPart.Position).Magnitude
            v.text.Text = v.player.Name.." ["..math.floor(dist).."]"
        end
    end
end)

--------------------------------------------------
-- HOP SERVER
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
