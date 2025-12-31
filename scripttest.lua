-- 🚀 Advanced Mobile Purchase
local player = game.Players.LocalPlayer

local function buyGamepass(id)
    -- الطريقة 1: Direct Purchase
    pcall(function()
        game:GetService("MarketplaceService"):PromptProductPurchase(player, id)
    end)
    
    -- الطريقة 2: RemoteEvents
    for _, remote in pairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            pcall(function()
                remote:FireServer(id)
                remote:FireServer({gamepassId = id})
            end)
        end
    end
    
    return "Purchase attempted for ID: " .. id
end

-- الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.9, 0, 0.25, 0)
frame.Position = UDim2.new(0.05, 0, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

local input = Instance.new("TextBox")
input.PlaceholderText = "Gamepass ID"
input.Size = UDim2.new(0.8, 0, 0.3, 0)
input.Position = UDim2.new(0.1, 0, 0.1, 0)

local buyBtn = Instance.new("TextButton")
buyBtn.Text = "⚡ QUICK BUY"
buyBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
buyBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
buyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)

local status = Instance.new("TextLabel")
status.Text = "Ready"
status.Size = UDim2.new(0.8, 0, 0.2, 0)
status.Position = UDim2.new(0.1, 0, 0.8, 0)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1, 1, 1)

-- Events
buyBtn.MouseButton1Click:Connect(function()
    local id = tonumber(input.Text)
    if id then
        status.Text = "Buying..."
        status.TextColor3 = Color3.new(1, 1, 0)
        
        local result = buyGamepass(id)
        status.Text = result
        status.TextColor3 = Color3.new(0, 1, 0)
    end
end)

-- التجميع
input.Parent = frame
buyBtn.Parent = frame
status.Parent = frame
frame.Parent = screenGui

print("🎯 Mobile Purchase Loaded!")
print("🔧 Enter ID and press QUICK BUY")
