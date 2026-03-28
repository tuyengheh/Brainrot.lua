local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlaceID = game.PlaceId

-- CONFIG
local MIN_M = 50
local MAX_M = 800

-- PET DATA
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

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,140)
frame.Position = UDim2.new(0.35,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,40)
status.Text = "Sẵn sàng roll server"
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1

-- BUTTON ROLL
local rollBtn = Instance.new("TextButton", frame)
rollBtn.Size = UDim2.new(1,-10,0,40)
rollBtn.Position = UDim2.new(0,5,0,50)
rollBtn.Text = "🔁 ROLL SERVER"
rollBtn.BackgroundColor3 = Color3.fromRGB(50,150,255)
rollBtn.TextColor3 = Color3.new(1,1,1)

-- check pet
local function HasGoodPet()
    for _,plr in pairs(Players:GetPlayers()) do
        for _,v in pairs(plr:GetDescendants()) do
            local name = string.lower(v.Name)

            for pet, val in pairs(PET_DATA) do
                if string.find(name, pet) then
                    if val >= MIN_M and val <= MAX_M then
                        return true, plr.Name, pet, val
                    end
                end
            end
        end
    end
    return false
end

-- server hop (lọc server không full)
local function ServerHop()
    local success, req = pcall(function()
        return Http:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)

    if success and req and req.data then
        for _,v in pairs(req.data) do
            if v.playing < v.maxPlayers then
                TeleportService:TeleportToPlaceInstance(PlaceID, v.id)
                return
            end
        end
    end

    status.Text = "❌ Không tìm được server (bấm lại)"
end

-- BUTTON CLICK
rollBtn.MouseButton1Click:Connect(function()
    status.Text = "🔍 Đang check server..."

    local ok, name, pet, val = HasGoodPet()

    if ok then
        status.Text = "🔥 Server ngon: "..pet.." ("..val.."m)"
    else
        status.Text = "❌ Không có → chuyển..."
        task.wait(0.5)
        ServerHop()
    end
end)
