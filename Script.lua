# Brainrot.lua 
   -- GUI Setup (ScreenGui + 2 Buttons)
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))

-- Nút đổi server cực mới
local ChangeServerButton = Instance.new("TextButton", ScreenGui)
ChangeServerButton.Size = UDim2.new(0, 200, 0, 50)
ChangeServerButton.Position = UDim2.new(0, 50, 0, 50)
ChangeServerButton.Text = "Đổi Server Mới"

-- Nút check all pet
local CheckPetButton = Instance.new("TextButton", ScreenGui)
CheckPetButton.Size = UDim2.new(0, 200, 0, 50)
CheckPetButton.Position = UDim2.new(0, 50, 0, 120)
CheckPetButton.Text = "Check All Pet"

-- Function đổi server
ChangeServerButton.MouseButton1Click:Connect(function()
    -- Lấy ID game hiện tại
    local PlaceID = game.PlaceId
    local JobId
    local Servers = {}
    
    -- Gọi API Roblox lấy server list
    local Success, Response = pcall(function()
        return HttpService:GetAsync("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")
    end)

    if Success then
        local Data = HttpService:JSONDecode(Response)
        for _, v in pairs(Data.data) do
            if v.playing < v.maxPlayers then
                table.insert(Servers, v.id)
            end
        end
    end

    -- Chọn server ngẫu nhiên từ list còn slot
    if #Servers > 0 then
        JobId = Servers[math.random(1,#Servers)]
        TeleportService:TeleportToPlaceInstance(PlaceID, JobId, LocalPlayer)
    else
        warn("Không tìm được server trống!")
    end
end)

-- Function check pet trong server
CheckPetButton.MouseButton1Click:Connect(function()
    local PetList = {} -- lưu pet hiện có
    -- Giả sử mỗi pet là child của workspace.Pets
    if workspace:FindFirstChild("Pets") then
        for _, pet in pairs(workspace.Pets:GetChildren()) do
            table.insert(PetList, pet.Name)
        end
    end

    if #PetList > 0 then
        print("Pet hiện có trong server: "..table.concat(PetList, ", "))
    else
        print("Không tìm thấy pet nào trong server này.")
    end
end)
