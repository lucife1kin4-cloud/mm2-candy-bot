local WebhookURL = "https://discord.com/api/webhooks/1562905252364161104/PnmNqsvbTTIw2PdZG_3EmnxoC-jirFEnMKgMwkDZLdVL6TkfLVOPWzTJG_MJTma6nBrD"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local hasReported = false
local lastCandies = -1

print("[СИСТЕМА] Бот запущен на аккаунте: " .. LocalPlayer.Name)

local function sendToDiscord(text)
    local reqFunc = (syn and syn.request) or request or (http and http.request)
    if reqFunc then
        reqFunc({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({ content = text })
        })
    else
        pcall(function()
            HttpService:PostAsync(
                WebhookURL,
                HttpService:JSONEncode({ content = text }),
                Enum.HttpContentType.ApplicationJson
            )
        end)
    end
end

local function getCandyCount()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return 0 end

    for _, textLabel in ipairs(playerGui:GetDescendants()) do
        if textLabel:IsA("TextLabel") and textLabel.Visible then
            local txt = textLabel.Text
            if txt and txt ~= "" and txt:match("%d+") then
                local num = tonumber(txt:match("^%d+$"))
                if num and num > 0 and num <= 100 then
                    return num
                end
                
                local current = txt:match("(%d+)/")
                if current then
                    return tonumber(current)
                end
            end
        end
    end
    return 0
end

task.spawn(function()
    while true do
        task.wait(1)
        if not hasReported then
            local candies = getCandyCount()
            
            -- Выводим в консоль только при изменении числа
            if candies > 0 and candies ~= lastCandies then
                lastCandies = candies
                print(string.format("[ПРОГРЕСС] %s собрал: %d конфет", LocalPlayer.Name, candies))
            end

            -- Отправка в Discord ровно при 50 конфет
            if candies >= 50 then 
                hasReported = true
                local message = string.format("🟢 %s собрал 50 конфет!", LocalPlayer.Name)
                print("[ДИСКОРД] Сбор завершен, отправка отчета...")
                sendToDiscord(message)
            end
        end
    end
end)
