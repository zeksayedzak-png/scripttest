-- ⚡ Rapid Fire Attack - Mobile Optimized
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer
local isAttacking = false
local requestCount = 0

-- 📱 واجهة للهاتف
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RapidFire"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 0.4, 0)  -- نصف الشاشة
mainFrame.Position = UDim2.new(0, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2

-- 🎯 العنوان
local title = Instance.new("TextLabel")
title.Text = "⚡ RAPID FIRE ATTACK"
title.Size = UDim2.new(1, 0, 0.15, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold

-- 🔥 زر التشغيل
local startBtn = Instance.new("TextButton")
startBtn.Text = "🚀 START ATTACK"
startBtn.Size = UDim2.new(0.9, 0, 0.25, 0)
startBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.SourceSansBold
startBtn.TextSize = 18

-- ⏹️ زر الإيقاف
local stopBtn = Instance.new("TextButton")
stopBtn.Text = "⏹️ STOP"
stopBtn.Size = UDim2.new(0.9, 0, 0.25, 0)
stopBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 18

-- 📊 العداد
local counter = Instance.new("TextLabel")
counter.Text = "Requests: 0"
counter.Size = UDim2.new(1, 0, 0.15, 0)
counter.Position = UDim2.new(0, 0, 0.8, 0)
counter.BackgroundTransparency = 1
counter.TextColor3 = Color3.new(0, 1, 1)
counter.Font = Enum.Font.SourceSansBold
counter.TextSize = 16

-- التجميع
title.Parent = mainFrame
startBtn.Parent = mainFrame
stopBtn.Parent = mainFrame
counter.Parent = mainFrame
mainFrame.Parent = screenGui
screenGui.Parent = player.PlayerGui

-- 🚀 دالة الهجوم السريع
local function rapidAttack()
    while isAttacking do
        -- البحث عن RemoteEvents
        local remotes = {}
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                table.insert(remotes, obj)
            end
        end
        
        -- إرسال طلبات سريعة
        for _, remote in ipairs(remotes) do
            if not isAttacking then break end
            
            task.spawn(function()
                -- محاولات مختلفة
                pcall(function()
                    remote:FireServer("Amt3")
                    requestCount = requestCount + 1
                end)
                
                pcall(function()
                    remote:FireServer({id = "Amt3", buy = true})
                    requestCount = requestCount + 1
                end)
                
                pcall(function()
                    remote:FireServer(3)  -- عدد التوكنز
                    requestCount = requestCount + 1
                end)
            end)
        end
        
        -- تحديث العداد
        counter.Text = "Requests: " .. requestCount
        
        -- تأخير بسيط جداً
        task.wait(0.01)  -- 10 ميلي ثانية
    end
end

-- 🎮 أحداث الأزرار
startBtn.MouseButton1Click:Connect(function()
    if not isAttacking then
        isAttacking = true
        requestCount = 0
        startBtn.Text = "⚡ ATTACKING..."
        startBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        
        print("🚀 Rapid attack started!")
        
        task.spawn(rapidAttack)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    isAttacking = false
    startBtn.Text = "🚀 START ATTACK"
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    
    print("⏹️ Attack stopped. Total requests: " .. requestCount)
end)

-- 📢 الإعلان
print([[
    
    ╔══════════════════════════════╗
    ║      ⚡ RAPID FIRE v1.0      ║
    ║   Mobile Optimized          ║
    ╚══════════════════════════════╝
    
    📱 How to use:
    1. Press START ATTACK
    2. Watch request counter
    3. Press STOP when done
    
    ⚡ Attack speed: 100+ requests/sec
    🎯 Target: Amt3 Token
    
]])
