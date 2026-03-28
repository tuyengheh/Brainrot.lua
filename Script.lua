# Brainrot.lua 
  local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlaceID = game.PlaceId

-- 🔥 DANH SÁCH PET (giữ nguyên)
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

-- 🔥 THÊM: DATA m/s (KHÔNG ĐỤNG CODE CŨ)
local PET_M = {
    ["garama and madundung"] = 50,
    ["tictac sahur"] = 37.5,
    ["lavadorito spinito"] = 60,
    ["la secret combinasion"] = 125,
    ["ketchuru and musturu"] = 42.5,
    ["spaghetti tualetti"] = 60,
    ["eviledon"] = 300,
    ["spooky and pumpky"] = 45,
    ["bacuru and egguru"] = 55,
    ["cooki and milki"] = 35,
    ["ketupat kepat"] = 40,
    ["griffin"] = 400,
    ["hydra"] = 300,
    ["dragon"] = 300,
    ["skibidi"] = 330
}

-- UI (giữ nguyên)
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,140)
frame.Position = UDim2.new(0.35,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,40)
status.Text = "Sẵn sàng"
status.TextColor3 = Color3.new(1,1,1)
status.BackgroundTransparency = 1

-- 🔊 THÊM: SOUND
local sound = Instance.new("Sound", game.Workspace)
sound.SoundId = "rbxassetid://9118823104"
sound.Volume = 3

-- BUTTON (giữ nguyên)
local rollBtn = Instance.new("TextButton", frame)
rollBtn.Size = UDim2.new(1,-10,0,40)
rollBtn.Position = UDim2.new(0,5,0,50)
rollBtn.Text = "🔁 ROLL SERVER"
rollBtn.BackgroundColor3 = Color3.fromRGB(50,150,255)

-- 🔥 SỬA: check pet (THÊM lọc ≥50m)
local function HasPet()
    for _,plr in pairs(Players:GetPlayers()) do
        for _,v in pairs(plr:GetDescendants()) do
            local name = string.lower(v.Name)

            for _,pet in pairs(PET_LIST) do
                if string.find(name, pet) then
                    local m = PET_M[pet]

                    -- 🎯 chỉ lấy ≥50m
                    if m and m >= 50 then
                        return true, plr.Name, pet, m
                    end
                end
            end
        end
    end
    return false
end

-- hop server (giữ nguyên)
local function ServerHop()
    local success, req = pcall(function()
        return Http:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)

    if not success or not req or not req.data then
        status.Text = "❌ Lỗi lấy server → bấm lại"
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

-- CLICK (chỉ thêm sound + hiển thị m)
rollBtn.MouseButton1Click:Connect(function()
    status.Text = "🔍 Đang check..."

    local ok, name, pet, m = HasPet()

    if ok then
        status.Text = "🔥 Có pet: "..pet.." ("..m.."m) - "..name

        -- 🔊 âm thanh
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
