-- ⚡ Rapid Fire Attack with Anti-Kick Protection
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer
local isAttacking = false
local requestCount = 0
local requestsPerSecond = 10

-- 🔧 نظام الحماية من الطرد (مضاف جديد)
local AntiKick = {
    safeMode = true,                   -- وضع الحماية مفعل
    maxRequestsPerMinute = 180,        -- 180 طلب في الدقيقة كحد أقصى
    requestsThisMinute = 0,
    lastRequestTime = tick(),
    requestHistory = {},
    
    -- تحقق إذا الوضع آمن للإرسال
    canSendRequest = function(self)
        if not self.safeMode then return true end
        
        local now = tick()
        local timeDiff = now - self.lastRequestTime
        
        -- تنظيف التاريخ القديم
        for i = #self.requestHistory, 1, -1 do
            if now - self.requestHistory[i] > 60 then -- 60 ثانية
                table.remove(self.requestHistory, i)
            end
        end
        
        -- إذا عدد الطلبات في الدقيقة أقل من الحد
        if #self.requestHistory < self.maxRequestsPerMinute then
            table.insert(self.requestHistory, now)
            self.lastRequestTime = now
            self.requestsThisMinute = #self.requestHistory
            return true
        else
            return false, "Rate limit reached. Waiting..."
        end
    end,
    
    -- تأخير ذكي بناءً على الحمل
    getSmartDelay = function(self)
        if #self.requestHistory < 30 then
            return 0.1 -- سريع في البداية
        elseif #self.requestHistory < 90 then
            return 0.3 -- متوسط
        elseif #self.requestHistory < 150 then
            return 0.5 -- بطيء
        else
            return 1.0 -- بطيء جداً قرب الحد
        end
    end
}

