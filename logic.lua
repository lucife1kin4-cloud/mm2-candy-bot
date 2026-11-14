local Config = require("config")
local Logic = {}

-- Таблица для отслеживания тех, кто уже написал в текущем раунде
local completedAccounts = {}

-- Функция сброса раунда (обнуляет список)
function Logic.ResetRound()
    completedAccounts = {}
    print("[СИСТЕМА] Раунд начался. Ожидание сообщений от 4 аккаунтов...")
end

-- Функция проверки входящего сообщения из чата
function Logic.ProcessMessage(senderUsername, messageText)
    
    -- 1. Проверяем, есть ли отправитель в нашем списке разрешенных 4 аккаунтов
    local isMyAccount = false
    for _, acc in ipairs(Config.Accounts) do
        if acc == senderUsername then
            isMyAccount = true
            break
        end
    end

    -- Если сообщение написал кто-то посторонний — игнорируем
    if not isMyAccount then return end

    -- 2. Проверяем текст сообщения
    if messageText == Config.TargetMessage then
        
        -- Если этот аккаунт еще не отмечался в этом раунде
        if not completedAccounts[senderUsername] then
            completedAccounts[senderUsername] = true

            -- Считаем, сколько аккаунтов уже отписалось
            local count = 0
            for _ in pairs(completedAccounts) do
                count = count + 1
            end

            print(string.format("[ПРОГРЕСС] %s написал фулл. Готово: %d/4", senderUsername, count))

            -- 3. ГЛАВНОЕ УСЛОВИЕ: Проверяем, набралось ли ровно 4 человека
            if count >= #Config.Accounts then
                Logic.TriggerAction()
            end
        end
    end
end

-- Функция, которая сработает, когда ВСЕ ЧЕТВЕРО напишут фразу
function Logic.TriggerAction()
    print("[УСПЕХ] Все четверо написали фулл! Аккаунт с ножом делает резат.")
    
    -- === СЮДА ПОЗЖЕ ДОБАВИМ КОМАНДУ ДЛЯ РЕЗАТА УБИЙЦЫ ===
    
    -- Автоматически сбрасываем раунд для следующего раза
    Logic.ResetRound()
end

return Logic
