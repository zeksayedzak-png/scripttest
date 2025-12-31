-- 📱 Mobile RemoteFunction Hacker (الطريقة الثالثة)
-- RemoteFunctions Invoke Only - خفيف للموبايل

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 🔧 الإعدادات
local settings = {
    gamepassId = nil,
    invokeCount = 2,          -- مرتين لكل RemoteFunction
    delay = 0.4,             -- تأخير أطول للموبايل
}

-- ⚡ الطريقة الثالثة: RemoteFunction Invoke
local function hackRemoteFunctions(gamepassId)
    if not gamepassId or type(gamepassId) ~= "number" then
        return "❌ Gamepass ID مش صحيح"
    end
    
    print("⚡ بدء RemoteFunction Hack...")
    
    local allFunctions = {}
    local successCount = 0
    local totalAttempts = 0
    
    -- جمع كل الـ RemoteFunctions
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteFunction") then
            table.insert(allFunctions, obj)
        end
    end
    
    if #allFunctions == 0 then
        return "❌ مافيش RemoteFunctions في اللعبة"
    end
    
    print("📊 وجد " .. #allFunctions .. " RemoteFunctions")
    
    -- صيغ مختلفة للاستدعاء
    local payloads = {
        -- صيغ الشراء
        {name = "buy command", data = function(func) return func:InvokeServer("buy", gamepassId) end},
        {name = "purchase cmd", data = function(func) return func:InvokeServer("purchase", gamepassId) end},
        {name = "buyGamepass", data = function(func) return func:InvokeServer("buyGamepass", gamepassId) end},
        
        -- صيغ مباشرة
        {name = "direct ID", data = function(func) return func:InvokeServer(gamepassId) end},
        {name = "table ID", data = function(func) return func:InvokeServer({id = gamepassId}) end},
        {name = "detailed", data = function(func) return func:InvokeServer({gamepassId = gamepassId, player = player.Name}) end},
        
        -- صيغ خاصة
        {name = "with true", data = function(func) return func:InvokeServer(gamepassId, true) end},
        {name = "with player", data = function(func) return func:InvokeServer(player, gamepassId) end},
    }
    
    -- تجربة كل RemoteFunction
    for i, func in ipairs(allFunctions) do
        print("\n🎯 RemoteFunction #" .. i .. ": " .. func.Name)
        
        -- تجربة أهم صيغتين فقط لكل function (خفيف للموبايل)
        for j = 1, math.min(2, #payloads) do
            local payload = payloads[j]
            totalAttempts = totalAttempts + 1
            
            local success, result = pcall(function()
                return payload.data(func)
            end)
            
            if success then
                successCount = successCount + 1
                print("   " .. payload.name .. ": ناجح ✓")
                if result then
                    print("      النتيجة: " .. tostring(result))
                end
            else
                print("   " .. payload.name .. ": فشل ✗")
            end
            
            task.wait(settings.delay) -- تأخير للموبايل
        end
    end
    
    return "🎯 نجح " .. successCount .. "/" .. totalAttempts .. " مع " .. #allFunctions .. " RemoteFunctions"
end

-- 🎮 واجهة الموبايل (في نص الشاشة)
local function createMobileUI()
    -- تنظيف واجهات قديمة
    for _, gui in ipairs(player.PlayerGui:GetChildren()) do
        if gui.Name:find("RemoteFunctionUI") then
            gui:Destroy()
        end
    end
    
    -- إنشاء واجهة جديدة
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RemoteFunctionUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- الإطار الرئيسي (نص الشاشة)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.9, 0, 0.4, 0)
    mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0) -- نص الشاشة
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    
    -- العنوان
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "📱 REMOTE FUNCTION HACKER"
    title.Size = UDim2.new(1, 0, 0.15, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 22
    
    -- حقل إدخال ID
    local idBox = Instance.new("TextBox")
    idBox.Name = "IDBox"
    idBox.PlaceholderText = "أدخل Gamepass ID هنا"
    idBox.Text = ""
    idBox.Size = UDim2.new(0.85, 0, 0.18, 0)
    idBox.Position = UDim2.new(0.075, 0, 0.2, 0)
    idBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    idBox.TextColor3 = Color3.new(1, 1, 1)
    idBox.Font = Enum.Font.SourceSans
    idBox.TextSize = 20
    idBox.ClearTextOnFocus = false
    
    -- زر الاختراق
    local hackButton = Instance.new("TextButton")
    hackButton.Name = "HackButton"
    hackButton.Text = "⚡ اختراق RemoteFunctions"
    hackButton.Size = UDim2.new(0.85, 0, 0.18, 0)
    hackButton.Position = UDim2.new(0.075, 0, 0.45, 0)
    hackButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    hackButton.TextColor3 = Color3.new(1, 1, 1)
    hackButton.Font = Enum.Font.SourceSansBold
    hackButton.TextSize = 18
    
    -- حالة التشغيل
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Text = "🟢 جاهز للاختراق..."
    status.Size = UDim2.new(0.85, 0, 0.35, 0)
    status.Position = UDim2.new(0.075, 0, 0.68, 0)
    status.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    status.TextColor3 = Color3.new(1, 1, 1)
    status.Font = Enum.Font.SourceSans
    status.TextSize = 16
    status.TextWrapped = true
    
    -- زر إغلاق (اختياري)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Text = "✖"
    closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    closeButton.Position = UDim2.new(0.9, 0, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.Font = Enum.Font.SourceSansBold
    
    -- أحداث الأزرار
    hackButton.MouseButton1Click:Connect(function()
        local idText = idBox.Text:gsub("%s+", "")
        local gamepassId = tonumber(idText)
        
        if not gamepassId then
            status.Text = "❌ أدخل رقم صحيح لـ Gamepass ID"
            status.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
            return
        end
        
        settings.gamepassId = gamepassId
        
        -- تحديث الواجهة
        hackButton.Text = "⏳ جاري الاختراق..."
        hackButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        status.Text = "⚡ جاري استدعاء RemoteFunctions..."
        status.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
        
        task.spawn(function()
            local result = hackRemoteFunctions(gamepassId)
            
            status.Text = result
            
            if result:find("نجح") or result:find("✓") then
                status.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            elseif result:find("فشل") or result:find("✗") then
                status.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
            else
                status.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
            
            hackButton.Text = "⚡ اختراق RemoteFunctions"
            hackButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        end)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- تجميع الواجهة
    title.Parent = mainFrame
    idBox.Parent = mainFrame
    hackButton.Parent = mainFrame
    status.Parent = mainFrame
    closeButton.Parent = mainFrame
    mainFrame.Parent = screenGui
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- جعل الواجهة قابلة للسحب (موبايل)
    local dragging = false
    local dragStart, startPos
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return screenGui
end

-- 📊 أوامر الكونسول
_G.RFHack = function(gamepassId)
    if not gamepassId then
        return "أدخل: _G.RFHack(123456)"
    end
    return hackRemoteFunctions(gamepassId)
end

_G.FindRFs = function()
    local count = 0
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteFunction") then
            count = count + 1
            print("RF #" .. count .. ": " .. obj:GetFullName())
        end
    end
    return "وجد " .. count .. " RemoteFunctions"
end

-- ℹ️ بدء التشغيل
print([[
    
📱 RemoteFunction Hacker (الطريقة الثالثة)

الأوامر:
1. اكتب Gamepass ID
2. اضغط "اختراق RemoteFunctions"
3. شاهد النتائج

أو من الكونسول:
_G.RFHack(123456)
_G.FindRFs()

السكربت جاهز!
    
]])

-- إنشاء الواجهة
createMobileUI()

-- نسخة مختصرة لـ loadstring
local miniLoader = [[
-- RemoteFunction Hacker Mini
loadstring(game:HttpGet("https://pastebin.com/raw/XXXXXX"))()
]]

print("🎯 الطريقة الثالثة جاهزة للعمل!")
