-- 🎯 Targeted Gamepass Exploit
-- Specific to: PlayerGui.BuyTokens.Frame.Products.Amt3.Buy

local player = game.Players.LocalPlayer

print("🎯 TARGET LOCKED: BuyTokens -> Amt3")

-- الوصول المباشر للزر
local function AccessTargetButton()
    local success, button = pcall(function()
        -- الطريق المباشر
        local path = {
            player.PlayerGui,
            player.PlayerGui.BuyTokens,
            player.PlayerGui.BuyTokens.Frame,
            player.PlayerGui.BuyTokens.Frame.Products,
            player.PlayerGui.BuyTokens.Frame.Products.Amt3,
            player.PlayerGui.BuyTokens.Frame.Products.Amt3.Buy
        }
        
        -- التأكد من كل خطوة
        for i, step in ipairs(path) do
            if i > 1 then
                wait()
                if not path[i-1]:FindFirstChild(step.Name) then
                    return nil, "Path broken at: " .. step.Name
                end
            end
        end
        
        return path[6], "✅ Path intact"
    end)
    
    return success and button, success and "Button found" or "Button not found"
end

-- استراتيجيات الاستغلال
local function ExecuteExploit(targetButton)
    print("⚡ Executing targeted exploit...")
    
    local results = {}
    
    -- 1. تغيير السعر إذا كان ظاهر
    if targetButton.Parent then
        for _, child in pairs(targetButton.Parent:GetChildren()) do
            if child:IsA("TextLabel") and (child.Name == "Price" or child.Name == "Cost") then
                child.Text = "FREE"
                child.TextColor3 = Color3.new(0, 1, 0)
                table.insert(results, "💰 Price changed to FREE")
            elseif (child:IsA("IntValue") or child:IsA("NumberValue")) and 
                   (child.Name == "Price" or child.Name == "Cost") then
                child.Value = 0
                table.insert(results, "💰 Price value set to 0")
            end
        end
    end
    
    -- 2. محاكاة الضغط
    if targetButton:IsA("TextButton") or targetButton:IsA("ImageButton") then
        -- تغيير المظهر
        targetButton.Text = "PURCHASED ✓"
        targetButton.BackgroundColor3 = Color3.new(0, 1, 0)
        targetButton.TextColor3 = Color3.new(1, 1, 1)
        
        -- إرسال أحداث
        pcall(function() targetButton:Fire("MouseButton1Click") end)
        pcall(function() targetButton:Fire("Activated") end)
        
        table.insert(results, "🖱️ Button click simulated")
    end
    
    -- 3. البحث عن RemoteEvents المرتبطة
    local function FindRelatedRemotes()
        local relatedRemotes = {}
        local buttonName = targetButton.Name
        
        -- البحث في كل مكان
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local name = obj.Name:lower()
                if name:find("buy") or name:find("purchase") or 
                   name:find("token") or name:find(buttonName:lower()) then
                    table.insert(relatedRemotes, obj)
                end
            end
        end
        
        return relatedRemotes
    end
    
    -- 4. إرسال طلبات شراء
    local remotes = FindRelatedRemotes()
    for _, remote in ipairs(remotes) do
        pcall(function()
            -- محاولات مختلفة
            local attempts = {
                "Amt3",
                3,  -- عدد التوكنز
                {product = "Amt3", purchased = true},
                {id = "Amt3", amount = 3}
            }
            
            for _, data in ipairs(attempts) do
                remote:FireServer(data)
                table.insert(results, "📡 Request to: " .. remote.Name)
                wait(0.05)
            end
        end)
    end
    
    return results
end

-- الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local title = Instance.new("TextLabel")
title.Text = "🎯 Targeted Exploit"
title.Size = UDim2.new(1, 0, 0.2, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
title.TextColor3 = Color3.new(1, 1, 1)

local status = Instance.new("TextLabel")
status.Text = "Target: Amt3 Token Purchase"
status.Size = UDim2.new(1, 0, 0.3, 0)
status.Position = UDim2.new(0, 0, 0.2, 0)
status.TextColor3 = Color3.new(1, 1, 1)
status.BackgroundTransparency = 1

local exploitBtn = Instance.new("TextButton")
exploitBtn.Text = "⚡ EXPLOIT NOW"
exploitBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
exploitBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
exploitBtn.BackgroundColor3 = Color3.new(1, 0.5, 0)
exploitBtn.TextColor3 = Color3.new(1, 1, 1)

local resultText = Instance.new("TextLabel")
resultText.Text = ""
resultText.Size = UDim2.new(1, 0, 0.3, 0)
resultText.Position = UDim2.new(0, 0, 0.75, 0)
resultText.TextColor3 = Color3.new(0, 1, 0)
resultText.BackgroundTransparency = 1
resultText.TextWrapped = true

-- تجميع الواجهة
title.Parent = frame
status.Parent = frame
exploitBtn.Parent = frame
resultText.Parent = frame
frame.Parent = screenGui

-- حدث الزر
exploitBtn.MouseButton1Click:Connect(function()
    exploitBtn.Text = "🎯 TARGETING..."
    resultText.Text = ""
    
    local button, msg = AccessTargetButton()
    status.Text = msg
    
    if button then
        exploitBtn.Text = "⚡ EXPLOITING..."
        local results = ExecuteExploit(button)
        
        resultText.Text = table.concat(results, "\n")
        status.Text = "✅ Exploit completed!"
        exploitBtn.Text = "🎯 RETARGET"
    else
        resultText.Text = "❌ Failed to access button"
        exploitBtn.Text = "⚡ EXPLOIT NOW"
    end
end)

print("🎯 Targeted exploit ready!")
print("🔧 Path: PlayerGui.BuyTokens.Frame.Products.Amt3.Buy")
print("💡 Press the button to exploit")
