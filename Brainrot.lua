--// SERVICES
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

--------------------------------------------------
-- GUI (GIỮ NGUYÊN DARK)
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BRAINROT_UI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,320,0,360)
main.Position = UDim2.new(0.5,-160,0.5,-180)
main.BackgroundColor3 = Color3.fromRGB(25,25,30)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local info = Instance.new("Frame", gui)
info.Size = UDim2.new(0,200,0,360)
info.Position = UDim2.new(0.5,-380,0.5,-180)
info.BackgroundColor3 = Color3.fromRGB(25,25,30)
Instance.new("UICorner", info)

local infoText = Instance.new("TextLabel", info)
infoText.Size = UDim2.new(1,0,1,0)
infoText.BackgroundTransparency = 1
infoText.TextColor3 = Color3.new(1,1,1)
infoText.TextScaled = true

--------------------------------------------------
-- CLOSE + TOGGLE
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255,80,80)

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
input.BackgroundColor3 = Color3.fromRGB(40,40,45)
input.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", input)

--------------------------------------------------
-- TOGGLE
local function toggle(txt,y)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.8,0,0,40)
    btn.Position = UDim2.new(0.1,0,0,y)
    btn.Text = txt.." OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40,40,45)
    btn.TextColor3 = Color3.new(1,1,1)

    Instance.new("UICorner", btn)

    local state = false

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = txt.." "..(state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(40,40,45)
        btn:SetAttribute("state", state)
    end)

    return btn
end

local farmBtn = toggle("AUTO FARM 🤖",100)
local scanBtn = toggle("SCAN + NHẶT 🔍",150)
local espBtn  = toggle("ESP PLAYER 👁",200)
local aimBtn  = toggle("AIM 🎯",250)

-- HOP BUTTON (KHÔNG TOGGLE)
local hopBtn = Instance.new("TextButton", main)
hopBtn.Size = UDim2.new(0.8,0,0,40)
hopBtn.Position = UDim2.new(0.1,0,0,300)
hopBtn.Text = "HOP SERVER ⚡"
hopBtn.BackgroundColor3 = Color3.fromRGB(100,100,255)
hopBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", hopBtn)

--------------------------------------------------
-- GUI TOGGLE
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

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.K then
        main.Visible = not main.Visible
        info.Visible = main.Visible
        toggleBtn.Visible = not main.Visible
    end
end)

--------------------------------------------------
-- INFO PLAYER
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        infoText.Text = player.Name.."\nHP: "..math.floor(char.Humanoid.Health)
    end
end)

--------------------------------------------------
-- SCAN
local function scanPet()
    local keyword = string.lower(input.Text)

    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            local p = v:FindFirstChildWhichIsA("BasePart")
            if p then
                if keyword == "" or string.find(string.lower(v.Name), keyword) then
                    return v, p
                end
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
-- PICKUP
local function pickup(part)
    for _,v in pairs(part:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v)
        end
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
                pickup(part)
            end
        end
        task.wait(0.4)
    end
end)

--------------------------------------------------
-- AIM VIP (GIỮ CHUỘT TRÁI)
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
            local pos, onScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)

            if onScreen then
                local diff = (Vector2.new(pos.X,pos.Y) - UIS:GetMouseLocation()).Magnitude
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
    if not aimBtn:GetAttribute("state") or not holdingMouse then return end

    local target = getClosestPlayer()
    if target then
        local predict = target.Velocity * 0.12
        camera.CFrame = camera.CFrame:Lerp(
            CFrame.new(camera.CFrame.Position, target.Position + predict),
            0.25
        )
    end
end)

--------------------------------------------------
-- 🔥 HOP SERVER KHÔNG TRÙNG (FIX CHUẨN)
local visited = {}

hopBtn.MouseButton1Click:Connect(function()
    local servers = HttpService:JSONDecode(game:HttpGet(
        "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
    ))

    for _,s in pairs(servers.data) do
        if s.playing < s.maxPlayers and not visited[s.id] then
            visited[s.id] = true
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end
    end
end)nstance(game.PlaceId, s.id)
            break
        end
    end
end)
