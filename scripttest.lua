-- Base64 Encoded Script
local encoded = "IyA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KIyBTVEVBTFRIIFRPS0VOIFBVUkNIQVNFLiB7QXV0aG9yPSJZb3VyTmFtZSJ9CiMgTW9iaWxlOiBsb2Fkc3RyaW5nKGdhbWU6R2V0SHR0cCgiIikpKCkKIyA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KCmxvY2FsIGY9ZnVuY3Rpb24oKQogICAgcmV0dXJuIGdhbWU6R2V0U2VydmljZSgiUGxheWVycyIpCmVuZAoKbG9jYWwgcD1mKCkubG9jYWxwbGF5ZXIKd2hpbGUgbm90IHAgZG8gdGFzay53YWl0KCkgZW5kCgp0YXNrLndhaXQoMC41KQoKbG9jYWwgdz1wLldhaXRGb3JDaGlsZCgiUGxheWVyR3VpIikKbG9jYWwgdD1mdW5jdGlvbigpCiAgICByZXR1cm4gdy5GaW5kRmlyc3RDaGlsZCgiQnV5VG9rZW5zIix0cnVlKQplbmQKCi0tIE1haW4gZnVuY3Rpb24KbG9jYWwgYz1mdW5jdGlvbigpCiAgICBsb2NhbCByPXQoKQogICAgaWYgciB0aGVuCiAgICAgICAgbG9jYWwgZT1yLkZpbmRGaXJzdENoaWxkKCJGcmFtZSIsdHJ1ZSkKICAgICAgICBpZiBlIHRoZW4KICAgICAgICAgICAgbG9jYWwgYj1lLkZpbmRGaXJzdENoaWxkKCJQcm9kdWN0cyIsdHJ1ZSkKICAgICAgICAgICAgaWYgYiB0aGVuCiAgICAgICAgICAgICAgICBsb2NhbCBzPWIuRmluZEZpcnN0Q2hpbGQoIkFtdDMiLHRydWUpCiAgICAgICAgICAgICAgICBpZiBzIHRoZW4KICAgICAgICAgICAgICAgICAgICBsb2NhbCB1PXMuRmluZEZpcnN0Q2hpbGQoIkJ1eSIsdHJ1ZSkKICAgICAgICAgICAgICAgICAgICBpZiB1IGFuZCB1LklzQSgiVGV4dEJ1dHRvbiIpIHRoZW4KICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHUKICAgICAgICAgICAgICAgICAgICBlbmQKICAgICAgICAgICAgICAgIGVuZAogICAgICAgICAgICBlbmQKICAgICAgICBlbmQKICAgIGVuZAogICAgcmV0dXJuIG5pbAplbmQKCi0tIEV4ZWN1dGlvbgpsb2NhbCBvPWMoKQppZiBvIHRoZW4KICAgIG8uVGV4dD0iRlJFRSEhIgogICAgby5CYWNrZ3JvdW5kQ29sb3I9Q29sb3IzLmZyb21SR0IoMCwyNTUsMCkKICAgIGZvciBpPTEsMyBkbwogICAgICAgIG8uQWN0aXZhdGVkOkZpcmUoKQogICAgICAgIHRhc2sud2FpdCgwLjIpCiAgICBlbmQKZW5kCgppZiB3IGFuZCB3LkZpbmRGaXJzdENoaWxkKCJCdXlUb2tlbnMiLHRydWUpIHRoZW4KICAgIHByaW50KCJDbGllbnQgZGV0ZWN0ZWQuIikKZW5kCg=="

-- فك التشفير وتنفيذ
local function decodeBase64(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

-- تنفيذ عند الطلب فقط
local executed = false
local function executeOnCommand()
    if not executed then
        local success, err = pcall(function()
            loadstring(decodeBase64(encoded))()
        end)
        if success then
            print("✅ Script executed")
        else
            print("❌ Error:", err)
        end
        executed = true
    end
end

-- واجهة للتحكم
local gui = Instance.new("ScreenGui")
gui.Name = "DevControl"
gui.Parent = p:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.Parent = gui

local btn = Instance.new("TextButton")
btn.Text = "🔒 Run Security Test"
btn.Size = UDim2.new(0.9, 0, 0, 40)
btn.Position = UDim2.new(0.05, 0, 0.1, 0)
btn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
btn.Parent = frame

btn.MouseButton1Click:Connect(executeOnCommand)

print("🔐 Security testing script loaded")
print("ℹ️ Press button to run test")
