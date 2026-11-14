local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/lucife1kin4-cloud/mm2-candy-bot/refs/heads/main/config.lua"))()
local Logic = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local hasReported = false

local function sendToDiscord(text)
    local HttpService = game:GetService("HttpService")
    pcall(function()
        HttpService:PostAsync(
            Config.WebhookURL,
            HttpService:JSONEncode({ content = text }),
            Enum.HttpContentType.ApplicationJson
        )
    end)
end

function Logic.ResetRound()
    hasReported = false
    print("[СИСТЕМА] Раунд начался. Ждем 50 конфет в мешке...")
end

-- Функция точного чтения мешка Никилиса
local function getCandyFromBag()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return 0 end

    -- 1. Прямой поиск в официальных GUI элементах MM2
    local mainGui = playerGui:FindFirstChild("MainGUI") or playerGui:FindFirstChild("ScreenGui")
    if mainGui then
        -- Проверяем контейнеры иконки мешка
        for _, obj in ipairs(mainGui:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Visible then
                -- Ищем формат "50/50" или "45/50"
                local current, max = obj.Text:match("(%d+)%s*/%s*(%d+)")
                if current and max then
                    return tonumber(current)
                end
                -- Ищем просто число возле слова Candy/Container
                if obj.Name:lower():find("candy") or obj.Parent.Name:lower():find("candy") or obj.Parent.Name:lower():find("bag") then
                    local num = tonumber(obj.Text:match("%d+"))
                    if num then return num end
                end
            end
        end
    end

    -- 2. Глобальный фолбек по всему PlayerGui
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
                print("[ДИСКОРД] Отправка отчета...")
                sendToDiscord(infoText)
            end
        end
    end
end)

return Logic
