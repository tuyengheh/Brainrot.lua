-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- Change Server Button
local changeServerBtn = Instance.new("TextButton", screenGui)
changeServerBtn.Size = UDim2.new(0, 200, 0, 50)
changeServerBtn.Position = UDim2.new(0, 50, 0, 50)
changeServerBtn.Text = "Server Hop"

-- Check Pets Button
local checkPetsBtn = Instance.new("TextButton", screenGui)
checkPetsBtn.Size = UDim2.new(0, 200, 0, 50)
checkPetsBtn.Position = UDim2.new(0, 50, 0, 120)
checkPetsBtn.Text = "Check Brainrots"

-- Server Hop
changeServerBtn.MouseButton1Click:Connect(function()
    local placeId = game.PlaceId
    local success, response = pcall(function()
        return HttpService:GetAsync("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100")
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        local serverList = {}

        for _, server in ipairs(data.data) do
            if server.playing < server.maxPlayers then
                table.insert(serverList, server.id)
            end
        end

        if #serverList > 0 then
            local chosen = serverList[math.random(1, #serverList)]
            TeleportService:TeleportToPlaceInstance(placeId, chosen, player)
        else
            warn("No empty servers found!")
        end
    else
        warn("Failed getting server list!")
    end
end)

-- Check Brainrots
checkPetsBtn.MouseButton1Click:Connect(function()
    local found = {}

    -- Bạn chỉnh theo đúng nơi game lưu brainrots
    local brainrotFolder = workspace:FindFirstChild("BrainrotsFolder")
    if brainrotFolder then
        for _, obj in pairs(brainrotFolder:GetChildren()) do
            table.insert(found, obj.Name)
        end
    else
        print("Brainrot folder not found!")
    end

    if #found > 0 then
        print("Brainrots in server:", table.concat(found, ", "))
    else
        print("No brainrots found.")
    end
end)
