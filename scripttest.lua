-- 📱 Mobile Gamepass Purchase
-- loadstring(game:HttpGet("رابط"))()

local player = game.Players.LocalPlayer

-- 📝 مربع إدخال
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimplePurchase"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.8, 0, 0.2, 0)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

local input = Instance.new("TextBox")
input.PlaceholderText = "Enter Gamepass ID"
input.Size = UDim2.new(0.6, 0, 0.4, 0)
input.Position = UDim2.new(0.2, 0, 0.1, 0)
input.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
input.TextColor3 = Color3.new(1, 1, 1)

local button = Instance.new("TextButton")
button.Text = "🛒 BUY"
button.Size = UDim2.new(0.6, 0, 0.4, 0)
button.Position = UDim2.new(0.2, 0, 0.55, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
button.TextColor3 = Color3.new(1, 1, 1)

-- التجميع
input.Parent = frame
button.Parent = frame
frame.Parent = screenGui

-- 🎯 دالة الشراء المباشر
button.MouseButton1Click:Connect(function()
    local gamepassId = tonumber(input.Text)
    
    if gamepassId then
        button.Text = "🔄 PROCESSING..."
        button.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        
        pcall(function()
            game:GetService("MarketplaceService"):PromptProductPurchase(player, gamepassId)
            button.Text = "✅ SENT!"
            button.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            
            wait(1)
            button.Text = "🛒 BUY"
            button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        end)
    else
        button.Text = "❌ INVALID ID"
        button.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        
        wait(1)
        button.Text = "🛒 BUY"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)

print("📱 Mobile Purchase Ready!")
print("🎯 Enter Gamepass ID and press BUY")
