-- 📱 BindableEvents Finder + Copier
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer
local http = game:GetService("HttpService")

-- 🔍 البحث عن BindableEvents مع فلترة
local function findBindableEvents()
    local bindables = {}
    local purchaseBindables = {}
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BindableEvent") then
            local bindableInfo = {
                object = obj,
                name = obj.Name,
                fullPath = obj:GetFullName(),
                className = obj.ClassName
            }
            
            table.insert(bindables, bindableInfo)
            
            -- فلترة لأسماء الشراء
            local lowerName = obj.Name:lower()
            local purchaseKeywords = {
                "buy", "purchase", "gamepass", "shop", 
                "store", "item", "product", "money",
                "coin", "gem", "transaction", "sale"
            }
            
            for _, keyword in ipairs(purchaseKeywords) do
                if lowerName:find(keyword) then
                    table.insert(purchaseBindables, bindableInfo)
                    break
                end
            end
        end
    end
    
    return {
        all = bindables,
        purchase = purchaseBindables,
        total = #bindables,
        purchaseCount = #purchaseBindables
    }
end

-- 📋 نسخ للحافظة (Clipboard)
local function copyToClipboard(text)
    -- طريقة للموبايل
    pcall(function()
        -- محاولة نسخ عبر عدة طرق
        local success
        
        -- الطريقة 1: عبر setclipboard إذا موجود
        if setclipboard then
            setclipboard(text)
            success = true
        end
        
        -- الطريقة 2: عبر rconsoleprint إذا في executor
        if rconsoleprint then
            rconsoleprint(text .. "\n")
            success = true
        end
        
        -- الطريقة 3: طباعة في الكونسول للنسخ اليدوي
        if not success then
            print("\n📋 انسخ النص التالي:\n")
            print("=" .. string.rep("=", 50))
            print(text)
            print("=" .. string.rep("=", 50))
            print("\n📱 على الموبايل: اضغط مطولاً على النص واختر نسخ")
        end
        
        return success
    end)
end

