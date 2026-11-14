local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/lucife1kin4-cloud/mm2-candy-bot/refs/heads/main/config.lua"))()
local Logic = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local hasReported = false

-- Рабочая отправка в Discord для Solara
local function sendToDiscord(text)
    local reqFunc = (syn and syn.request) or request or (http and http.request)
    
    if reqFunc then
        reqFunc({
            Url = Config.WebhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = game:GetService("HttpService"):JSONEncode({ content = text })
        })
    else
        pcall(function()
            game:GetService("HttpService"):PostAsync(
                Config.WebhookURL,
                game:GetService("HttpService"):JSONEncode({ content = text }),
                Enum.HttpContentType.ApplicationJson
            )
        end)
    end
end

function Logic.ResetRound()
    hasReported = false
    print("[СИСТЕМА] Раунд начался. Мониторим мешок...")
end

-- Чтение конфет из мешка
local function getCandyFromBag()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return 0 end

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

-- Фоновый цикл
task.spawn(function()
    while true do
        task.wait(1)
        if not hasReported then
            local candies = getCandyFromBag()
            if candies >= 50 then
                hasReported = true
                local infoText = string.format("🟢 %s собрал 50 конфет!", LocalPlayer.Name)
                print("[ДИСКОРД] Отправка сообщения...")
                sendToDiscord(infoText)
            end
        end
    end
end)

return Logic
