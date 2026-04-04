repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

--------------------------------------------------
-- GUI ROOT (FIX 100%)
local gui = Instance.new("ScreenGui")
gui.Name = "TIENHUB_UI"
gui.Parent = gethui and gethui() or game.CoreGui
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
info.Size = UDim2.new(0,220,0,420)
info.Position = UDim2.new(0.5,-400,0.5,-210)
info.BackgroundColor3 = Color3.fromRGB(25,25,30)
Instance.new("UICorner", info)

local infoText = Instance.new("TextLabel", info)
infoText.Size = UDim2.new(1,0,1,0)
infoText.BackgroundTransparency = 1
infoText.TextColor3 = Color3.new(1,1,1)
infoText.TextScaled = true

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

--------------------------------------------------
-- CLOSE
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255,80,80)

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
-- INPUT PET (QUAN TRỌNG)
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
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
    end
end)

--------------------------------------------------
-- INFO UPDATE
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
    end)

    return b
end

local farmBtn = toggle("AUTO FARM 🤖",100)
local scanBtn = toggle("SCAN 🔍",150)
local aimBtn  = toggle("AIM 🎯",200)
local espBtn  = toggle("ESP 👁",250)

--------------------------------------------------
-- HOP SERVER
local hopBtn = Instance.new("TextButton", main)
hopBtn.Size = UDim2.new(0.8,0,0,40)
hopBtn.Position = UDim2.new(0.1,0,0,300)
hopBtn.Text = "HOP SERVER ⚡"
hopBtn.BackgroundColor3 = Color3.fromRGB(100,100,255)
hopBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", hopBtn)

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

--------------------------------------------------
-- SCAN PET (FIX)
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
        hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(part.Position + Vector3.new(0,3,0)),0.1)
        task.wait(0.03)
    end
end

--------------------------------------------------
-- FARM
task.spawn(function()
    while true do
        if farmBtn:GetAttribute("state") then
            local pet,part = scanPet()
            if pet then fly(part) end
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
-- ESP (BOX + TEXT)
local espList = {}

RunService.RenderStepped:Connect(function()
    for _,v in pairs(espList) do v:Destroy() end
    espList = {}

    if not espBtn:GetAttribute("state") then return end

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local char = plr.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")

            if hrp and hum then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = char
                box.Size = Vector3.new(4,6,2)
                box.Color3 = Color3.new(1,1,1)
                box.AlwaysOnTop = true
                box.Parent = gui

                local bill = Instance.new("BillboardGui", gui)
                bill.Size = UDim2.new(0,120,0,40)
                bill.Adornee = hrp
                bill.AlwaysOnTop = true

                local txt = Instance.new("TextLabel", bill)
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
    end
end)
