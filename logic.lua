local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/lucife1kin4-cloud/mm2-candy-bot/refs/heads/main/config.lua"))()
local Logic = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local hasReported = false

-- Функция отправки в Discord через Solara (request)
local function sendToDiscord(text)
    local HttpService = game:GetService("HttpService")
    local requestFunc = syn and syn.request or request
    
    if requestFunc then
        pcall(function()
            requestFunc({
                Url = Config.WebhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({content = text})
            })
        end)
    else
        pcall(function()
            HttpService:PostAsync(
                Config.WebhookURL,
                HttpService:JSONEncode({content = text}),
                Enum.HttpContentType.ApplicationJson
            )
        end)
    end
end

function Logic.ResetRound()
    hasReported = false
    print("[СИСТЕМА] Раунд начался. Ждем 50 конфет в мешке...")
end

-- Чтение мешка конфет
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

-- Фоновый цикл проверки
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

return Logic -- САМАЯ ВАЖНАЯ СТРОЧКА, ЧТОБЫ main.lua ВИДЕЛ ЛОГИКУ
