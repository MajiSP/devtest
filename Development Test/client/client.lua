local pedModels = {
    "a_m_m_acult_01",
    "a_m_m_beach_01",
    "a_m_m_business_01",
    "a_m_m_eastsa_01",
    "a_m_m_fatlatin_01"
}

local playerCoords = nil

RegisterNetEvent('transformPed')
AddEventHandler('transformPed', function(model)
    local pedHash = GetHashKey(model)
    RequestModel(pedHash)
    while not HasModelLoaded(pedHash) do
        Wait(1)
    end
    SetPlayerModel(PlayerId(), pedHash)
    SetModelAsNoLongerNeeded(pedHash)
end)

RegisterNetEvent('receivePlayerCoords')
AddEventHandler('receivePlayerCoords', function(coords)
    playerCoords = coords
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - vector3(playerCoords.x, playerCoords.y, playerCoords.z))

        if distance < 2 then
            DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z, "Press ~g~E~w~ to open the menu")
            if IsControlJustPressed(0, 38) then
                TriggerServerEvent('getPlayerCoords')
                while playerCoords == nil do
                    Wait(1)
                end
                OpenMenu()
            end
        end
    end
end)

function OpenMenu()
    local elements = {}
    for i = 1, #pedModels do
        table.insert(elements, {label = pedModels[i], value = pedModels[i]})
    end
    ESX.UI.Menu.Open('default', devtest(), 'transform_ped_menu', {
        title    = "Transform into a new ped",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()
        TriggerServerEvent('transformPed', data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    SetTextScale(0.0*scale, 0.35*scale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("Change Your Appearance")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 100)
end
