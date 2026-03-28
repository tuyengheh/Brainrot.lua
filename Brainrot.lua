local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- PET DATA (m)
local PET_DATA = {
    ["griffin"] = 400,
    ["hydra dragon cannelloni"] = 300,
    ["dragon gingerini"] = 300,
    ["skibidi toilet"] = 330,
    ["garama"] = 50,
    ["madundung"] = 50,
    ["la secret combination"] = 125,
    ["ketchuru"] = 42.5,
    ["musturu"] = 42.5,
    ["tictac sahur"] = 37.5,
    ["tang tang keletang"] = 33.5
}

local selectedPet = "all"
local foundTarget = nil

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,320,0,260)
frame.Position = UDim2.new(0.35,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🔥 LIVE PET SCANNER"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.BackgroundTransparency = 1

local list = Instance.new("TextLabel", frame)
list.Size = UDim2.new(1,-10,0,170)
list.Position = UDim2.new(0,5,0,35)
list.Text = "Đang quét..."
list.TextWrapped = true
list.TextYAlignment = Enum.TextYAlignment.Top
list.TextColor3 = Color3.new(1,1,1)
list.BackgroundTransparency = 1

-- JOIN BUTTON
local joinBtn = Instance.new("TextButton", frame)
joinBtn.Size = UDim2.new(1,-10,0,40)
joinBtn.Position = UDim2.new(0,5,0,210)
joinBtn.Text = "JOIN (Ở lại server này)"
joinBtn.BackgroundColor3 = Color3.fromRGB(50,200,100)
joinBtn.Visible = false

-- format
local function formatM(v)
    return v.."m"
end

-- scan realtime
local function Scan()
    local text = ""
    foundTarget = nil

    for _,plr in pairs(Players:GetPlayers()) do
        for _,v in pairs(plr:GetDescendants()) do
            local name = string.lower(v.Name)

            for pet, val in pairs(PET_DATA) do
                if string.find(name, pet) then
                    text = text.."🔹 "..plr.Name.." → "..pet.." ("..formatM(val)..")\n"

                    if selectedPet == "all" or string.find(pet, selectedPet) then
                        foundTarget = plr
                    end
                end
            end
        end
    end

    if text == "" then
        text = "❌ Server cùi (không có pet ngon)"
        joinBtn.Visible = false
    else
        joinBtn.Visible = true
    end

    list.Text = text
end

-- join (giữ server + focus)
joinBtn.MouseButton1Click:Connect(function()
    if foundTarget and foundTarget.Character then
        local hrp = foundTarget.Character:FindFirstChild("HumanoidRootPart")
        local my = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if hrp and my then
            my.CFrame = hrp.CFrame + Vector3.new(2,0,0)
        end
    end
end)

-- loop realtime
task.spawn(function()
    while true do
        Scan()
        task.wait(2)
    end
end)
