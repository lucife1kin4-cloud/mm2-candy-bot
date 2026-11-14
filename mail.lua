local Config = require("config")
local Logic = require("logic")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("[ИНИЦИАЛИЗА] Скрипт авто-фарма MM2 успешно запущен на аккаунте: " .. LocalPlayer.Name)

-- Функция для проверки: является ли текущий аккаунт убийцей (есть ли нож)
local function isMurderer()
    -- Проверяем инвентарь (Backpack) и руки (Character)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    
    if character and character:FindFirstChild("Knife") then
        return true
    end
    if backpack and backpack:FindFirstChild("Knife") then
        return true
    end
    
    return false
end

-- Основной цикл раунда
Logic.ResetRound()

-- Имитация/вызов отправки готовности
-- (Когда аккаунт собирает 50 конфет, он вызывает эту функцию)
function _G.SendCandyFullReport()
    local myUsername = LocalPlayer.Name
    Logic.ReportReady(myUsername, Config.TargetMessage)
end

-- === ДОПОЛНИТЕЛЬНО: ПРОВЕРКА РОЛИ ПРИ ТРИГГЕРЕ ===
-- Когда logic.lua даст сигнал TriggerAction(), сработает этот блок:
local originalTrigger = Logic.TriggerAction
Logic.TriggerAction = function()
    originalTrigger()
    
    -- Проверяем, у нашего ли аккаунта нож прямо сейчас
    if isMurderer() then
        print("[ДЕЙСТВИЕ] Я УБИЙЦА! Все 4 аккаунта отписались. Делаю резат!")
        -- Сюда ставится авто-резат (reset/kill)
    else
        print("[ОЖИДАНИЕ] Я мирный/шериф. Резат делает убийца.")
    end
end
