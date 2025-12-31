-- ⚡ Rapid Fire Attack - Mobile Optimized
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer
local isAttacking = false
local requestCount = 0
local currentSpeed = 0.01  -- السرعة الحالية

-- 📱 واجهة للهاتف
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RapidFire"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 0.5, 0)  -- زيادة الحجم
mainFrame.Position = UDim2.new(0, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2

-- 🎯 العنوان
local title = Instance.new("TextLabel")
title.Text = "⚡ RAPID FIRE ATTACK"
title.Size = UDim2.new(1, 0, 0.12, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold

-- 📝 مربع إدخال السرعة
local speedInput = Instance.new("TextBox")
speedInput.PlaceholderText = "Speed: 0.01 = fast, 1 = slow"
speedInput.Text = "0.01"  -- القيمة الافتراضية
speedInput.Size = UDim2.new(0.8, 0, 0.12, 0)
speedInput.Position = UDim2.new(0.1, 0, 0.15, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Font = Enum.Font.SourceSans
speedInput.TextSize = 14

-- 📋 تلميح السرعات
local speedHint = Instance.new("TextLabel")
speedHint.Text = "Fast: 0.01 | Normal: 0.1 | Slow: 1"
speedHint.Size = UDim2.new(0.8, 0, 0.08, 0)
speedHint.Position = UDim2.new(0.1, 0, 0.28, 0)
speedHint.BackgroundTransparency = 1
speedHint.TextColor3 = Color3.fromRGB(150, 150, 200)
speedHint.Font = Enum.Font.SourceSans
speedHint.TextSize = 12

-- 🔥 زر التشغيل
local startBtn = Instance.new("TextButton")
startBtn.Text = "🚀 START ATTACK"
startBtn.Size = UDim2.new(0.8, 0, 0.15, 0)
startBtn.Position = UDim2.new(0.1, 0, 0.38, 0)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.SourceSansBold
startBtn.TextSize = 16

-- ⏹️ زر الإيقاف
local stopBtn = Instance.new("TextButton")
stopBtn.Text = "⏹️ STOP ATTACK"
stopBtn.Size = UDim2.new(0.8, 0, 0.15, 0)
stopBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 16

-- 📊 العداد
local counter = Instance.new("TextLabel")
counter.Text = "Requests: 0"
counter.Size = UDim2.new(1, 0, 0.1, 0)
counter.Position = UDim2.new(0, 0, 0.72, 0)
counter.BackgroundTransparency = 1
counter.TextColor3 = Color3.new(0, 1, 1)
counter.Font = Enum.Font.SourceSansBold
counter.TextSize = 14

-- 📈 عرض السرعة الحالية
local speedDisplay = Instance.new("TextLabel")
speedDisplay.Text = "Current Speed: 0.01s delay"
speedDisplay.Size = UDim2.new(1, 0, 0.1, 0)
speedDisplay.Position = UDim2.new(0, 0, 0.85, 0)
speedDisplay.BackgroundTransparency = 1
speedDisplay.TextColor3 = Color3.new(1, 1, 0)
speedDisplay.Font = Enum.Font.SourceSansBold
speedDisplay.TextSize = 14

-- التجميع
local elements = {title, speedInput, speedHint, startBtn, stopBtn, counter, speedDisplay}
for _, element in pairs(elements) do
    element.Parent = mainFrame
end
mainFrame.Parent = screenGui
screenGui.Parent = player.PlayerGui

-- 🚀 دالة الهجوم مع السرعة المتحكمة
local function rapidAttack()
    while isAttacking do
        -- البحث عن RemoteEvents
        local remotes = {}
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                table.insert(remotes, obj)
            end
        end
        
        -- إرسال طلبات
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
        
        -- ⚠️ هنا السرعة! تستخدم القيمة اللي بتكتبها
        task.wait(currentSpeed)  -- استخدام السرعة الحالية
    end
end

-- 🎮 تحديث السرعة عندما تكتب
speedInput:GetPropertyChangedSignal("Text"):Connect(function()
    local newSpeed = tonumber(speedInput.Text)
    
    if newSpeed then
        -- تأكد أن السرعة منطقية
        if newSpeed >= 0.001 and newSpeed <= 5 then
            currentSpeed = newSpeed
            speedDisplay.Text = "Current Speed: " .. currentSpeed .. "s delay"
            
            -- تغيير اللون حسب السرعة
            if currentSpeed < 0.05 then
                speedDisplay.TextColor3 = Color3.new(0, 1, 0)  -- أخضر (سريع)
            elseif currentSpeed < 0.5 then
                speedDisplay.TextColor3 = Color3.new(1, 1, 0)  -- أصفر (متوسط)
            else
                speedDisplay.TextColor3 = Color3.new(1, 0, 0)  -- أحمر (بطيء)
            end
        else
            speedDisplay.Text = "⚠️ Speed must be between 0.001 and 5"
            speedDisplay.TextColor3 = Color3.new(1, 0.5, 0)
        end
    else
        speedDisplay.Text = "⚠️ Enter a valid number"
        speedDisplay.TextColor3 = Color3.new(1, 0.5, 0)
    end
end)

-- 🎮 أحداث الأزرار
startBtn.MouseButton1Click:Connect(function()
    if not isAttacking then
        -- تحديث السرعة قبل البدء
        local inputSpeed = tonumber(speedInput.Text)
        if inputSpeed then
            currentSpeed = inputSpeed
        end
        
        isAttacking = true
        requestCount = 0
        startBtn.Text = "⚡ ATTACKING..."
        startBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        
        print("🚀 Rapid attack started!")
        print("⚡ Speed: " .. currentSpeed .. " seconds delay")
        
        task.spawn(rapidAttack)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    isAttacking = false
    startBtn.Text = "🚀 START ATTACK"
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    
    print("⏹️ Attack stopped. Total requests: " .. requestCount)
    print("📊 Final speed was: " .. currentSpeed .. "s delay")
end)

-- 📢 الإعلان
print([[
    
    ╔══════════════════════════════════╗
    ║      ⚡ RAPID FIRE v2.0          ║
    ║   With Speed Control            ║
    ╚══════════════════════════════════╝
    
    📱 How to use:
    1. Enter speed in the box
    2. Press START ATTACK
    3. Press STOP when done
    
    ⚡ Speed Guide:
    0.01 = Very Fast (100/sec)
    0.1  = Fast (10/sec)
    1    = Slow (1/sec)
    5    = Very Slow (0.2/sec)
    
]])
