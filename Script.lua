# Brainrot.lua 
    --// SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer

--------------------------------------------------
-- ⚙️ LIST BẠN GỬI (OK RỒI)
local rareList = {
    "Garama and Madundung","Ketchuru and Musturu","La Secret Combinasion",
    "Lavadorito Spinito","Tang Tang Keletang","Tictac Sahur",
    "Spaghetti Tualetti","Eviledon","Los Spaghettis","Spooky and Pumpky",
    "67","Esok Sekolah","La Grande Combinasion","Strawberry Elephant",
    "Meowl","Skibidi Toilet","Cigno Fulgoro"
}

--------------------------------------------------
-- 🎯 CHECK RARE (chuẩn hơn)
local function isRare(name)
    for _,v in pairs(rareList) do
        if string.lower(name):find(string.lower(v)) then
            return true
        end
    end
    return false
end

--------------------------------------------------
-- 📦 TRÁNH ESP TRÙNG
local espCache = {}

--------------------------------------------------
-- ✨ ESP
local function createESP(obj)
    if espCache[obj] then return end
    espCache[obj] = true

    local part = obj:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    local rare = isRare(obj.Name)

    -- 🔥 HIGHLIGHT
    local hl = Instance.new("Highlight")
    hl.Adornee = obj
    hl.FillTransparency = 0.4
    hl.OutlineTransparency = 0

    if rare then
        hl.FillColor = Color3.fromRGB(255, 50, 50)
    else
        hl.FillColor = Color3.fromRGB(0, 170, 255)
    end

    hl.Parent = obj

    -- 🏷️ NAME TAG
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0,120,0,40)
    bill.AlwaysOnTop = true
    bill.Adornee = part
    bill.StudsOffset = Vector3.new(0,3,0)

    local text = Instance.new("TextLabel", bill)
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Text = obj.Name
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold

    if rare then
        text.TextColor3 = Color3.fromRGB(255,0,0)
        warn("🔥 FOUND RARE:", obj.Name)
    else
        text.TextColor3 = Color3.new(1,1,1)
    end

    bill.Parent = obj
end

--------------------------------------------------
-- 🔍 SCAN CHUẨN
local function scan()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            -- chỉ cần model có part là check luôn
            if obj:FindFirstChildWhichIsA("BasePart") then
                createESP(obj)
            end
        end
    end
end

--------------------------------------------------
-- 🔁 AUTO SCAN LIÊN TỤC
task.spawn(function()
    while true do
        task.wait(3)
        scan()
    end
end)
