-- 🎯 Purchase Hunter with Copy to Clipboard
-- loadstring(game:HttpGet("رابط_هذا_الكود"))()

local player = game.Players.LocalPlayer
local currentSystems = nil -- لتخزين النتائج

-- 🔍 البحث عن أنظمة الشراء
local function findRealPurchaseSystems()
    local results = {
        remoteEvents = {},
        remoteFunctions = {},
        totalFound = 0
    }
    
    local purchaseKeywords = {
        "buy", "purchase", "gamepass", "pass", 
        "shop", "store", "item", "product",
        "money", "coin", "gem", "premium",
        "transaction", "sale", "deal", "offer"
    }
    
    -- بحث في RemoteEvents
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local lowerName = obj.Name:lower()
            local fullPath = obj:GetFullName()
            
            for _, keyword in ipairs(purchaseKeywords) do
                if lowerName:find(keyword) then
                    table.insert(results.remoteEvents, {
                        name = obj.Name,
                        path = fullPath,
                        object = obj
                    })
                    results.totalFound = results.totalFound + 1
                    break
                end
            end
        end
        
        -- بحث في RemoteFunctions
        if obj:IsA("RemoteFunction") then
            local lowerName = obj.Name:lower()
            local fullPath = obj:GetFullName()
            
            for _, keyword in ipairs(purchaseKeywords) do
                if lowerName:find(keyword) then
                    table.insert(results.remoteFunctions, {
                        name = obj.Name,
                        path = fullPath,
                        object = obj
                    })
                    results.totalFound = results.totalFound + 1
                    break
                end
            end
        end
    end
    
    currentSystems = results -- حفظ النتائج
    return results
end

-- 📋 نسخ للحافظة
local function copyToClipboard(text)
    -- طريقة للموبايل
    pcall(function()
        if setclipboard then
            setclipboard(text)
            return true
        end
        
        -- إذا مافيش setclipboard
        print("\n📋 انسخ النص التالي:\n")
        print("=" .. string.rep("=", 50))
        print(text)
        print("=" .. string.rep("=", 50))
        return false
    end)
end

