# Brainrot.lua 
   local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlaceID = game.PlaceId

-- PET LIST
local ALL_PETS = {
    "garama and madundung",
    "lavadorito spinito",
    "la secret combinasion",
    "spaghetti tualetti",
    "eviledon",
    "griffin",
    "hydra",
    "dragon",
    "skibidi"
}

-- m/s
local PET_M = {
    ["garama and madundung"] = 50,
    ["lavadorito spinito"] = 60,
    ["la secret combinasion"] = 125,
    ["spaghetti tualetti"] = 60,
    ["eviledon"] = 300,
    ["griffin"] = 400,
    ["hydra"] = 300,
    ["dragon"] = 300,
    ["skibidi"] = 330
}

-- selected pets
local SELECTED = {}
for _,p in pairs(ALL_PETS) do
    SELECTED[p] = true
end

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,260)
frame.Position = UDim2.new(0.35,0,0.35,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,30)
status.Text = "Sẵn sàng"
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1

-- 🔊 sound
local sound = Instance.new("Sound", game.Workspace)
sound.SoundId = "rbxassetid://9118823104"
sound.Volume = 3

-- PET TOGGLE UI
local y = 35
for _,pet in pairs(ALL_PETS) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1,-20,0,25)
    btn.Position = UDim2.new(0,10,0,y)
    btn.Text = "✅ "..pet
    btn.BackgroundColor3 = Color3.fromRGB(40,40,60)
    btn.TextColor3 = Color3.new(1,1,1)

    btn.MouseButton1Click:Connect(function()
        SELECTED[pet] = not SELECTED[pet]
        btn.Text = (SELECTED[pet] and "✅ " or "❌ ")..pet
    end)

    y = y + 28
end

-- BUTTONS
local rollBtn = Instance.new("TextButton", frame)
rollBtn.Size = UDim2.new(1,-20,0,30)
rollBtn.Position = UDim2.new(0,10,1,-90)
rollBtn.Text = "🔁 ROLL"
rollBtn.BackgroundColor3 = Color3.fromRGB(50,150,255)

local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(1,-20,0,30)
autoBtn.Position = UDim2.new(0,10,1,-55)
autoBtn.Text = "🤖 AUTO: OFF"
autoBtn.BackgroundColor3 = Color3.fromRGB(200,100,100)

local fastBtn = Instance.new("TextButton", frame)
fastBtn.Size = UDim2.new(1,-20,0,30)
fastBtn.Position = UDim2.new(0,10,1,-20)
fastBtn.Text = "⚡ FAST: OFF"
fastBtn.BackgroundColor3 = Color3.fromRGB(100,200,100)

local auto = false
local fast = false

-- CHECK
local function HasPet()
    for _,plr in pairs(Players:GetPlayers()) do
        for _,v in pairs(plr:GetDescendants()) do
            local name = string.lower(v.Name)

            for pet,_ in pairs(SELECTED) do
                if SELECTED[pet] and string.find(name, pet) then
                    local m = PET_M[pet]
                    if m and m >= 50 then
                        return true, plr.Name, pet, m
                    end
                end
            end
        end
    end
    return false
end

-- HOP
local function Hop()
    local req = Http:JSONDecode(game:HttpGet(
        "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
    ))

    for _,v in pairs(req.data) do
        if v.playing < v.maxPlayers then
            TeleportService:TeleportToPlaceInstance(PlaceID, v.id)
            return
        end
    end

    status.Text = "⚠️ Server full"
end

-- ROLL FUNCTION
local function RollOnce()
    local ok,name,pet,m = HasPet()

    if ok then
        status.Text = "🔥 "..pet.." ("..m.."m) - "..name
        sound:Play()
        return true
    else
        status.Text = "❌ Không có → chuyển"
        Hop()
        return false
    end
end

-- CLICK
rollBtn.MouseButton1Click:Connect(function()
    RollOnce()
end)

autoBtn.MouseButton1Click:Connect(function()
    auto = not auto
    autoBtn.Text = "🤖 AUTO: "..(auto and "ON" or "OFF")

    if auto then
        task.spawn(function()
            while auto do
                local found = RollOnce()
                if found then auto = false break end
                task.wait(fast and 0.3 or 1)
            end
        end)
    end
end)

fastBtn.MouseButton1Click:Connect(function()
    fast = not fast
    fastBtn.Text = "⚡ FAST: "..(fast and "ON" or "OFF")
end)
