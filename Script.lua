# Brainrot.lua 
--// GUI (GIỮ NGUYÊN)
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163,255,137)
Frame.Position = UDim2.new(0.1,0,0.3,0)
Frame.Size = UDim2.new(0,190,0,57)
Frame.Active = true
Frame.Draggable = true

up.Parent = Frame
up.Size = UDim2.new(0,44,0,28)
up.Text = "UP"

down.Parent = Frame
down.Position = UDim2.new(0,0,0.5,0)
down.Size = UDim2.new(0,44,0,28)
down.Text = "DOWN"

onof.Parent = Frame
onof.Position = UDim2.new(0.7,0,0.5,0)
onof.Size = UDim2.new(0,56,0,28)
onof.Text = "FLY"

TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(0,100,0,28)
TextLabel.Position = UDim2.new(0.45,0,0,0)
TextLabel.Text = "FLY GUI PRO"
TextLabel.TextScaled = true

plus.Parent = Frame
plus.Position = UDim2.new(0.23,0,0,0)
plus.Size = UDim2.new(0,45,0,28)
plus.Text = "+"

mine.Parent = Frame
mine.Position = UDim2.new(0.23,0,0.5,0)
mine.Size = UDim2.new(0,45,0,28)
mine.Text = "-"

speed.Parent = Frame
speed.Position = UDim2.new(0.47,0,0.5,0)
speed.Size = UDim2.new(0,44,0,28)
speed.Text = "1"

--------------------------------------------------
-- 🔥 BIẾN
local player = game.Players.LocalPlayer
local speaker = player
local speeds = 1
local nowe = false
local savedPos = nil

--------------------------------------------------
-- 🔥 BỎ PET KHÔNG MUỐN
local ignoreList = {"Galaxy","Lava"}

local function isIgnored(name)
	name = string.lower(name)
	for _,v in pairs(ignoreList) do
		if string.find(name,string.lower(v)) then
			return true
		end
	end
	return false
end

--------------------------------------------------
-- 🚀 FLY + TP VỀ VỊ TRÍ
onof.MouseButton1Down:Connect(function()

	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if not nowe then
		nowe = true

		-- lưu vị trí
		savedPos = hrp.CFrame

		-- bật fly (fake đơn giản)
		hrp.Velocity = Vector3.new(0,50,0)

		task.wait(0.2)

		-- bay về vị trí cũ
		if savedPos then
			for i=1,5 do
				hrp.CFrame = hrp.CFrame:Lerp(savedPos,0.5)
				task.wait(0.05)
			end
			hrp.CFrame = savedPos
		end

	else
		nowe = false
	end

end)

--------------------------------------------------
-- 🎮 SPEED
plus.MouseButton1Click:Connect(function()
	speeds = speeds + 1
	speed.Text = tostring(speeds)
end)

mine.MouseButton1Click:Connect(function()
	if speeds > 1 then
		speeds = speeds - 1
		speed.Text = tostring(speeds)
	end
end)

--------------------------------------------------
-- ⌨️ BẤM K ẨN/HIỆN GUI
local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.K then
		main.Enabled = not main.Enabled
	end
end)
