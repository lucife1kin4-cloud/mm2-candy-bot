-- Загружаем конфиг и логику напрямую с твоего GitHub
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/lucife1kin4-cloud/mm2-candy-bot/refs/heads/main/config.lua"))()
local Logic = loadstring(game:HttpGet("https://raw.githubusercontent.com/lucife1kin4-cloud/mm2-candy-bot/refs/heads/main/logic.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("[ИНИЦИАЛИЗАЦИЯ] Скрипт запущен на: " .. LocalPlayer.Name)

-- Проверка ножа у убийцы
local function isMurderer()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Knife") then return true end
    if backpack and backpack:FindFirstChild("Knife") then return true end
    return false
end

Logic.ResetRound()

-- Дополнительное действие при триггере (когда все 4 отписались)
local originalTrigger = Logic.TriggerAction
if originalTrigger then
    Logic.TriggerAction = function()
        originalTrigger()
        if isMurderer() then
            print("[ДЕЙСТВИЕ] Я УБИЙЦА! Делаю резат.")
            -- LocalPlayer.Character.Humanoid.Health = 0 -- код резата, если нужен
        else
            print("[ОЖИДАНИЕ] Я мирный.")
        end
    end
end
