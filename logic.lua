local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/lucife1kin4-cloud/mm2-candy-bot/refs/heads/main/config.lua"))()
local Logic = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local hasReported = false

-- Надежная отправка через прокси для обхода блокировок Solara
local function sendToDiscord(text)
    local HttpService = game:GetService("HttpService")
    
    -- Кодируем текст для ссылки
    local encodedText = text:gsub(" ", "%%20")
    
    -- Используем публичный публичный шлюз/прокси, который точно не режется Соларой
    local proxyUrl = "https://ntfy.sh/mm2_bot_" .. tostring(math.random(1000,9999)) -- запасной вариант или через webhook-переходник
    
    -- Но проще всего черезпрямой вызов с кодированием на Discord-вебхук через webhook.lewagon.workers.dev (бесплатный воркер-прокси)
    pcall(function()
        -- Отправляем через публичный прокси-агент для Roblox-эксплойтов
        game:HttpGet("https://api.webhook.site/token") -- просто прогрев или отправка POST через GET-запрос с параметрами
    end)

    -- Самый надежный способ для Solara без реквестов — использовать сторонний сервис логов, 
    -- ИЛИ отправить через встроенный HttpService с заголовками, если Solara их пропускает:
    local success, err = pcall(function()
        -- Пробуем через симуляцию запроса на webhook через rconsole или прокси
        local requestFunc = syn and syn.request or request
        if requestFunc then
            requestFunc({
                Url = Config.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({content = text})
            })
        else
            -- Если request вообще нет, шлем через GET на наш фоновый шлюз
            game:HttpGet("https://ntfy.sh/mm2_candy_bot_alert_" .. LocalPlayer.Name .. "?message=" .. encodedText)
        end
    end)
    
    if not success then
        print("[ДИСКОРД ОШИБКА]:", err)
    end
end
