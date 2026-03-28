-- SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlaceID = game.PlaceId

-- 🔥 KEYWORD SECRET
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
text.Size = UDim2.new(0,320,0,60)
text.Position = UDim2.new(0.35,0,0.4,0)
text.BackgroundColor3 = Color3.fromRGB(20,20,20)
text.TextColor3 = Color3.new(1,1,1)
text.Text = "🔄 AUTO ROLL SECRET..."

-- 🔊 SOUND
local sound = Instance.new("Sound", game.Workspace)
sound.SoundId = "rbxassetid://9118823104"
sound.Volume = 3

-- 🔁 KEEP SCRIPT SAU TELEPORT
local function Queue()
    local code = [[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tuyengheh/Brainrot.lua/main/Brainrot.lua"))()
    ]]

    if syn and syn.queue_on_teleport then
        syn.queue_on_teleport(code)
    elseif queue_on_teleport then
        queue_on_teleport(code)
    end
end

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

-- hop
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
                
                Queue() -- 🔥 giữ script
                
                TeleportService:TeleportToPlaceInstance(PlaceID, v.id)
                return true
            end
        end

        text.Text = "⚠️ Server full hết → thử lại..."
    else
        text.Text = "❌ Lỗi lấy server → retry..."
    end

    return false
end

-- LOOP AUTO
task.spawn(function()
    while true do
        text.Text = "🔍 Đang kiểm tra..."

        local ok, name, pet = HasSecret()

        if ok then
            text.Text = "🔥 TÌM THẤY SECRET: "..name.." ("..pet..")"

            -- 🔊 phát âm
            for i = 1,3 do
                sound:Play()
                task.wait(0.3)
            end

            return
        else
            text.Text = "❌ Không có → roll tiếp..."
            task.wait(0.5)

            local hopped = ServerHop()

            if not hopped then
                task.wait(1)
            end
        end

        task.wait(1)
    end
end)