-- 🎮 واجهة الموبايل مع زر النسخ
local function createMobileUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PurchaseHunter"
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.95, 0, 0.6, 0) -- زدنا الإرتفاع
    mainFrame.Position = UDim2.new(0.025, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Text = "🎯 PURCHASE SYSTEM HUNTER"
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.BackgroundColor3 = Color3.fromRGB(200, 50, 0)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    
    -- زر البحث
    local searchBtn = Instance.new("TextButton")
    searchBtn.Text = "🔍 بحث عن أنظمة الشراء"
    searchBtn.Size = UDim2.new(0.9, 0, 0.12, 0)
    searchBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
    searchBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    searchBtn.TextColor3 = Color3.new(1, 1, 1)
    searchBtn.Font = Enum.Font.SourceSansBold
    
    -- زر نسخ RemoteEvents
    local copyEventsBtn = Instance.new("TextButton")
    copyEventsBtn.Text = "📋 نسخ RemoteEvents"
    copyEventsBtn.Size = UDim2.new(0.44, 0, 0.1, 0)
    copyEventsBtn.Position = UDim2.new(0.05, 0, 0.27, 0)
    copyEventsBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    copyEventsBtn.TextColor3 = Color3.new(1, 1, 1)
    copyEventsBtn.Visible = false -- مخفي حتى البحث
    
    -- زر نسخ RemoteFunctions
    local copyFunctionsBtn = Instance.new("TextButton")
    copyFunctionsBtn.Text = "📋 نسخ RemoteFunctions"
    copyFunctionsBtn.Size = UDim2.new(0.44, 0, 0.1, 0)
    copyFunctionsBtn.Position = UDim2.new(0.51, 0, 0.27, 0)
    copyFunctionsBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
    copyFunctionsBtn.TextColor3 = Color3.new(1, 1, 1)
    copyFunctionsBtn.Visible = false -- مخفي حتى البحث
    
    -- حقل ID
    local idBox = Instance.new("TextBox")
    idBox.PlaceholderText = "Gamepass ID هنا"
    idBox.Size = UDim2.new(0.9, 0, 0.1, 0)
    idBox.Position = UDim2.new(0.05, 0, 0.4, 0)
    idBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    idBox.TextColor3 = Color3.new(1, 1, 1)
    
    -- زر الاختبار
    local testBtn = Instance.new("TextButton")
    testBtn.Text = "⚡ اختراق Gamepass"
    testBtn.Size = UDim2.new(0.9, 0, 0.12, 0)
    testBtn.Position = UDim2.new(0.05, 0, 0.53, 0)
    testBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    testBtn.TextColor3 = Color3.new(1, 1, 1)
    testBtn.Font = Enum.Font.SourceSansBold
    
    -- زر نسخ الكل
    local copyAllBtn = Instance.new("TextButton")
    copyAllBtn.Text = "📋 نسخ الكل"
    copyAllBtn.Size = UDim2.new(0.9, 0, 0.1, 0)
    copyAllBtn.Position = UDim2.new(0.05, 0, 0.68, 0)
    copyAllBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 0)
    copyAllBtn.TextColor3 = Color3.new(1, 1, 1)
    copyAllBtn.Visible = false -- مخفي حتى البحث
    
    -- النتائج
    local results = Instance.new("TextLabel")
    results.Text = "اضغط 🔍 للبحث أولاً"
    results.Size = UDim2.new(0.9, 0, 0.25, 0)
    results.Position = UDim2.new(0.05, 0, 0.81, 0)
    results.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    results.TextColor3 = Color3.new(1, 1, 1)
    results.TextWrapped = true
    
    -- 📋 وظيفة نسخ RemoteEvents
    local function copyEventsToClipboard()
        if not currentSystems or #currentSystems.remoteEvents == 0 then
            results.Text = "❌ لا توجد RemoteEvents للنسخ"
            return
        end
        
        local text = "-- RemoteEvents للشراء --\n\n"
        for i, event in ipairs(currentSystems.remoteEvents) do
            text = text .. i .. ". " .. event.name .. "\n"
            text = text .. "   المسار: " .. event.path .. "\n\n"
        end
        
        if copyToClipboard(text) then
            results.Text = "✅ نسخت " .. #currentSystems.remoteEvents .. " RemoteEvents"
        else
            results.Text = "📋 اذهب للكونسول وانسخ النص"
        end
    end
    
    -- 📋 وظيفة نسخ RemoteFunctions
    local function copyFunctionsToClipboard()
        if not currentSystems or #currentSystems.remoteFunctions == 0 then
            results.Text = "❌ لا توجد RemoteFunctions للنسخ"
            return
        end
        
        local text = "-- RemoteFunctions للشراء --\n\n"
        for i, func in ipairs(currentSystems.remoteFunctions) do
            text = text .. i .. ". " .. func.name .. "\n"
            text = text .. "   المسار: " .. func.path .. "\n\n"
        end
        
        if copyToClipboard(text) then
            results.Text = "✅ نسخت " .. #currentSystems.remoteFunctions .. " RemoteFunctions"
        else
            results.Text = "📋 اذهب للكونسول وانسخ النص"
        end
    end
    
    -- 📋 وظيفة نسخ الكل
    local function copyAllToClipboard()
        if not currentSystems or currentSystems.totalFound == 0 then
            results.Text = "❌ لا توجد أنظمة للنسخ"
            return
        end
        
        local text = "-- جميع أنظمة الشراء --\n\n"
        
        if #currentSystems.remoteEvents > 0 then
            text = text .. "🔥 RemoteEvents (" .. #currentSystems.remoteEvents .. "):\n"
            for i, event in ipairs(currentSystems.remoteEvents) do
                text = text .. "  " .. i .. ". " .. event.name .. " | " .. event.path .. "\n"
            end
            text = text .. "\n"
        end
        
        if #currentSystems.remoteFunctions > 0 then
            text = text .. "🔧 RemoteFunctions (" .. #currentSystems.remoteFunctions .. "):\n"
            for i, func in ipairs(currentSystems.remoteFunctions) do
                text = text .. "  " .. i .. ". " .. func.name .. " | " .. func.path .. "\n"
            end
            text = text .. "\n"
        end
        
        if copyToClipboard(text) then
            results.Text = "✅ نسخت " .. currentSystems.totalFound .. " نظام"
        else
            results.Text = "📋 اذهب للكونسول وانسخ النص"
        end
    end
    
    -- أحداث الأزرار
    searchBtn.MouseButton1Click:Connect(function()
        searchBtn.Text = "⏳ جاري البحث..."
        results.Text = "🔍 يبحث عن RemoteEvents و RemoteFunctions..."
        
        task.spawn(function()
            local systems = findRealPurchaseSystems()
            
            -- إظهار أزرار النسخ إذا وجد نتائج
            copyEventsBtn.Visible = (#systems.remoteEvents > 0)
            copyFunctionsBtn.Visible = (#systems.remoteFunctions > 0)
            copyAllBtn.Visible = (systems.totalFound > 0)
            
            if systems.totalFound == 0 then
                results.Text = "❌ ما لقيت أنظمة شراء\n\n" ..
                              "اللعبة ممكن تستخدم:\n" ..
                              "• MarketplaceService مباشر\n" ..
                              "• طرق مختلفة"
                copyEventsBtn.Visible = false
                copyFunctionsBtn.Visible = false
                copyAllBtn.Visible = false
            else
                local text = "✅ وجد " .. systems.totalFound .. " نظام:\n\n"
                
                if #systems.remoteEvents > 0 then
                    text = text .. "🔥 RemoteEvents: " .. #systems.remoteEvents .. "\n"
                end
                
                if #systems.remoteFunctions > 0 then
                    text = text .. "🔧 RemoteFunctions: " .. #systems.remoteFunctions .. "\n"
                end
                
                results.Text = text .. "\n📋 استخدم أزرار النسخ"
            end
            
            searchBtn.Text = "🔍 بحث عن أنظمة الشراء"
        end)
    end)
    
    copyEventsBtn.MouseButton1Click:Connect(copyEventsToClipboard)
    copyFunctionsBtn.MouseButton1Click:Connect(copyFunctionsToClipboard)
    copyAllBtn.MouseButton1Click:Connect(copyAllToClipboard)
    
    testBtn.MouseButton1Click:Connect(function()
        local id = tonumber(idBox.Text)
        if not id then
            results.Text = "❌ أدخل رقم Gamepass ID"
            return
        end
        
        -- دالة الاختبار (بنفس الكود السابق)
        results.Text = "⚡ جاري اختبار ID: " .. id
        -- أضف دالة الاختبار هنا...
    end)
    
    -- التجميع
    title.Parent = mainFrame
    searchBtn.Parent = mainFrame
    copyEventsBtn.Parent = mainFrame
    copyFunctionsBtn.Parent = mainFrame
    idBox.Parent = mainFrame
    testBtn.Parent = mainFrame
    copyAllBtn.Parent = mainFrame
    results.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player.PlayerGui
    
    return screenGui
end

-- أوامر الكونسول للنسخ
_G.CopyEvents = function()
    local systems = findRealPurchaseSystems()
    if #systems.remoteEvents == 0 then
        return "لا توجد RemoteEvents"
    end
    
    local text = ""
    for i, event in ipairs(systems.remoteEvents) do
        text = text .. i .. ". " .. event.name .. " | " .. event.path .. "\n"
    end
    
    copyToClipboard(text)
    return "نسخت " .. #systems.remoteEvents .. " RemoteEvents"
end

_G.CopyFunctions = function()
    local systems = findRealPurchaseSystems()
    if #systems.remoteFunctions == 0 then
        return "لا توجد RemoteFunctions"
    end
    
    local text = ""
    for i, func in ipairs(systems.remoteFunctions) do
        text = text .. i .. ". " .. func.name .. " | " .. func.path .. "\n"
    end
    
    copyToClipboard(text)
    return "نسخت " .. #systems.remoteFunctions .. " RemoteFunctions"
end

_G.CopyAllSystems = function()
    local systems = findRealPurchaseSystems()
    if systems.totalFound == 0 then
        return "لا توجد أنظمة"
    end
    
    local text = "RemoteEvents:\n"
    for i, event in ipairs(systems.remoteEvents) do
        text = text .. i .. ". " .. event.name .. " | " .. event.path .. "\n"
    end
    
    text = text .. "\nRemoteFunctions:\n"
    for i, func in ipairs(systems.remoteFunctions) do
        text = text .. i .. ". " .. func.name .. " | " .. func.path .. "\n"
    end
    
    copyToClipboard(text)
    return "نسخت " .. systems.totalFound .. " نظام"
end

-- بدء التشغيل
print([[
    
🎯 PURCHASE HUNTER v2.0
📋 مع نسخ للحافظة!

الأوامر:
1. 🔍 ابحث عن أنظمة الشراء
2. 📋 استخدم أزرار النسخ
3. ⚡ جرب مع Gamepass ID

أوامر الكونسول:
_G.CopyEvents() - نسخ RemoteEvents
_G.CopyFunctions() - نسخ RemoteFunctions  
_G.CopyAllSystems() - نسخ الكل

]])

createMobileUI()
print("✅ Purchase Hunter with Copy جاهز!")
