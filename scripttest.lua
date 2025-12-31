-- 📱 الطريقة الرابعة: BindableEvents Hacker
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer

-- 🔍 البحث عن BindableEvents فقط
local function findBindableEvents()
    local bindables = {}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BindableEvent") then
            table.insert(bindables, obj)
        end
    end
    return bindables
end

-- ⚡ محاولة تشغيل BindableEvents
local function fireBindableEvents(gamepassId)
    if not gamepassId then
        return "❌ أدخل Gamepass ID"
    end
    
    print("🔍 البحث عن BindableEvents...")
    local bindables = findBindableEvents()
    
    if #bindables == 0 then
        return "❌ لا توجد BindableEvents في اللعبة"
    end
    
    print("📊 وجد " .. #bindables .. " BindableEvents")
    
    local successCount = 0
    local failedCount = 0
    
    -- صيغ مختلفة
    local payloads = {
        gamepassId,
        {id = gamepassId},
        {gamepassId = gamepassId, player = player.Name},
        "buy",
        "purchase",
        {action = "purchase", itemId = gamepassId}
    }
    
    -- تشغيل كل BindableEvent
    for i, bindable in ipairs(bindables) do
        print("\n🎯 BindableEvent #" .. i .. ": " .. bindable.Name)
        
        -- تجربة 3 صيغ لكل bindable
        for j = 1, 3 do
            local payload = payloads[math.random(1, #payloads)]
            
            local success, result = pcall(function()
                bindable:Fire(payload)
                return true
            end)
            
            if success then
                successCount = successCount + 1
                print("   ✅ نجح: " .. type(payload))
            else
                failedCount = failedCount + 1
                print("   ❌ فشل: " .. type(payload))
            end
            
            task.wait(0.2) -- تأخير آمن
        end
    end
    
    return "✅ نجح " .. successCount .. " فشل " .. failedCount .. " من " .. #bindables .. " BindableEvents"
end

-- 🎮 واجهة الموبايل البسيطة
local function createMobileUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BindableHacker"
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.9, 0, 0.35, 0)
    mainFrame.Position = UDim2.new(0.05, 0, 0.32, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "🎯 BINDABLE EVENTS HACKER"
    title.Size = UDim2.new(1, 0, 0.2, 0)
    title.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    
    -- حقل الإدخال
    local idBox = Instance.new("TextBox")
    idBox.PlaceholderText = "Gamepass ID هنا"
    idBox.Size = UDim2.new(0.8, 0, 0.2, 0)
    idBox.Position = UDim2.new(0.1, 0, 0.25, 0)
    idBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    idBox.TextColor3 = Color3.new(1, 1, 1)
    idBox.Font = Enum.Font.SourceSans
    
    -- زر التشغيل
    local fireBtn = Instance.new("TextButton")
    fireBtn.Text = "🔥 Fire BindableEvents"
    fireBtn.Size = UDim2.new(0.8, 0, 0.2, 0)
    fireBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
    fireBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    fireBtn.TextColor3 = Color3.new(1, 1, 1)
    fireBtn.Font = Enum.Font.SourceSansBold
    
    -- النتائج
    local results = Instance.new("TextLabel")
    results.Text = "أدخل ID واضغط 🔥"
    results.Size = UDim2.new(0.8, 0, 0.3, 0)
    results.Position = UDim2.new(0.1, 0, 0.75, 0)
    results.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    results.TextColor3 = Color3.new(1, 1, 1)
    results.TextWrapped = true
    
    -- أحداث
    fireBtn.MouseButton1Click:Connect(function()
        local id = tonumber(idBox.Text)
        if not id then
            results.Text = "❌ أدخل رقم صحيح"
            return
        end
        
        fireBtn.Text = "⏳ جاري..."
        fireBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        results.Text = "🔍 يبحث عن BindableEvents..."
        
        task.spawn(function()
            local result = fireBindableEvents(id)
            results.Text = result
            
            if result:find("✅") then
                results.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
            else
                results.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            end
            
            fireBtn.Text = "🔥 Fire BindableEvents"
            fireBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end)
    end)
    
    -- تجميع الواجهة
    title.Parent = mainFrame
    idBox.Parent = mainFrame
    fireBtn.Parent = mainFrame
    results.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player.PlayerGui
    
    return screenGui
end

-- أوامر الكونسول
_G.BindableHack = function(gamepassId)
    return fireBindableEvents(gamepassId)
end

_G.CountBindables = function()
    local count = #findBindableEvents()
    print("🔍 BindableEvents: " .. count)
    for i, bindable in ipairs(findBindableEvents()) do
        print(i .. ". " .. bindable:GetFullName())
    end
    return count
end

-- بدء التشغيل
print([[
    
🎯 BINDABLE EVENTS HACKER (الطريقة 4)

BindableEvents هي أحداث داخلية في اللعبة
قد تستخدم لنظام الشراء الداخلي

الأوامر:
1. اكتب Gamepass ID
2. اضغط "Fire BindableEvents"
3. شاهد النتائج

أو من الكونسول:
_G.BindableHack(123456)
_G.CountBindables()

]])

-- إنشاء الواجهة
createMobileUI()

print("✅ Bindable Events Hacker جاهز!")
