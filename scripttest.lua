-- ============================================
-- STEALTH TOKEN PURCHASE - FILTERINGENABLED OFF
-- Mobile: loadstring(game:HttpGet(""))()
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
if not player then repeat task.wait() until Players.LocalPlayer player = Players.LocalPlayer end

repeat task.wait() until player:FindFirstChild("PlayerGui")

-- ⭐ هدفنا
local TARGET_PATH = player.Name .. ".PlayerGui.BuyTokens.Frame.Products.Amt3.Buy"

-- ⭐ البحث الذكي
local function FIND_BUY_BUTTON()
    print("🎯 TARGETING: Amt3 Token Purchase")
    
    -- المحاولة 1: المسار المباشر
    local success, target = pcall(function()
        local parts = TARGET_PATH:split(".")
        local current = game
        for _, part in ipairs(parts) do
            current = current:FindFirstChild(part) or current:WaitForChild(part, 1)
        end
        return current
    end)
    
    if success and target then
        print("✅ FOUND:", target:GetFullName())
        return target
    end
    
    -- المحاولة 2: البحث في Products
    local products = player.PlayerGui:FindFirstChild("BuyTokens", true)
    if products then
        products = products:FindFirstChild("Frame", true)
        if products then
            products = products:FindFirstChild("Products", true)
            if products then
                local amt3 = products:FindFirstChild("Amt3", true)
                if amt3 then
                    local btn = amt3:FindFirstChild("Buy", true)
                    if btn then
                        print("✅ FOUND IN PRODUCTS")
                        return btn
                    end
                end
            end
        end
    end
    
    -- المحاولة 3: البحث عن أي زر شراء
    for _, gui in pairs(player.PlayerGui:GetDescendants()) do
        if gui.Name == "Buy" and gui:IsA("TextButton") then
            print("✅ FOUND GENERIC BUY BUTTON")
            return gui
        end
    end
    
    return nil
end

-- ⭐ الاستغلال: FilteringEnabled = false
local function EXPLOIT_PURCHASE(targetButton)
    print("⚡ EXPLOITING FILTERINGENABLED OFF...")
    
    -- 1. إذا FilteringEnabled false، ممكن نعدل الخصائص مباشرة
    local success = false
    
    -- 2. محاولة تعديل سعر المنتج (لو كان في الكلاينت)
    if targetButton.Parent then
        local priceLabel = targetButton.Parent:FindFirstChild("Price") 
                        or targetButton.Parent:FindFirstChild("Cost")
        
        if priceLabel then
            pcall(function()
                priceLabel.Text = "FREE"
                priceLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                print("💰 SET PRICE TO FREE")
            end)
        end
    end
    
    -- 3. محاولة تغيير خاصية المنتج نفسه
    pcall(function()
        -- إذا كان فيه NumberValue للثمن
        for _, child in pairs(targetButton.Parent:GetDescendants()) do
            if child:IsA("NumberValue") and child.Name:find("Price") then
                child.Value = 0
                print("🎯 SET PRICE VALUE TO 0")
            end
        end
    end)
    
    -- 4. الضغط على الزر مباشرة
    pcall(function()
        if targetButton:IsA("TextButton") then
            targetButton.Text = "🛒 FREE"
            targetButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            
            -- الضغط
            targetButton:Fire("MouseButton1Click")
            targetButton:Fire("Activated")
            
            print("✅ TRIGGERED BUTTON CLICK")
            success = true
        end
    end)
    
    -- 5. إذا كان فيه RemoteEvents، نرسل طلب مجاني
    local remotes = game:GetService("ReplicatedStorage"):GetDescendants()
    for _, remote in pairs(remotes) do
        if remote:IsA("RemoteEvent") then
            pcall(function()
                remote:FireServer("BuyTokens", "Amt3", 0)
                remote:FireServer("Purchase", "Amt3", 0)
                print("📤 SENT FREE PURCHASE REQUEST")
                success = true
            end)
        end
    end
    
    return success
end

-- ⭐ واجهة التخفي في المنتصف
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TokenStealth"
screenGui.Parent = player.PlayerGui

local stealthFrame = Instance.new("Frame")
stealthFrame.Size = UDim2.new(0, 250, 0, 100)
stealthFrame.Position = UDim2.new(0.5, -125, 0.5, -50)
stealthFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
stealthFrame.BackgroundTransparency = 0.2
stealthFrame.Active = true
stealthFrame.Draggable = true
stealthFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.1, 0)
corner.Parent = stealthFrame

-- زر التنفيذ
local executeBtn = Instance.new("TextButton")
executeBtn.Text = "⚡ GET FREE TOKENS ⚡"
executeBtn.Size = UDim2.new(0.9, 0, 0, 60)
executeBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
executeBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
executeBtn.TextColor3 = Color3.new(1, 1, 1)
executeBtn.Font = Enum.Font.GothamBold
executeBtn.TextSize = 16
executeBtn.Parent = stealthFrame

-- حالة التنفيذ
local status = Instance.new("TextLabel")
status.Text = "Ready to exploit"
status.Size = UDim2.new(0.9, 0, 0, 20)
status.Position = UDim2.new(0.05, 0, 0.85, 0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
status.Font = Enum.Font.SourceSans
status.TextSize = 12
status.Parent = stealthFrame

-- حدث الزر
executeBtn.MouseButton1Click:Connect(function()
    executeBtn.Text = "🎯 EXPLOITING..."
    executeBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    
    task.spawn(function()
        -- البحث عن الزر
        local target = FIND_BUY_BUTTON()
        
        if target then
            -- الاستغلال
            local success = EXPLOIT_PURCHASE(target)
            
            if success then
                status.Text = "✅ SUCCESS - Tokens added"
                status.TextColor3 = Color3.fromRGB(0, 255, 0)
                executeBtn.Text = "✅ DONE"
                executeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            else
                status.Text = "❌ EXPLOIT FAILED"
                status.TextColor3 = Color3.fromRGB(255, 0, 0)
                executeBtn.Text = "❌ FAILED"
                executeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            end
        else
            status.Text = "❌ BUTTON NOT FOUND"
            status.TextColor3 = Color3.fromRGB(255, 0, 0)
            executeBtn.Text = "❌ NOT FOUND"
            executeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
        
        task.wait(2)
        executeBtn.Text = "⚡ GET FREE TOKENS ⚡"
        executeBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
        status.Text = "Ready to exploit"
        status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    end)
end)

print("\n" .. string.rep("=", 60))
print("⚡ FILTERINGENABLED OFF EXPLOIT LOADED")
print("🎯 TARGET: Amt3 Token Purchase")
print("📱 MOBILE: WORKING")
print("💥 Press the blue button to exploit")
print(string.rep("=", 60))

return "Token Exploit Active"
