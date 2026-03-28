local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- LIST PET HIẾM
local rareList = {
    "Garama and Madundung","Ketchuru and Musturu","La Secret Combinasion",
    "Lavadorito Spinito","Tang Tang Keletang","Tictac Sahur",
    "Spaghetti Tualetti","Eviledon","Los Spaghettis","Spooky and Pumpky",
    "67","Esok Sekolah","La Grande Combinasion","Strawberry Elephant",
    "Meowl","Skibidi Toilet","Cigno Fulgoro"
}

-- CHECK
local function isRare(name)
    for _,v in pairs(rareList) do
        if string.lower(name):find(string.lower(v)) then
            return true
        end
    end
    return false
end

-- SCAN SERVER HIỆN TẠI
local function foundRare()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            if isRare(obj.Name) then
                return true
            end
        end
    end
    return false
end

-- HOP TỐI ƯU (4-8 người)
local function hopSmart()
    local placeId = game.PlaceId

    local data = HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100")
    )

    for _,v in pairs(data.data) do
        if v.playing >= 4 and v.playing <= 8 then
            print("TRY:", v.playing.."/"..v.maxPlayers)
            TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
            break
        end
    end
end

-- MAIN LOOP
task.spawn(function()
    while true do
        task.wait(5)

        if foundRare() then
            warn("🔥 SERVER NGON - DỪNG")
            break
        else
            print("❌ Không có rare → hop tiếp")
            hopSmart()
            task.wait(8)
        end
    end
end)
