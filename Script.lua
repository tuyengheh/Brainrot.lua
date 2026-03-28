# Brainrot.lua 
--// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

print("✅ Script started")

--------------------------------------------------
-- LIST PET HIẾM
local rareList = {
    "Garama and Madundung","Ketchuru and Musturu","La Secret Combinasion",
    "Lavadorito Spinito","Tang Tang Keletang","Tictac Sahur",
    "Spaghetti Tualetti","Eviledon","Los Spaghettis","Spooky and Pumpky",
    "67","Esok Sekolah","La Grande Combinasion","Strawberry Elephant",
    "Meowl","Skibidi Toilet","Cigno Fulgoro"
}

--------------------------------------------------
-- CHECK RARE
local function isRare(name)
    for _,v in pairs(rareList) do
        if string.lower(name):find(string.lower(v)) then
            return true
        end
    end
    return false
end

--------------------------------------------------
-- SCAN
local function foundRare()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            if isRare(obj.Name) then
                warn("🔥 FOUND:", obj.Name)
                return true
            end
        end
    end
    return false
end

--------------------------------------------------
-- HOP SMART (FIX)
local function hopSmart()
    local placeId = game.PlaceId

    local success, result = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100")
    end)

    if not success then
        warn("❌ HTTP FAIL → dùng hop thường")
        TeleportService:Teleport(placeId, player)
        return
    end

    local data = HttpService:JSONDecode(result)

    for _,v in pairs(data.data) do
        if v.playing >= 4 and v.playing <= 8 then
            print("🚀 TRY:", v.playing.."/"..v.maxPlayers)
            TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
            return
        end
    end

    warn("⚠️ Không có server phù hợp → hop random")
    TeleportService:Teleport(placeId, player)
end

--------------------------------------------------
-- MAIN
task.spawn(function()
    print("⏳ Đợi load game...")
    task.wait(6)

    while true do
        print("🔍 Đang scan...")

        if foundRare() then
            warn("🎉 SERVER NGON → DỪNG")
            break
        end

        print("❌ Không có rare → hop tiếp")
        hopSmart()

        task.wait(10)
    end
end)
