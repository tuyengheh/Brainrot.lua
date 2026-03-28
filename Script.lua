# Brainrot.lua 
   local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlaceID = game.PlaceId

-- PET TARGET
local TARGET_PET = "garama"

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,280,0,160)
frame.Position = UDim2.new(0.35,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,25)
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0,255,150)

-- title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🔥 SERVER HUNTER"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.BackgroundTransparency = 1

-- status
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,40)
status.Position = UDim2.new(0,0,0,30)
status.Text = "Sẵn sàng"
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1

-- button
local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1,-20,0,40)
btn.Position = UDim2.new(0,10,0,90)
btn.Text = "🔁 TÌM GARAMA"
btn.BackgroundColor3 = Color3.fromRGB(50,200,120)
btn.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

-- sound
local sound = Instance.new("Sound", game.Workspace)
sound.SoundId = "rbxassetid://9118823104"
sound.Volume = 3

-- check pet
local function HasPet()
    for _,plr in pairs(Players:GetPlayers()) do
        for _,v in pairs(plr:GetDescendants()) do
            if string.find(string.lower(v.Name), TARGET_PET) then
                return true, plr.Name
            end
        end
    end
    return false
end

-- hop
local function ServerHop()
    local req = Http:JSONDecode(game:HttpGet(
        "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
    ))

    for _,v in pairs(req.data) do
        if v.playing < v.maxPlayers then
            TeleportService:TeleportToPlaceInstance(PlaceID, v.id)
            return
        end
    end
end

-- click
btn.MouseButton1Click:Connect(function()
    status.Text = "🔍 Đang tìm "..TARGET_PET.."..."

    local ok, name = HasPet()

    if ok then
        status.Text = "🔥 FOUND: "..name
        sound:Play()
    else
        status.Text = "❌ Không có → chuyển..."
        task.wait(0.5)
        ServerHop()
    end
end)
