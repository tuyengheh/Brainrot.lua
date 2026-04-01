--// PLAYER
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

--------------------------------------------------
-- GUI CHÍNH
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BRAINROT_UI"
gui.ResetOnSpawn = false

--------------------------------------------------
-- MAIN PANEL (PHẢI)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,300,0,350)
main.Position = UDim2.new(0.5,-150,0.5,-175)
main.BackgroundColor3 = Color3.fromRGB(240,240,240)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

-- Nút X
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255,80,80)

--------------------------------------------------
-- NÚT MỞ LẠI (ICON)
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,60,0,60)
toggleBtn.Position = UDim2.new(0.85,0,0.5,0)
toggleBtn.Text = "☯"
toggleBtn.Visible = false

--------------------------------------------------
-- INFO PANEL (TRÁI)
local info = Instance.new("Frame", gui)
info.Size = UDim2.new(0,200,0,350)
info.Position = UDim2.new(0.5,-360,0.5,-175)
info.BackgroundColor3 = Color3.fromRGB(240,240,240)
Instance.new("UICorner", info)

local infoText = Instance.new("TextLabel", info)
infoText.Size = UDim2.new(1,0,1,0)
infoText.BackgroundTransparency = 1
infoText.TextScaled = true
infoText.Text = "INFO"

--------------------------------------------------
-- INPUT
local input = Instance.new("TextBox", main)
input.Size = UDim2.new(0.8,0,0,35)
input.Position = UDim2.new(0.1,0,0,50)
input.PlaceholderText = "Nhập tên pet..."

--------------------------------------------------
-- TOGGLE BUTTON
local function toggle(txt,y)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.8,0,0,40)
    btn.Position = UDim2.new(0.1,0,0,y)
    btn.Text = txt.." OFF"
    btn.BackgroundColor3 = Color3.fromRGB(200,200,200)

    local state = false

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = txt.." "..(state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(100,255,100) or Color3.fromRGB(200,200,200)
        btn:SetAttribute("state", state)
    end)

    return btn
end

local farmBtn = toggle("AUTO FARM 🤖",100)
local scanBtn = toggle("SCAN + NHẶT 🔍",150)
local espBtn  = toggle("ESP PLAYER 👁",200)
local aimBtn  = toggle("AIM 🎯",250)
local hopBtn  = toggle("HOP SERVER 📦",300)

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
-- INFO UPDATE
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local hp = math.floor(char.Humanoid.Health)
        infoText.Text = player.Name.."\nHP: "..hp
    end
end)

--------------------------------------------------
-- SCAN PET
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
-- AUTO PICKUP
local function pickup(part)
    for _,v in pairs(part:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v)
        end
    end
end

--------------------------------------------------
-- AUTO FARM LOOP
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
-- SCAN BUTTON
task.spawn(function()
    while true do
        if scanBtn:GetAttribute("state") then
            local pet,part = scanPet()
            if pet then
                fly(part)
                pickup(part)
            end
        end
        task.wait(0.6)
    end
end)

--------------------------------------------------
-- ESP PLAYER (DÂY TRẮNG)
local esp = {}

RunService.RenderStepped:Connect(function()
    if not espBtn:GetAttribute("state") then
        for _,l in pairs(esp) do l:Remove() end
        esp = {}
        return
    end

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local line = Drawing.new("Line")
            line.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
            local pos,_ = camera:WorldToViewportPoint(hrp.Position)
            line.To = Vector2.new(pos.X,pos.Y)
            line.Color = Color3.new(1,1,1)
            line.Thickness = 1
            line.Visible = true
            table.insert(esp,line)
        end
    end
end)

--------------------------------------------------
-- AIM LOCK XỊN
RunService.RenderStepped:Connect(function()
    if not aimBtn:GetAttribute("state") then return end

    local closest,dist=nil,math.huge

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr~=player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos,onscreen=camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onscreen then
                local diff=(Vector2.new(pos.X,pos.Y)-UIS:GetMouseLocation()).Magnitude
                if diff<dist then
                    dist=diff
                    closest=plr.Character.HumanoidRootPart
                end
            end
        end
    end

    if closest then
        camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Position + closest.Velocity*0.1)
    end
end)

--------------------------------------------------
-- HOP SERVER KHÁC
hopBtn.MouseButton1Click:Connect(function()
    local servers = HttpService:JSONDecode(game:HttpGet(
        "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
    ))

    for _,s in pairs(servers.data) do
        if s.playing < s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end
    end
end)
