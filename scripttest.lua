-- 📱 Mobile RemoteEvent Spammer Only
-- بس الطريقة الثانية - خفيف للموبايل

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 🔧 الإعدادات
local settings = {
    gamepassId = nil,        -- هيتم تعبئته من الواجهة
    spamCount = 3,           -- عدد المحاولات لكل RemoteEvent
    delayBetween = 0.3,      -- تأخير بين المحاولات (خفيف للموبايل)
}

-- ⚡ الطريقة الثانية فقط: RemoteEvent Spam
local function spamRemotes(gamepassId)
    if not gamepassId or type(gamepassId) ~= "number" then
        return "❌ Gamepass ID مش صحيح"
    end
    
    print("⚡ بدء RemoteEvent Spam...")
    
    local allRemotes = {}
    local spammedCount = 0
    
    -- جمع كل الـ RemoteEvents
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            table.insert(allRemotes, obj)
        end
    end
    
    if #allRemotes == 0 then
        return "❌ مافيش RemoteEvents في اللعبة"
    end
    
    print("📊 وجد " .. #allRemotes .. " RemoteEvents")
    
    -- تجربة 3 صيغ مختلفة لكل RemoteEvent
    local formats = {
        {name = "ID مباشر", data = gamepassId},
        {name = "جدول بسيط", data = {id = gamepassId}},
        {name = "جدول مفصل", data = {gamepassId = gamepassId, purchased = true, player = player.Name}}
    }
    
    -- بدء الـ Spam
    for i, remote in ipairs(allRemotes) do
        print("🎯 RemoteEvent #" .. i .. ": " .. remote.Name)
        
        for _, format in ipairs(formats) do
            local success, result = pcall(function()
                remote:FireServer(format.data)
                return "✅"
            end)
            
            if success then
                spammedCount = spammedCount + 1
                print("   " .. format.name .. ": ناجح ✓")
            else
                print("   " .. format.name .. ": فشل ✗")
            end
            
            task.wait(settings.delayBetween) -- تأخير للموبايل
        end
    end
    
    return "🎯 تم إرسال " .. spammedCount .. " طلب شراء بـ " .. #allRemotes .. " RemoteEvents"
end

-- 🎮 واجهة الموبايل البسيطة
local function createMobileUI()
    -- تنظيف أي واجهة قديمة
    if player.PlayerGui:FindFirstChild("MobileSpammerUI") then
        player.PlayerGui.MobileSpammerUI:Destroy()
    end
    
    -- إنشاء واجهة جديدة
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MobileSpammerUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- الإطار الرئيسي (في نص الشاشة)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.85, 0, 0.35, 0)
    mainFrame.Position = UDim2.new(0.075, 0, 0.3, 0) -- في نص الشاشة
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "📱 REMOTE SPAMMER (الطريقة 2)"
    title.Size = UDim2.new(1, 0, 0.18, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    
    -- حقل إدخال الـ Gamepass ID
    local idBox = Instance.new("TextBox")
    idBox.Name = "GamepassIDBox"
    idBox.PlaceholderText = "أدخل Gamepass ID هنا"
    idBox.Text = ""
    idBox.Size = UDim2.new(0.8, 0, 0.2, 0)
    idBox.Position = UDim2.new(0.1, 0, 0.25, 0)
    idBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    idBox.TextColor3 = Color3.new(1, 1, 1)
    idBox.Font = Enum.Font.SourceSans
    idBox.TextSize = 18
    idBox.ClearTextOnFocus = false
    
    -- زر التشغيل
    local spamButton = Instance.new("TextButton")
    spamButton.Name = "SpamButton"
    spamButton.Text = "⚡ ابدأ Spam"
    spamButton.Size = UDim2.new(0.8, 0, 0.2, 0)
    spamButton.Position = UDim2.new(0.1, 0, 0.5, 0)
    spamButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    spamButton.TextColor3 = Color3.new(1, 1, 1)
    spamButton.Font = Enum.Font.SourceSansBold
    spamButton.TextSize = 18
    
    -- حالة التشغيل
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Text = "🟢 جاهز..."
    statusLabel.Size = UDim2.new(0.8, 0, 0.25, 0)
    statusLabel.Position = UDim2.new(0.1, 0, 0.75, 0)
    statusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextSize = 16
    statusLabel.TextWrapped = true
    
    -- حدث زر التشغيل
    spamButton.MouseButton1Click:Connect(function()
        local idText = idBox.Text:gsub("%s+", "") -- إزالة المسافات
        local gamepassId = tonumber(idText)
        
        if not gamepassId then
            statusLabel.Text = "❌ أدخل رقم صحيح لـ Gamepass ID"
            statusLabel.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
            return
        end
        
        -- تحديث الإعدادات
        settings.gamepassId = gamepassId
        
        -- تحديث الواجهة أثناء التشغيل
        spamButton.Text = "⏳ جاري التشغيل..."
        spamButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        statusLabel.Text = "⚡ جاري إرسال الطلبات..."
        statusLabel.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
        
        -- التشغيل في thread منفصل
        task.spawn(function()
            local result = spamRemotes(gamepassId)
            
            -- تحديث النتيجة
            statusLabel.Text = result
            
            if result:find("✅") or result:find("ناجح") then
                statusLabel.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            elseif result:find("❌") or result:find("فشل") then
                statusLabel.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
            else
                statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
            
            -- إعادة تعيين الزر
            spamButton.Text = "⚡ ابدأ Spam"
            spamButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        end)
    end)
    
    -- تجميع الواجهة
    title.Parent = mainFrame
    idBox.Parent = mainFrame
    spamButton.Parent = mainFrame
    statusLabel.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- جعل الإطار قابل للسحب (اختياري)
    local dragging = false
    local dragInput, dragStart, startPos
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    return screenGui
end

-- 📊 أمر سريع من الكونسول
_G.RemoteSpam = function(gamepassId)
    if not gamepassId then
        return "أدخل: _G.RemoteSpam(123456)"
    end
    return spamRemotes(gamepassId)
end

-- ℹ️ معلومات التشغيل
print([[
    
📱 RemoteEvent Spammer (الطريقة الثانية فقط)

الأوامر:
1. اكتب الـ Gamepass ID في المربع
2. اضغط على زر "ابدأ Spam"
3. شاهد النتائج

أو من الكونسول:
_G.RemoteSpam(123456)

تم تحميل السكربت بنجاح!
    
]])

-- إنشاء الواجهة
createMobileUI()
