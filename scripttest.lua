local GamepassHunter = {
    Vulnerabilities = {},
    PurchasePoints = {},
    Exploits = {}
}

-- 1. البحث عن نقاط شراء ضعيفة
function GamepassHunter:FindPurchaseVulnerabilities()
    -- كل الـ RemoteEvents اللي ممكن تكون للشراء
    for _, remote in ipairs(game:GetDescendants()) do
        if remote:IsA("RemoteEvent") then
            -- تحقق إذا كان الاسم يدل على شراء
            local lowerName = remote.Name:lower()
            if string.find(lowerName, "purchase") or
               string.find(lowerName, "buy") or
               string.find(lowerName, "gamepass") then
                
                table.insert(self.PurchasePoints, {
                    object = remote,
                    name = remote.Name,
                    path = remote:GetFullName()
                })
            end
        end
    end
end

-- 2. محاولة استغلال كل نقطة
function GamepassHunter:TestExploits(gamepassId)
    local results = {}
    
    for _, point in ipairs(self.PurchasePoints) do
        local remote = point.object
        
        -- المحاولة 1: إرسال مباشر
        local success1, result1 = pcall(function()
            remote:FireServer(gamepassId)
            return "Sent: " .. gamepassId
        end)
        
        -- المحاولة 2: إرسال كـ table
        local success2, result2 = pcall(function()
            remote:FireServer({
                id = gamepassId,
                gamepassId = gamepassId,
                productId = gamepassId,
                purchase = true,
                bought = true
            })
            return "Sent: Table format"
        end)
        
        -- المحاولة 3: إرسال مع بيانات إضافية
        local success3, result3 = pcall(function()
            remote:FireServer("purchase", gamepassId, game.Players.LocalPlayer)
            return "Sent: With player"
        end)
        
        -- المحاولة 4: إرسال متكرر
        local success4, result4 = pcall(function()
            for i = 1, 3 do
                remote:FireServer(gamepassId)
                task.wait(0.1)
            end
            return "Sent: 3 times"
        end)
        
        -- تسجيل النتائج
        table.insert(results, {
            remote = point.name,
            attempts = {
                direct = success1 and "✓" or "✗",
                table = success2 and "✓" or "✗",
                withPlayer = success3 and "✓" or "✗",
                spam = success4 and "✓" or "✗"
            }
        })
    end
    
    return results
end

-- 3. التحقق من وجود FilteringEnabled=false
function GamepassHunter:CheckFilteringEnabled()
    local workspaceFE = workspace.FilteringEnabled
    
    if workspaceFE == false then
        return {
            status = "VULNERABLE",
            message = "FilteringEnabled is FALSE - Full access!",
            exploit = function()
                -- هنا تقدر تعمل أي حاجة في السيرفر
                -- مثال: صنع part في workspace
                local part = Instance.new("Part")
                part.Name = "HackedPart"
                part.Parent = workspace
                part.Position = Vector3.new(0, 10, 0)
                return "Created part in workspace"
            end
        }
    end
    
    return {status = "SECURE", message = "FilteringEnabled is true"}
end

-- 4. البحث عن RemoteFunctions للشراء
function GamepassHunter:FindRemoteFunctions()
    local functions = {}
    
    for _, func in ipairs(game:GetDescendants()) do
        if func:IsA("RemoteFunction") then
            local lowerName = func.Name:lower()
            if string.find(lowerName, "purchase") or
               string.find(lowerName, "buy") then
                
                table.insert(functions, {
                    object = func,
                    name = func.Name
                })
            end
        end
    end
    
    return functions
end

-- 5. محاولة استغلال RemoteFunctions
function GamepassHunter:TestRemoteFunctions(gamepassId)
    local funcs = self:FindRemoteFunctions()
    local results = {}
    
    for _, func in ipairs(funcs) do
        local remoteFunc = func.object
        
        -- محاولات مختلفة
        local attempts = {
            {call = function() return remoteFunc:InvokeServer("buy", gamepassId) end, name = "buy command"},
            {call = function() return remoteFunc:InvokeServer("purchase", gamepassId) end, name = "purchase command"},
            {call = function() return remoteFunc:InvokeServer(gamepassId) end, name = "direct id"},
            {call = function() return remoteFunc:InvokeServer({id = gamepassId}) end, name = "table id"}
        }
        
        local funcResults = {}
        for _, attempt in ipairs(attempts) do
            local success, result = pcall(attempt.call)
            funcResults[attempt.name] = success and "✓" or "✗"
        end
        
        table.insert(results, {
            function = func.name,
            results = funcResults
        })
    end
    
    return results
end

