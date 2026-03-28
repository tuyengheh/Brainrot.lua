local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlaceID = game.PlaceId

-- 🔥 lowercase hết
local KEYWORDS = {
    "secret",
    "griffin",
    "hydra",
    "dragon",
    "skibidi",
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
    "ketupat kepat"
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
                    return true, plr.Name, key
                end
            end
        end
    end
    return false
end

-- hop có check lỗi
local function ServerHop()
    local success, req = pcall(function()
        return Http:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)

    if success and req and req.data then
        for _,v in pairs(req.data) do
            if v.playing < v.maxPlayers then
                text.Text = "🔁 Đang chuyển server..."
                TeleportService:TeleportToPlaceInstance(PlaceID, v.id)
                return
            end
        end

        text.Text = "⚠️ Server nào cũng full → bấm lại"
    else
        text.Text = "❌ Lỗi lấy server → thử lại"
    end
end

-- nút
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,300,0,50)
btn.Position = UDim2.new(0.35,0,0.5,0)
btn.Text = "🔁 Kiếm SECRET"
btn.BackgroundColor3 = Color3.fromRGB(50,150,255)

btn.MouseButton1Click:Connect(function()
    text.Text = "🔍 Đang check..."

    local ok, name, pet = HasSecret()

    if ok then
        text.Text = "🔥 Có SECRET: "..name.." ("..pet..")"
    else
        text.Text = "❌ Không có → chuyển..."
        task.wait(1)
        ServerHop()
    end
end)
