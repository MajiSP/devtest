local npcPed = {x = 0.0, y = 0.0, z = 0.0, h = 0.0}
local cooldown = 10
local playersTransformed = {}

RegisterServerEvent('transformPed')
AddEventHandler('transformPed', function(model)
    local player = source
    if not playersTransformed[player] then
        playersTransformed[player] = true
        TriggerClientEvent('transformPed', player, model)
        Wait(cooldown * 60000)
        playersTransformed[player] = nil
    else
        exports['LRP_Notify']:DisplayNotification("The doctor is currently busy washing their hands...", 3000)
    end
end)

RegisterServerEvent('getPlayerCoords')
AddEventHandler('getPlayerCoords', function()
    local player = source
    TriggerClientEvent('receivePlayerCoords', player, npcPed)
end)