-- 🎮 واجهة الموبايل المحسنة
local function createMobileUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BindableFinder"
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.95, 0, 0.6, 0)
    mainFrame.Position = UDim2.new(0.025, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "🎯 BINDABLE FINDER + COPIER"
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    
    -- زر المسح
    local scanBtn = Instance.new("TextButton")
    scanBtn.Text = "🔍 مسح BindableEvents"
    scanBtn.Size = UDim2.new(0.9, 0, 0.12, 0)
    scanBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
    scanBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    scanBtn.TextColor3 = Color3.new(1, 1, 1)
    scanBtn.Font = Enum.Font.SourceSansBold
    
    -- زر نسخ الجميع
    local copyAllBtn = Instance.new("TextButton")
    copyAllBtn.Text = "📋 نسخ الكل"
    copyAllBtn.Size = UDim2.new(0.43, 0, 0.1, 0)
    copyAllBtn.Position = UDim2.new(0.05, 0, 0.27, 0)
    copyAllBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    copyAllBtn.TextColor3 = Color3.new(1, 1, 1)
    
    -- زر نسخ الخاصة بالشراء
    local copyPurchaseBtn = Instance.new("TextButton")
    copyPurchaseBtn.Text = "💰 نسخ للشراء"
    copyPurchaseBtn.Size = UDim2.new(0.43, 0, 0.1, 0)
    copyPurchaseBtn.Position = UDim2.new(0.52, 0, 0.27, 0)
    copyPurchaseBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    copyPurchaseBtn.TextColor3 = Color3.new(1, 1, 1)
    
    -- النتائج
    local results = Instance.new("ScrollingFrame")
    results.Name = "ResultsFrame"
    results.Size = UDim2.new(0.9, 0, 0.45, 0)
    results.Position = UDim2.new(0.05, 0, 0.4, 0)
    results.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    results.BorderSizePixel = 1
    results.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
    results.ScrollBarThickness = 8
    results.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local resultsList = Instance.new("UIListLayout")
    resultsList.Parent = results
    resultsList.Padding = UDim.new(0, 5)
    
    -- العداد
    local counter = Instance.new("TextLabel")
    counter.Text = "🟢 جاهز للمسح"
    counter.Size = UDim2.new(1, 0, 0.1, 0)
    counter.Position = UDim2.new(0, 0, 0.88, 0)
    counter.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    counter.TextColor3 = Color3.new(1, 1, 1)
    counter.TextWrapped = true
    
    -- المتغيرات
    local currentResults = nil
    
    -- 🔍 دالة المسح
    local function performScan()
        scanBtn.Text = "⏳ جاري المسح..."
        scanBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        counter.Text = "🔍 يمسح اللعبة..."
        
        -- مسح المحتوى القديم
        for _, child in ipairs(results:GetChildren()) do
            if not child:IsA("UIListLayout") then
                child:Destroy()
            end
        end
        
        task.spawn(function()
            currentResults = findBindableEvents()
            
            -- عرض النتائج
            for i, bindable in ipairs(currentResults.all) do
                local itemFrame = Instance.new("Frame")
                itemFrame.Size = UDim2.new(1, 0, 0, 50)
                itemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                itemFrame.BorderSizePixel = 1
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Text = i .. ". " .. bindable.name
                nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
                nameLabel.Position = UDim2.new(0, 0, 0, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.TextColor3 = Color3.new(1, 1, 1)
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.TextWrapped = true
                nameLabel.PaddingLeft = UDim.new(0, 10)
                
                local copyBtn = Instance.new("TextButton")
                copyBtn.Text = "📋"
                copyBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
                copyBtn.Position = UDim2.new(0.73, 0, 0.15, 0)
                copyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
                copyBtn.TextColor3 = Color3.new(1, 1, 1)
                
                -- حدث نسخ الملف الواحد
                copyBtn.MouseButton1Click:Connect(function()
                    local text = bindable.name .. " - " .. bindable.fullPath
                    copyToClipboard(text)
                    counter.Text = "✅ نسخت: " .. bindable.name
                end)
                
                -- تحديد إذا كان للشراء
                local isPurchase = false
                for _, pb in ipairs(currentResults.purchase) do
                    if pb.name == bindable.name then
                        isPurchase = true
                        break
                    end
                end
                
                if isPurchase then
                    itemFrame.BackgroundColor3 = Color3.fromRGB(50, 30, 60)
                    nameLabel.TextColor3 = Color3.new(1, 0.5, 1)
                end
                
                nameLabel.Parent = itemFrame
                copyBtn.Parent = itemFrame
                itemFrame.Parent = results
            end
            
            -- تحديث العداد
            counter.Text = string.format("✅ وجد %d BindableEvents (%d للشراء)", 
                currentResults.total, currentResults.purchaseCount)
            
            scanBtn.Text = "🔍 مسح BindableEvents"
            scanBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        end)
    end
    
    -- 📋 دالة نسخ الكل
    local function copyAllBindables()
        if not currentResults then
            counter.Text = "❌ قم بالمسح أولاً"
            return
        end
        
        local text = "-- جميع BindableEvents في اللعبة --\n\n"
        for i, bindable in ipairs(currentResults.all) do
            text = text .. i .. ". " .. bindable.name .. "\n"
            text = text .. "   المسار: " .. bindable.fullPath .. "\n\n"
        end
        
        copyToClipboard(text)
        counter.Text = "✅ نسخت " .. currentResults.total .. " BindableEvent"
    end
    
    -- 💰 دالة نسخ للشراء فقط
    local function copyPurchaseBindables()
        if not currentResults then
            counter.Text = "❌ قم بالمسح أولاً"
            return
        end
        
        if currentResults.purchaseCount == 0 then
            counter.Text = "❌ لا توجد BindableEvents للشراء"
            return
        end
        
        local text = "-- BindableEvents للشراء --\n\n"
        for i, bindable in ipairs(currentResults.purchase) do
            text = text .. i .. ". " .. bindable.name .. "\n"
            text = text .. "   المسار: " .. bindable.fullPath .. "\n\n"
        end
        
        copyToClipboard(text)
        counter.Text = "✅ نسخت " .. currentResults.purchaseCount .. " للشراء"
    end
    
    -- أحداث الأزرار
    scanBtn.MouseButton1Click:Connect(performScan)
    copyAllBtn.MouseButton1Click:Connect(copyAllBindables)
    copyPurchaseBtn.MouseButton1Click:Connect(copyPurchaseBindables)
    
    -- التجميع
    title.Parent = mainFrame
    scanBtn.Parent = mainFrame
    copyAllBtn.Parent = mainFrame
    copyPurchaseBtn.Parent = mainFrame
    results.Parent = mainFrame
    counter.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player.PlayerGui
    
    return screenGui
end

-- أوامر الكونسول
_G.ScanBindables = function()
    return findBindableEvents()
end

_G.CopyAll = function()
    local results = findBindableEvents()
    local text = ""
    for i, bindable in ipairs(results.all) do
        text = text .. i .. ". " .. bindable.name .. " | " .. bindable.fullPath .. "\n"
    end
    copyToClipboard(text)
    return "نسخت " .. results.total .. " BindableEvent"
end

_G.CopyPurchase = function()
    local results = findBindableEvents()
    if results.purchaseCount == 0 then
        return "لا توجد BindableEvents للشراء"
    end
    
    local text = ""
    for i, bindable in ipairs(results.purchase) do
        text = text .. i .. ". " .. bindable.name .. " | " .. bindable.fullPath .. "\n"
    end
    copyToClipboard(text)
    return "نسخت " .. results.purchaseCount .. " BindableEvent للشراء"
end

-- بدء التشغيل
print([[
    
🎯 BINDABLE FINDER + COPIER v1.0

مميزات:
1. 🔍 يبحث عن جميع BindableEvents
2. 💰 يفرز الخاصة بالشراء
3. 📋 ينسخ للحافظة
4. 📱 واجهة موبايل سهلة

الأوامر:
_G.ScanBindables() - البحث
_G.CopyAll() - نسخ الكل  
_G.CopyPurchase() - نسخ للشراء فقط

]])

-- إنشاء الواجهة
createMobileUI()

print("✅ Bindable Finder جاهز!")