-- 6. البحث عن BindableEvents
function GamepassHunter:FindBindableEvents()
    local events = {}
    
    for _, event in ipairs(game:GetDescendants()) do
        if event:IsA("BindableEvent") then
            local lowerName = event.Name:lower()
            if string.find(lowerName, "purchase") or
               string.find(lowerName, "gamepass") then
                
                table.insert(events, event)
            end
        end
    end
    
    return events
end

-- 7. واجهة المستخدم
function GamepassHunter:CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Text = "🎯 Gamepass Hunter"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    
    -- Gamepass ID Input
    local IDBox = Instance.new("TextBox")
    IDBox.PlaceholderText = "Enter Gamepass ID"
    IDBox.Size = UDim2.new(0.8, 0, 0, 30)
    IDBox.Position = UDim2.new(0.1, 0, 0.2, 0)
    
    -- Scan Button
    local ScanBtn = Instance.new("TextButton")
    ScanBtn.Text = "🔍 Scan for Vulnerabilities"
    ScanBtn.Size = UDim2.new(0.8, 0, 0, 40)
    ScanBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
    
    -- Exploit Button
    local ExploitBtn = Instance.new("TextButton")
    ExploitBtn.Text = "⚡ Attempt Exploit"
    ExploitBtn.Size = UDim2.new(0.8, 0, 0, 40)
    ExploitBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
    
    -- Results
    local Results = Instance.new("TextLabel")
    Results.Text = "Ready..."
    Results.Size = UDim2.new(0.8, 0, 0, 60)
    Results.Position = UDim2.new(0.1, 0, 0.8, 0)
    Results.TextWrapped = true
    
    -- Button Actions
    ScanBtn.MouseButton1Click:Connect(function()
        self:FindPurchaseVulnerabilities()
        local feStatus = self:CheckFilteringEnabled()
        
        Results.Text = string.format([[
        Found %d purchase points
        FE Status: %s
        RemoteFunctions: %d
        ]], #self.PurchasePoints, feStatus.status, #self:FindRemoteFunctions())
    end)
    
    ExploitBtn.MouseButton1Click:Connect(function()
        local id = tonumber(IDBox.Text)
        if not id then
            Results.Text = "Invalid Gamepass ID"
            return
        end
        
        Results.Text = "Exploiting..."
        
        task.spawn(function()
            -- Test all methods
            local remoteResults = self:TestExploits(id)
            local funcResults = self:TestRemoteFunctions(id)
            local feStatus = self:CheckFilteringEnabled()
            
            local successCount = 0
            for _, result in ipairs(remoteResults) do
                for _, status in pairs(result.attempts) do
                    if status == "✓" then
                        successCount = successCount + 1
                    end
                end
            end
            
            Results.Text = string.format([[
            Exploitation Complete!
            
            Successful Attempts: %d
            Purchase Points: %d
            FE Status: %s
            
            Check console for details
            ]], successCount, #self.PurchasePoints, feStatus.status)
            
            -- Print detailed results
            print("\n=== EXPLOIT RESULTS ===")
            for _, result in ipairs(remoteResults) do
                print("Remote: " .. result.remote)
                for name, status in pairs(result.attempts) do
                    print("  " .. name .. ": " .. status)
                end
            end
        end)
    end)
    
    -- Assemble UI
    Title.Parent = MainFrame
    IDBox.Parent = MainFrame
    ScanBtn.Parent = MainFrame
    ExploitBtn.Parent = MainFrame
    Results.Parent = MainFrame
    MainFrame.Parent = ScreenGui
    
    return ScreenGui
end

-- 8. Auto-scan on startup
function GamepassHunter:AutoScan()
    print("\n=== Gamepass Hunter Started ===")
    
    -- Scan for vulnerabilities
    self:FindPurchaseVulnerabilities()
    
    -- Check FE status
    local feStatus = self:CheckFilteringEnabled()
    
    -- Results
    print(string.format([[
    
    📊 SCAN RESULTS:
    Purchase Points Found: %d
    FilteringEnabled: %s
    RemoteFunctions: %d
    BindableEvents: %d
    
    Commands:
    _G.ScanGamepass(id) - Test specific gamepass
    _G.GetPoints() - Show purchase points
    _G.TestAll(id) - Test all methods
    
    ]], #self.PurchasePoints, 
       feStatus.status, 
       #self:FindRemoteFunctions(),
       #self:FindBindableEvents()))
end

-- Global functions
_G.ScanGamepass = function(id)
    return GamepassHunter:TestExploits(id)
end

_G.GetPoints = function()
    return GamepassHunter.PurchasePoints
end

_G.TestAll = function(id)
    local results = {}
    results.remotes = GamepassHunter:TestExploits(id)
    results.functions = GamepassHunter:TestRemoteFunctions(id)
    results.fe = GamepassHunter:CheckFilteringEnabled()
    return results
end

-- Start
GamepassHunter:AutoScan()
GamepassHunter:CreateUI()

return GamepassHunter