-- 📱 واجهة للهاتف
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RapidFire"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 0.5, 0) -- زدنا الإرتفاع
mainFrame.Position = UDim2.new(0, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2

-- 🎯 العنوان
local title = Instance.new("TextLabel")
title.Text = "⚡ RAPID FIRE ATTACK"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold

-- 📝 مربع إدخال السرعة
local speedInput = Instance.new("TextBox")
speedInput.PlaceholderText = "Requests per second (1-30)"
speedInput.Text = "10"
speedInput.Size = UDim2.new(0.9, 0, 0.1, 0)
speedInput.Position = UDim2.new(0.05, 0, 0.12, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Font = Enum.Font.SourceSansBold
speedInput.TextSize = 16

-- 🔧 زر تبديل وضع الحماية
local protectionBtn = Instance.new("TextButton")
protectionBtn.Text = "🛡️ ANTI-KICK: ON"
protectionBtn.Size = UDim2.new(0.9, 0, 0.1, 0)
protectionBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
protectionBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
protectionBtn.TextColor3 = Color3.new(1, 1, 1)
protectionBtn.Font = Enum.Font.SourceSansBold
protectionBtn.TextSize = 16

-- 🔥 زر التشغيل
local startBtn = Instance.new("TextButton")
startBtn.Text = "🚀 START ATTACK"
startBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
startBtn.Position = UDim2.new(0.05, 0, 0.38, 0)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.SourceSansBold
startBtn.TextSize = 18

-- ⏹️ زر الإيقاف
local stopBtn = Instance.new("TextButton")
stopBtn.Text = "⏹️ STOP"
stopBtn.Size = UDim2.new(0.9, 0, 0.2, 0)
stopBtn.Position = UDim2.new(0.05, 0, 0.61, 0)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 18

-- 📊 العداد
local counter = Instance.new("TextLabel")
counter.Text = "Requests: 0"
counter.Size = UDim2.new(1, 0, 0.12, 0)
counter.Position = UDim2.new(0, 0, 0.83, 0)
counter.BackgroundTransparency = 1
counter.TextColor3 = Color3.new(0, 1, 1)
counter.Font = Enum.Font.SourceSansBold
counter.TextSize = 16

-- 📈 مؤشر الحماية
local protectionIndicator = Instance.new("TextLabel")
protectionIndicator.Text = "🟢 Safe: 0/180 requests (minute)"
protectionIndicator.Size = UDim2.new(1, 0, 0.1, 0)
protectionIndicator.Position = UDim2.new(0, 0, 0.94, 0)
protectionIndicator.BackgroundTransparency = 1
protectionIndicator.TextColor3 = Color3.new(0, 1, 0)
protectionIndicator.Font = Enum.Font.SourceSans
protectionIndicator.TextSize = 14

-- التجميع
title.Parent = mainFrame
speedInput.Parent = mainFrame
protectionBtn.Parent = mainFrame
startBtn.Parent = mainFrame
stopBtn.Parent = mainFrame
counter.Parent = mainFrame
protectionIndicator.Parent = mainFrame
mainFrame.Parent = screenGui
screenGui.Parent = player.PlayerGui

-- 🚀 دالة الهجوم السريع مع حماية
local function rapidAttack()
    while isAttacking do
        local targetRequests = requestsPerSecond
        local requestsSent = 0
        
        -- تحديث مؤشر الحماية
        protectionIndicator.Text = string.format("🛡️ Safe: %d/%d requests", 
            #AntiKick.requestHistory, AntiKick.maxRequestsPerMinute)
        
        -- تغيير لون المؤشر بناءً على الحمل
        local loadPercent = (#AntiKick.requestHistory / AntiKick.maxRequestsPerMinute) * 100
        if loadPercent < 50 then
            protectionIndicator.TextColor3 = Color3.new(0, 1, 0)
        elseif loadPercent < 80 then
            protectionIndicator.TextColor3 = Color3.new(1, 1, 0)
        else
            protectionIndicator.TextColor3 = Color3.new(1, 0, 0)
        end
        
        -- أرسل العدد المطلوب من الطلبات
        while requestsSent < targetRequests and isAttacking do
            -- البحث عن RemoteEvents
            local remotes = {}
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    table.insert(remotes, obj)
                end
            end
            
            -- إرسال طلبات مع حماية
            for _, remote in ipairs(remotes) do
                if not isAttacking or requestsSent >= targetRequests then break end
                
                -- تحقق إذا مسموح بالإرسال
                local canSend, message = AntiKick:canSendRequest()
                
                if canSend then
                    task.spawn(function()
                        pcall(function()
                            remote:FireServer("Amt3")
                            requestCount = requestCount + 1
                            requestsSent = requestsSent + 1
                            counter.Text = "Requests: " .. requestCount
                        end)
                    end)
                else
                    -- انتظر إذا وصلنا للحد
                    print("⚠️ " .. message)
                    protectionIndicator.Text = "⏸️ " .. message
                    task.wait(AntiKick:getSmartDelay())
                end
                
                -- تأخير ذكي بين الطلبات
                local smartDelay = AntiKick:getSmartDelay()
                task.wait(smartDelay)
            end
        end
        
        -- انتظر قبل الدورة التالية
        task.wait(0.1)
    end
end

-- 🎮 أحداث الأزرار
startBtn.MouseButton1Click:Connect(function()
    if not isAttacking then
        -- قراءة السرعة من مربع الإدخال
        local inputSpeed = tonumber(speedInput.Text)
        if inputSpeed and inputSpeed > 0 and inputSpeed <= 30 then
            requestsPerSecond = inputSpeed
        else
            requestsPerSecond = 10
            speedInput.Text = "10"
        end
        
        isAttacking = true
        requestCount = 0
        startBtn.Text = "⚡ ATTACKING..."
        startBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        
        print("🚀 Rapid attack started with Anti-Kick protection!")
        print("⚡ Speed: " .. requestsPerSecond .. " requests/second")
        print("🛡️ Protection: " .. (AntiKick.safeMode and "ENABLED" or "DISABLED"))
        
        task.spawn(rapidAttack)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    isAttacking = false
    startBtn.Text = "🚀 START ATTACK"
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    protectionIndicator.Text = "🟢 Ready"
    protectionIndicator.TextColor3 = Color3.new(0, 1, 0)
    
    print("⏹️ Attack stopped. Total requests: " .. requestCount)
end)

protectionBtn.MouseButton1Click:Connect(function()
    AntiKick.safeMode = not AntiKick.safeMode
    
    if AntiKick.safeMode then
        protectionBtn.Text = "🛡️ ANTI-KICK: ON"
        protectionBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        print("🛡️ Anti-Kick protection ENABLED")
    else
        protectionBtn.Text = "⚠️ ANTI-KICK: OFF"
        protectionBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
        print("⚠️ Anti-Kick protection DISABLED (Use at your own risk)")
    end
end)

-- 🔄 تحديث مؤشر الحماية كل ثانية
task.spawn(function()
    while true do
        if isAttacking then
            protectionIndicator.Text = string.format("🛡️ Safe: %d/%d requests", 
                #AntiKick.requestHistory, AntiKick.maxRequestsPerMinute)
        end
        task.wait(1)
    end
end)

-- 📢 الإعلان
print([[
    
    ╔══════════════════════════════════╗
    ║      ⚡ RAPID FIRE v2.0          ║
    ║   With Anti-Kick Protection     ║
    ╚══════════════════════════════════╝
    
    🛡️ ANTI-KICK FEATURES:
    • 180 requests/minute max (3/sec)
    • Smart delay system
    • Real-time load indicator
    • Toggle on/off protection
    
    📱 How to use:
    1. Set speed (1-30 requests/sec)
    2. Toggle Anti-Kick ON/OFF
    3. Press START ATTACK
    4. Monitor protection indicator
    
    ⚡ Safe speeds:
    • Green: <90 requests/minute
    • Yellow: 90-150 requests/minute  
    • Red: 150-180 requests/minute
    
]])

-- 🎯 رابط سريع للاستخدام
_G.ChangeSpeed = function(newSpeed)
    if type(newSpeed) == "number" and newSpeed > 0 and newSpeed <= 30 then
        requestsPerSecond = newSpeed
        speedInput.Text = tostring(newSpeed)
        print("⚡ Speed changed to: " .. newSpeed .. " requests/second")
    end
end

_G.ToggleProtection = function()
    protectionBtn:Click()
end
