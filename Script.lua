# Brainrot.lua
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlaceID = game.PlaceId

local running = true

-- mốc cần tìm
local TARGET = 50

-- pet data (m)
local PET_DATA = {
    ["griffin"] = 400,
    ["hydra dragon cannelloni"] = 300,
    ["dragon gingerini"] = 300,
    ["skibidi toilet"] = 330,
    ["garama"] = 50,
    ["madundung"] = 50,
    ["la secret combination"] = 125,
    ["ketchuru"] = 42.5,
    ["musturu"] = 42.5,
    ["tictac sahur"] = 37.5,
    ["tang tang keletang"] = 33.5
}

-- UI đơn giản
local gui = Instance.new("ScreenGui", game.CoreGui)

local text = Instance.new("TextLabel", gui)
text.Size = UDim2.new(0,300,0,50)
text.Position = UDim2.new(0.35,0,0.4,0)
text.BackgroundColor3 = Color3.fromRGB(20,20,20)
text.TextColor3 = Color3.new(1,1,1)
text.Text = "🔍 Đang roll server..."

-- check pet >= 50m
local function HasGoodPet()
    for _,plr in pairs(Players:GetPlayers()) do
        for _,v in pairs(plr:GetDescendants()) do
            local name = string.lower(v.Name)

            for pet, val in pairs(PET_DATA) do
                if string.find(name, pet) then
                    if val >= TARGET then
                        return true, plr.Name, pet, val
                    end
                end
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
            break
        end
    end
end

-- loop
task.spawn(function()
    while running do
        local ok, name, pet, val = HasGoodPet()

        if ok then
            text.Text = "🔥 FOUND: "..name.." → "..pet.." ("..val.."m)"
            return
        else
            text.Text = "❌ Không có ≥50m → chuyển server..."
            task.wait(1)
            ServerHop()
            break
        end

        task.wait(2)
    end
end)
