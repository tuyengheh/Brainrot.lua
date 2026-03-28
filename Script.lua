# Brainrot.lua 
   local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlaceID = game.PlaceId

-- 🔥 DANH SÁCH PET (ALL)
local PET_LIST = {
    "garama and madundung",
    "tictac sahur",
    "lavadorito spinito",
    "la secret combinasion",
    "ketchuru and musturu",
    "spaghetti tualetti",
    "eviledon",
    "spooky and pumpky",
    "bacuru and egguru",
    "cooki and milki",
    "ketupat kepat",
    "griffin",
    "hydra",
    "dragon",
    "skibidi"
}

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,160)
frame.Position = UDim2.new(0.35,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0,255,150)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🔥 PET SERVER HUNTER"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.BackgroundTransparency = 1

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,40)
status.Position = UDim2.new(0,0,0,30)
status.Text = "Sẵn sàng"
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1,-20,0,40)
btn.Position = UDim2.new(0,10,0,90)
btn.Text = "🔁 ROLL ALL PET"
btn.BackgroundColor3 = Color3.fromRGB(50,200,120)
btn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", btn)

-- 🔊 SOUND
local sound = Instance.new("Sound", game.Workspace)
sound.SoundId = "rbxassetid://9118823104"
sound.Volume = 3

-- check ALL pet
local function HasPet()
    for _,plr in pairs(Players:GetPlayers()) do
        for _,v in pairs(plr:GetDescendants()) do
            local name = string.lower(v.Name)

            for _,pet in pairs(PET_LIST) do
                if string.find(name, pet) then
                    return true, plr.Name, pet
                end
            end
        end
    end
    return false
end

-- hop server
local function ServerHop()
    local success, req = pcall(function()
        return Http:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)

    if not success or not req or not req.data then
        status.Text = "❌ Lỗi server → bấm lại"
        return
    end

    for _,v in pairs(req.data) do
        if v.playing < v.maxPlayers then
            status.Text = "🔁 Đang chuyển server..."
            TeleportService:TeleportToPlaceInstance(PlaceID, v.id)
            return
        end
    end

    status.Text = "⚠️ Server full → bấm lại"
end

-- click
btn.MouseButton1Click:Connect(function()
    status.Text = "🔍 Đang tìm pet..."

    local ok, name, pet = HasPet()

    if ok then
        status.Text = "🔥 FOUND: "..pet.." - "..name

        -- 🔊 sound
        for i = 1,2 do
            sound:Play()
            task.wait(0.2)
        end
    else
        status.Text = "❌ Không có → chuyển..."
        task.wait(0.5)
        ServerHop()
    end
end)
