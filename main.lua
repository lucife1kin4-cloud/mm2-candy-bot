local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/lucife1kin4-cloud/mm2-candy-bot/refs/heads/main/config.lua"))()
local Logic = loadstring(game:HttpGet("https://raw.githubusercontent.com/lucife1kin4-cloud/mm2-candy-bot/refs/heads/main/logic.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

print("[ИНИЦИАЛИЗАЦИЯ] Скрипт запущен на: " .. LocalPlayer.Name)

if type(Logic) == "table" and Logic.ResetRound then
    Logic.ResetRound()
else
    warn("[ОШИБКА] Таблица Logic не загрузилась!")
end
