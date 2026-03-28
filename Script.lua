# Brainrot.lua 
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlaceID = game.PlaceId

-- từ khóa secret
local KEYWORDS = {
    "secret",
    "griffin",
    "hydra",
    "dragon",
    "skibidi",
    "Garama and Madundung",
    "Tictac Sahur",
    "Lavadorito Spinito",
    "La Secret Combinasion",
    "Ketchuru and Musturu",
    "Spaghetti Tualetti",
    "Eviledon",
    "Spooky and Pumpky",
    "Bacuru and Egguru",
    "Cooki and Milki",
    "Ketupat Kepat"
}

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)

local text = Instance.new("TextLabel", gui)
text.Size = UDim2.new(0,300,0,50)
text.Position = UDim2.new(0.35,0,0.4,0)
text.BackgroundColor3 = Color3.fromRGB(20,20,20)
text.TextColor3 = Color3.new(1,1,1)
text.Text = "🔍 Đang săn SECRET..."

-- check secret
local function HasSecret()
    for _,plr in pairs(Players:GetPlayers()) do
        for _,v in pairs(plr:GetDescendants()) do
            local name = string.lower(v.Name)

            for _,key in pairs(KEYWORDS) do
                if string.find(name, key) then
                    return true, plr.Name, name
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

-- nút roll
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,300,0,50)
btn.Position = UDim2.new(0.35,0,0.5,0)
btn.Text = "🔁 Kiếm SECRET"
btn.BackgroundColor3 = Color3.fromRGB(50,150,255)

btn.MouseButton1Click:Connect(function()
    text.Text = "🔍 Đang check..."

    local ok, name, pet = HasSecret()

    if ok then
        text.Text = "🔥 SECRET: "..name
    else
        text.Text = "❌ Không có → chuyển server"
        wait(1)
        ServerHop()
    end
end)
