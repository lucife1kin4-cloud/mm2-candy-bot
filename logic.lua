local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/lucife1kin4-cloud/mm2-candy-bot/refs/heads/main/config.lua"))()
local Logic = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local hasReported = false

-- Надежная отправка через request (работает в Solara)
local function sendToDiscord(text)
    local HttpService = game:GetService("HttpService")
    
    -- Проверяем доступность функции запроса в эксплойте (Solara поддерживает request)
    local req = syn and syn.request or request or http and http.request or HttpPost
    
    if req then
        local success, err = pcall(function()
            req({
                Url = Config.WebhookURL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode({ content = text })
            })
        end)
        if not success then
            warn("[ОШИБКА HTTP]: " .. tostring(err))
        end
    else
        -- Запасной вариант через стандартный PostAsync
        pcall(function()
            HttpService:PostAsync(
                Config.WebhookURL,
                HttpService:JSONEncode({ content = text }),
                Enum.HttpContentType.ApplicationJson
            )
        end)
    end
end

function Logic.ResetRound()
    hasReported = false
    print("[СИСТЕМА] Раунд начался. Ждем 50 конфет в мешке...")
end

-- Точное чтение мешка Никилиса
local function getCandyFromBag()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return 0 end

    local mainGui = playerGui:FindFirstChild("MainGUI") or playerGui:FindFirstChild("ScreenGui")
    if mainGui then
        for _, obj in ipairs(mainGui:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Visible then
                local current, max = obj.Text:match("(%d+)%s*/%s*(%d+)")
                if current and max then
                    return tonumber(current)
                end
            end
        end
    end

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

-- Цикл проверки
task.spawn(function()
    while true do
        task.wait(1)
        if not hasReported then
            local candies = getCandyFromBag()
            
            if candies > 0 then
                print("[МЕШОК] Конфет в мешке:", candies)
            end

            if candies >= 50 then
                hasReported = true
                local infoText = string.format("🟢 %s собрал 50 конфет!", LocalPlayer.Name)
                print("[ДИСКОРД] Отправка отчета через Solara...")
                sendToDiscord(infoText)
            end
        end
    end
end)

return Logic
