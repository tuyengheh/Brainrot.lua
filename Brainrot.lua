local Players = game:GetService("Players")
local player = Players.LocalPlayer

--------------------------------------------------
-- ⚙️ LIST BRAINROT HIẾM (bạn thêm vào đây)
local rareList = {
    "Garama and Madundung",
    "Ketchuru and Musturu",
    "La Secret Combinasion",
    "Lavadorito Spinito",
    "Tang Tang Keletang",
    "Tictac Sahur",
    "Spaghetti Tualetti",
    "Eviledon",
    "Los Spaghettis",
    "Spooky and Pumpky",
    "67",
    "Esok Sekolah",
    "La Grande Combinasion",
    "Strawberry Elephant",
    "Meowl",
    "Skibidi Toilet",
    "Cigno Fulgoro"
}

--------------------------------------------------
-- 🎯 CHECK NAME TRONG LIST
local function isRare(name)
    for _,v in pairs(rareList) do
        if string.lower(name) == string.lower(v) then
            return true
        end
    end
    return false
end

--------------------------------------------------
-- ✨ ESP FUNCTION
local function createESP(obj, isRareObj)
    if not obj or not obj:IsA("Model") then return end

    local part = obj:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    -- 🔥 GLOW
    local hl = Instance.new("Highlight")
    hl.Adornee = obj
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0

    if isRareObj then
        hl.FillColor = Color3.fromRGB(255, 0, 0) -- đỏ = hiếm
    else
        hl.FillColor = Color3.fromRGB(0, 170, 255) -- xanh thường
    end

    hl.Parent = obj

    -- 🏷️ NAME TAG
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0,100,0,40)
    bill.AlwaysOnTop = true
    bill.Adornee = part
    bill.StudsOffset = Vector3.new(0,3,0)

    local text = Instance.new("TextLabel", bill)
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Text = obj.Name
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold

    if isRareObj then
        text.TextColor3 = Color3.new(1,0,0)
    else
        text.TextColor3 = Color3.new(1,1,1)
    end

    bill.Parent = obj
end

--------------------------------------------------
-- 🔍 SCAN
local function scanBrainrot()
    print("🔍 Đang scan...")

    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name

            if string.find(string.lower(name),"brain") 
            or string.find(string.lower(name),"pet") then

                local rare = isRare(name)

                createESP(obj, rare)

                if rare then
                    warn("🔥 FOUND RARE:", name)
                end
            end
        end
    end
end

--------------------------------------------------
-- ▶️ CHẠY
scanBrainrot()
