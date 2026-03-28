# Brainrot.lua 
-         --// SERVICES
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

--------------------------------------------------
-- 🎨 GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 140)
frame.Position = UDim2.new(0.5, -130, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,15)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "VIP Server Finder"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- DRAG
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--------------------------------------------------
-- BUTTON
local function createBtn(text,y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.8,0,0,40)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(80,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

local vipBtn = createBtn("Tìm Server VIP 🔥", 50)

--------------------------------------------------
-- 🔥 VIP SERVER (FIX KHÔNG TREO)
local searching = false

local function findVIPServer()
    local placeId = game.PlaceId

    local success, result = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100")
    end)

    if success then
        local data = HttpService:JSONDecode(result)

        local fallbackServer = nil

        for _,v in pairs(data.data) do
            -- 🎯 ưu tiên gần full
            if v.playing >= (v.maxPlayers - 2) and v.playing < v.maxPlayers then
                print("🔥 VIP SERVER:", v.playing.."/"..v.maxPlayers)
                TeleportService:TeleportToPlaceInstance(placeId, v.id, player)
                return
            end

            -- lưu server dự phòng
            if not fallbackServer then
                fallbackServer = v
            end
        end

        -- ⚠️ không có server đẹp → vẫn vào
        if fallbackServer then
            print("⚠️ Không có VIP → vào server:", fallbackServer.playing.."/"..fallbackServer.maxPlayers)
            TeleportService:TeleportToPlaceInstance(placeId, fallbackServer.id, player)
            return
        end
    end

    -- ❌ fallback cuối
    print("❌ Lỗi → vào random")
    TeleportService:Teleport(placeId, player)
end

--------------------------------------------------
-- BUTTON CLICK
vipBtn.MouseButton1Click:Connect(function()
    vipBtn.Text = "Đang tìm... 🔍"
    findVIPServer()
end)
