-- Mobile Gamepass Hunter - خفيف وسريع للموبايل
local MobileHunter = {}

-- 1. البحث السريع (خفيف على الموبايل)
function MobileHunter:QuickScan()
    local points = {}
    
    -- بس ابحث في الأماكن المهمة
    local importantLocations = {
        game:GetService("Players").LocalPlayer.PlayerScripts,
        game:GetService("Players").LocalPlayer.PlayerGui,
        game:GetService("ReplicatedStorage"),
        game:GetService("ServerStorage"),
        game:GetService("Workspace")
    }
    
    for _, location in ipairs(importantLocations) do
        if location then
            for _, child in ipairs(location:GetChildren()) do
                -- RemoteEvents للشراء
                if child:IsA("RemoteEvent") then
                    local name = child.Name:lower()
                    if name:find("buy") or name:find("purchase") or name:find("gamepass") then
                        table.insert(points, {
                            type = "RemoteEvent",
                            object = child,
                            name = child.Name
                        })
                    end
                end
                
                -- RemoteFunctions
                if child:IsA("RemoteFunction") then
                    local name = child.Name:lower()
                    if name:find("buy") or name:find("purchase") then
                        table.insert(points, {
                            type = "RemoteFunction",
                            object = child,
                            name = child.Name
                        })
                    end
                end
            end
        end
    end
    
    return points
end

-- 2. اختبار بسيط للموبايل
function MobileHunter:TestPurchase(gamepassId)
    local results = {}
    local points = self:QuickScan()
    
    for _, point in ipairs(points) do
        if point.type == "RemoteEvent" then
            local remote = point.object
            
            -- جرب 3 طرق بسيطة
            local attempts = {
                {"Direct ID", function() remote:FireServer(gamepassId) end},
                {"As Table", function() remote:FireServer({id = gamepassId}) end},
                {"With Command", function() remote:FireServer("buy", gamepassId) end}
            }
            
            for _, attempt in ipairs(attempts) do
                local name, func = attempt[1], attempt[2]
                local success = pcall(func)
                
                table.insert(results, {
                    point = point.name,
                    attempt = name,
                    success = success
                })
                
                task.wait(0.2) -- تأخير بسيط للموبايل
            end
        end
    end
    
    return results
end

-- 3. واجهة موبايل بسيطة
function MobileHunter:CreateMobileUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MobileHunter"
    
    -- إطار رئيسي بسيط
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0.9, 0, 0.4, 0)
    main.Position = UDim2.new(0.05, 0, 0.05, 0)
    main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    
    -- عنوان
    local title = Instance.new("TextLabel")
    title.Text = "📱 Mobile Gamepass Hunter"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.SourceSansBold
    
    -- حقل الإدخال
    local input = Instance.new("TextBox")
    input.PlaceholderText = "Gamepass ID"
    input.Size = UDim2.new(0.8, 0, 0, 35)
    input.Position = UDim2.new(0.1, 0, 0.2, 0)
    input.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    input.TextColor3 = Color3.new(1, 1, 1)
    
    -- زر البحث
    local scanBtn = Instance.new("TextButton")
    scanBtn.Text = "🔍 Quick Scan"
    scanBtn.Size = UDim2.new(0.35, 0, 0, 40)
    scanBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
    scanBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    scanBtn.TextColor3 = Color3.new(1, 1, 1)
    
    -- زر الاستغلال
    local exploitBtn = Instance.new("TextButton")
    exploitBtn.Text = "⚡ Exploit"
    exploitBtn.Size = UDim2.new(0.35, 0, 0, 40)
    exploitBtn.Position = UDim2.new(0.55, 0, 0.4, 0)
    exploitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    exploitBtn.TextColor3 = Color3.new(1, 1, 1)
    
    -- نتائج
    local results = Instance.new("TextLabel")
    results.Text = "Ready for mobile scan..."
    results.Size = UDim2.new(0.8, 0, 0, 80)
    results.Position = UDim2.new(0.1, 0, 0.65, 0)
    results.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    results.TextColor3 = Color3.new(1, 1, 1)
    results.TextWrapped = true
    results.Font = Enum.Font.SourceSans
    
    -- أحداث الأزرار
    scanBtn.MouseButton1Click:Connect(function()
        local points = self:QuickScan()
        results.Text = "📊 Found: " .. #points .. " points\n"
        for _, point in ipairs(points) do
            results.Text = results.Text .. point.type .. ": " .. point.name .. "\n"
        end
    end)
    
    exploitBtn.MouseButton1Click:Connect(function()
        local id = tonumber(input.Text)
        if not id then
            results.Text = "❌ Enter valid Gamepass ID"
            return
        end
        
        results.Text = "⚡ Exploiting..."
        
        task.spawn(function()
            local testResults = self:TestPurchase(id)
            
            local successCount = 0
            for _, result in ipairs(testResults) do
                if result.success then
                    successCount = successCount + 1
                end
            end
            
            results.Text = "✅ Success: " .. successCount .. "/" .. #testResults
            results.Text = results.Text .. "\nCheck console for details"
            
            -- طباعة النتائج
            print("\n📱 Mobile Exploit Results:")
            for _, result in ipairs(testResults) do
                print(result.point .. " - " .. result.attempt .. ": " .. (result.success and "✓" or "✗"))
            end
        end)
    end)
    
    -- تجميع الواجهة
    title.Parent = main
    input.Parent = main
    scanBtn.Parent = main
    exploitBtn.Parent = main
    results.Parent = main
    main.Parent = gui
    
    gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    return gui
end

-- 4. أمر سريع من الكونسول
_G.MobileTest = function(gamepassId)
    print("📱 Mobile testing gamepass: " .. gamepassId)
    return MobileHunter:TestPurchase(gamepassId)
end

_G.MobileScan = function()
    return MobileHunter:QuickScan()
end

-- 5. تشغيل تلقائي
print([[
    
📱 Mobile Gamepass Hunter Loaded!

Commands:
_MobileTest(ID) - Test gamepass purchase
_MobileScan() - Quick scan for points

Touch buttons on screen to use GUI

]])

-- إنشاء الواجهة
MobileHunter:CreateMobileUI()

return MobileHunter
