-- КОНФИГУРАЦИЯ
local WebhookURL = "https://discord.com/api/webhooks/1562905252364161104/PnmNqsvbTTIw2PdZG_3EmnxoC-jirFEnMKgMwkDZLdVL6TkfLVOPWzTJG_MJTma6nBrD"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local hasReported = false

print("[СИСТЕМА] Бот успешно запущен на аккаунте: " .. LocalPlayer.Name)

-- Функция отправки в Discord
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

-- Точный поиск конфет в мешке
local function getCandyCount()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return 0 end

    -- Поиск по всем текстовым элементам на экране
    for _, textLabel in ipairs(playerGui:GetDescendants()) do
        if textLabel:IsA("TextLabel") and textLabel.Visible then
            local current = textLabel.Text:match("(%d+)%s*/%s*50")
            if current then
                return tonumber(current)
            end
        end
    end
    return 0
end

-- Основной цикл слежения
task.spawn(function()
    print("[СИСТЕМА] Сканер мешка конфет активен. Ждем 50 конфет...")
    while true do
        task.wait(1)
        if not hasReported then
            local candies = getCandyCount()
            
            if candies > 0 then
                print("[МЕШОК] Конфет у " .. LocalPlayer.Name .. ": " .. tostring(candies))
            end

            if candies >= 50 then
                hasReported = true
                local message = string.format("🟢 %s собрал 50/50 конфет!", LocalPlayer.Name)
                print("[ДИСКОРД] Отправка отчета...")
                sendToDiscord(message)
            end
        end
    end
end)
