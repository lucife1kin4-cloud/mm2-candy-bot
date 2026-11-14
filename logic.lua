local Config = require("config")
local Logic = {}

local completedAccounts = {}

-- Функция сброса раунда
function Logic.ResetRound()
    completedAccounts = {}
    print("[СИСТЕМА] Раунд начался. Ожидание готовности 4 аккаунтов...")
end

-- Функция отправки сообщения в твой Discord через вебхук
local function sendToDiscord(text)
    local HttpService = game:GetService("HttpService")
    
    local data = {
        content = text
    }
    
    local success, err = pcall(function()
        HttpService:PostAsync(
            Config.WebhookURL,
            HttpService:JSONEncode(data),
            Enum.HttpContentType.ApplicationJson
        )
    end)
    
    if not success then
        warn("[ОШИБКА ДИСКОРДА]: " .. tostring(err))
    end
end

-- Обработка отчета от аккаунта
function Logic.ReportReady(accountName, messageText)
    -- Проверяем, наш ли это аккаунт
    local isMyAccount = false
    for _, acc in ipairs(Config.Accounts) do
        if acc == accountName then
            isMyAccount = true
            break
        end
    end

    if not isMyAccount then return end

    if messageText == Config.TargetMessage then
        if not completedAccounts[accountName] then
            completedAccounts[accountName] = true

            local count = 0
            for _ in pairs(completedAccounts) do
                count = count + 1
            end

            local infoText = string.format("🟢 %s сообщил: %s (%d/4)", accountName, messageText, count)
            print(infoText)
            
            -- Отправляем статус в Discord канал
            sendToDiscord(infoText)

            -- ГЛАВНОЕ УСЛОВИЕ: Когда все четверо готовы
            if count >= #Config.Accounts then
                Logic.TriggerAction()
            end
        end
    end
end

-- Когда все собрались
function Logic.TriggerAction()
    local successText = "🚀 Все 4 аккаунта написали фулл! Аккаунт с ножом делает резат."
    print(successText)
    sendToDiscord(successText)
    
    -- === СЮДА ПОЗЖЕ ВСТАВИМ КОМАНДУ ДЛЯ РЕЗАТА ===

    Logic.ResetRound()
end

return Logic
