local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/lucife1kin4-cloud/mm2-candy-bot/refs/heads/main/config.lua"))()
local Logic = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local hasReported = false

-- Функция отправки в Discord
local function sendToDiscord(text)
    local HttpService = game:GetService("HttpService")
    local success, err = pcall(function()
        HttpService:PostAsync(
            Config.WebhookURL,
            HttpService:JSONEncode({ content = text }),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    if not success then
        warn("[ОШИБКА ДИСКОРДА]: " + tostring(err))
    end
end

function Logic.ResetRound()
    hasReported = false
    print("[СИСТЕМА] Раунд начался. Ждем 50 конфет...")
end

-- Автоматический поиск конфет на экране или в статистике
local function getCandyCount()
    -- Пробуем найти число конфет в стандартных UI элементов MM2 или leaderstats
    local stats = LocalPlayer:FindFirstChild("leaderstats")
    if stats then
        local candies = stats:FindFirstChild("Candies") or stats:FindFirstChild("Конфеты")
        if candies then
            return candies.Value
        end
    end
    
    -- Альтернативный поиск по интерфейсу игры, если лидерапки нет
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        -- Можно пройтись по тексту GUI, но обычно в MM2 они в leaderstats или в баре ивента
    end
    
    return 0
end

-- Запускаем бесконечный цикл проверки прямо в фоновом режиме
task.spawn(function()
    while true do
        task.wait(1)
        if not hasReported then
            local candies = getCandyCount()
            if candies >= 50 then
                hasReported = true
                
                -- Автоматически шлем в Discord отчет от этого аккаунта
                local infoText = string.format("🟢 %s собрал 50 конфет!", LocalPlayer.Name)
                print(infoText)
                sendToDiscord(infoText)
            end
        end
    end
end)

return Logic
