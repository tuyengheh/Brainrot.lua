local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local PlaceID = game.PlaceId
local TARGET_SPEED = 50

-- UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.3,0,0.3,0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "Brainrot Finder"
Title.BackgroundColor3 = Color3.fromRGB(50,50,50)
Title.TextColor3 = Color3.new(1,1,1)

local Status = Instance.new("TextLabel", Frame)
Status.Size = UDim2.new(1,0,0,30)
Status.Position = UDim2.new(0,0,0,40)
Status.Text = "Status: Idle"
Status.TextColor3 = Color3.new(1,1,1)
Status.BackgroundTransparency = 1

local StartBtn = Instance.new("TextButton", Frame)
StartBtn.Size = UDim2.new(1,-20,0,30)
StartBtn.Position = UDim2.new(0,10,0,80)
StartBtn.Text = "Start Scan"

local JoinBtn = Instance.new("TextButton", Frame)
JoinBtn.Size = UDim2.new(1,-20,0,30)
JoinBtn.Position = UDim2.new(0,10,0,120)
JoinBtn.Text = "JOIN SERVER"
JoinBtn.Visible = false

-- check pet
local function HasGoodPet(player)
    local folders = {
        player:FindFirstChild("Leaderstats"),
        player:FindFirstChild("Data"),
        player:FindFirstChild("Pets"),
        player:FindFirstChild("Inventory")
    }

    for _,folder in pairs(folders) do
        if folder then
            for _,v in pairs(folder:GetDescendants()) do
                if v:IsA("NumberValue") and v.Value >= TARGET_SPEED then
                    return true
                end
            end
        end
    end
    return false
end

local foundServer = false

local function CheckServer()
    for _,plr in pairs(Players:GetPlayers()) do
        if HasGoodPet(plr) then
            Status.Text = "✅ Found: "..plr.Name
            foundServer = true
            JoinBtn.Visible = true
            return true
        end
    end
    return false
end

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

StartBtn.MouseButton1Click:Connect(function()
    Status.Text = "🔍 Scanning..."
    wait(2)

    if not CheckServer() then
        Status.Text = "❌ Not found → hopping..."
        wait(1)
        ServerHop()
    end
end)

JoinBtn.MouseButton1Click:Connect(function()
    Status.Text = "🔥 Stay this server!"
end)
