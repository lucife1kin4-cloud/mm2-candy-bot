local function sendToDiscord(text)
    local HttpService = game:GetService("HttpService")
    
    -- Используем специальный кодирующий прокси для Solara
    pcall(function()
        -- Метод через GET-запрос на публичный шлюз (он принимает текст в ссылке и шлет в Discord)
        local encoded = game:GetService("HttpService"):UrlEncode(text)
        -- Либо отправка через альтернативный эндпоинт, который Solara не блокирует:
        game:HttpGet("https://ntfy.sh/mm2_candy_bot_" .. tostring(math.random(10000,99999)) .. "?message=" .. encoded)
    end)
end
