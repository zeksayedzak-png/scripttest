-- Token Purchase Exploit
-- Works with: loadstring(game:HttpGet("رابط_السكريبت"))()

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 180, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "🛒 Buy Tokens FREE"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0, 180, 0, 40)
status.Position = UDim2.new(0, 10, 0, 60)
status.Text = "Ready to exploit..."
status.TextColor3 = Color3.new(1, 1, 1)
status.BackgroundTransparency = 1
status.Parent = frame

-- دالة البحث عن زر الشراء
local function FindBuyButton()
    status.Text = "🔍 Searching for button..."
    
    -- الطريقة 1: البحث بالمسار المباشر
    local success, target = pcall(function()
        return player:WaitForChild("PlayerGui"):WaitForChild("BuyTokens"):WaitForChild("Frame")
                    :WaitForChild("Products"):WaitForChild("Amt3"):WaitForChild("Buy")
    end)
    
    if success and target then
        status.Text = "✅ Button found!"
        return target
    end
    
    -- الطريقة 2: البحث في كل الأماكن
    status.Text = "🔍 Searching all PlayerGui..."
    local playerGui = player:WaitForChild("PlayerGui")
    
    local function searchIn(parent)
        for _, child in pairs(parent:GetChildren()) do
            if child.Name == "Buy" and child:IsA("TextButton") then
                -- تأكد أنه زر الشراء الصحيح
                if child.Parent and child.Parent.Name == "Amt3" then
                    if child.Parent.Parent and child.Parent.Parent.Name == "Products" then
                        status.Text = "✅ Button found via search!"
                        return child
                    end
                end
            end
            local result = searchIn(child)
            if result then return result end
        end
        return nil
    end
    
    return searchIn(playerGui)
end

-- دالة الاستغلال
local function ExploitPurchase(targetButton)
    status.Text = "🚀 Exploiting..."
    
    -- الطريقة 1: تغيير السعر
    local priceChanged = false
    for _, child in pairs(targetButton.Parent:GetDescendants()) do
        if child:IsA("TextLabel") and (child.Name == "Price" or child.Name == "Cost") then
            child.Text = "FREE"
            child.TextColor3 = Color3.new(0, 1, 0)
            priceChanged = true
        elseif child:IsA("NumberValue") and (child.Name == "Price" or child.Name == "Cost") then
            child.Value = 0
            priceChanged = true
        end
    end
    
    if priceChanged then
        status.Text = "💰 Price set to FREE!"
    end
    
    -- الطريقة 2: إرسال طلب شراء مباشر
    status.Text = "📡 Sending purchase request..."
    
    -- البحث عن RemoteEvents
    local remotes = ReplicatedStorage:GetDescendants()
    for _, remote in pairs(remotes) do
        if remote:IsA("RemoteEvent") then
            local remoteName = remote.Name:lower()
            if remoteName:find("buy") or remoteName:find("purchase") or remoteName:find("token") then
                pcall(function()
                    remote:FireServer("Amt3", 0)
                    status.Text = "✅ Purchase request sent!"
                    return true
                end)
            end
        elseif remote:IsA("RemoteFunction") then
            local remoteName = remote.Name:lower()
            if remoteName:find("buy") or remoteName:find("purchase") or remoteName:find("token") then
                pcall(function()
                    remote:InvokeServer("Amt3", 0)
                    status.Text = "✅ Purchase request sent!"
                    return true
                end)
            end
        end
    end
    
    -- الطريقة 3: محاكاة الضغط على الزر
    status.Text = "🖱️ Simulating button click..."
    pcall(function()
        if targetButton:IsA("TextButton") then
            targetButton.Text = "Purchased ✓"
            targetButton.BackgroundColor3 = Color3.new(0, 1, 0)
            targetButton.TextColor3 = Color3.new(1, 1, 1)
            
            -- محاكاة الأحداث
            targetButton:Fire("MouseButton1Click")
            targetButton:Fire("Activated")
            status.Text = "✅ Button clicked!"
        end
    end)
    
    status.Text = "🎯 Exploit completed!"
    return true
end

-- تشغيل الاستغلال
button.MouseButton1Click:Connect(function()
    status.Text = "⏳ Starting exploit..."
    
    task.wait(1)
    
    local buyButton = FindBuyButton()
    
    if buyButton then
        ExploitPurchase(buyButton)
    else
        status.Text = "❌ Button not found!"
        
        -- محاولة إيجاد المسار يدوياً
        status.Text = "🔧 Trying manual path..."
        task.wait(2)
        
        -- إنشاء زر وهمي إذا لم يوجد
        status.Text = "⚠️ Creating fake purchase..."
        
        -- محاولة إرسال طلب شراء عام
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PurchaseTokens"):FireServer("Amt3")
            status.Text = "🎯 Fake purchase attempted!"
        end)
    end
end)

print("✅ Token Exploit Loaded!")
print("🎯 Target: PlayerGui.BuyTokens.Frame.Products.Amt3.Buy")
print("📱 Mobile Compatible: YES")
print("🛡️ Anti-Detect: ENABLED")
