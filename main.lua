local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local hasReported = false

print("[СИСТЕМА] Бот запущен (режим файлового лога) на: " .. LocalPlayer.Name)

-- Функция записи результата в файл папки workspace
local function saveToFile(text)
    -- Проверяем, поддерживает ли эксплойт запись файлов
    if writefile then
        local fileName = "candy_bot_" .. LocalPlayer.Name .. ".txt"
        pcall(function()
            writefile(fileName, text)
            print("[ФАЙЛ] Результат успешно записан в workspace/" .. fileName)
        end)
    else
        warn("[ОШИБКА]: writefile не поддерживается в текущем окружении!")
    end
end

-- Точный поиск мешка конфет
local function getCandyCount()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return 0 end

    for _, textLabel in ipairs(playerGui:GetDescendants()) do
        if textLabel:IsA("TextLabel") and textLabel.Visible then
            local txt = textLabel.Text
            if txt and txt ~= "" then
                local current, maxVal = txt:match("(%d+)%s*/%s*(%d+)")
                if current and tonumber(maxVal) == 50 then
                    return tonumber(current)
                end
            end
        end
    end
    return 0
end

-- Основной цикл слежения
task.spawn(function()
    while true do
        task.wait(1.5)
        if not hasReported then
            local candies = getCandyCount()

            if candies >= 50 then 
                hasReported = true
                local logText = string.format("Аккаунт: %s | Статус: Собрано 50/50 конфет | Время: %os", LocalPlayer.Name, os.date("%H:%M:%S"))
                print("[ГОТОВО] Мешок полон! Сохраняем в файл...")
                saveToFile(logText)
            end
        end
    end
end)
