local WebhookURL = "https://discord.com/api/webhooks/1562905252364161104/PnmNqsvbTTIw2PdZG_3EmnxoC-jirFEnMKgMwkDZLdVL6TkfLVOPWzTJG_MJTma6nBrD"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local hasReported = false

print("[СИСТЕМА] Диагностика запущена на аккаунте: " .. LocalPlayer.Name)

local function sendToDiscord(text)
    local reqFunc = (syn and syn.request) or request or (http and http.request)
    if reqFunc then
        reqFunc({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({ content = text })
        })
    end
end

-- Сканируем и выводим ВСЕ тексты, чтобы найти правильный
local function getCandyCount()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return 0 end

    for _, textLabel in ipairs(playerGui:GetDescendants()) do
        if textLabel:IsA("TextLabel") and textLabel.Visible then
            local txt = textLabel.Text
            -- Если в тексте есть хоть какие-то цифры и он не пустой
            if txt and txt ~= "" and txt:match("%d+") then
                -- Выводим в консоль все найденные надписи с цифрами, чтобы понять, где именно мешок
                -- print("[GUI ТЕКСТ]:", txt)
                
                -- Пробуем найти просто число конфет
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
        task.wait(2)
        if not hasReported then
            local candies = getCandyCount()
            if candies > 0 then
                print(string.format("[ТЕСТ] Найдено число у %s: %d", LocalPlayer.Name, candies))
            end

            -- Измени здесь на сколько тебе нужно (например, когда аккаунт заканчивает фарм)
            if candies >= 45 then 
                hasReported = true
                local message = string.format("🟢 %s собрал конфеты (текущее: %d)!", LocalPlayer.Name, candies)
                print("[ДИСКОРД] Отправка отчета...")
                sendToDiscord(message)
            end
        end
    end
end)
