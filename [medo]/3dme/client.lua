local pedDisplaying = {}

function DrawText3D(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 350
    local scale = scale * fov
    if onScreen then
          SetTextScale(0.40, 0.40)
          SetTextFont(0)
          SetTextProportional(1)
          SetTextOutline(5)
          SetTextColour(153, 51, 255, 255)
          SetTextEntry("STRING")
          SetTextCentre(1)
          AddTextComponentString(text)
          DrawText(_x,_y)
          --local factor = (string.len(text)) / 350
          --DrawRect(_x,_y+0.0135, 0.010+ factor, 0.03, 0, 0, 0, 195)
      end
  end
  

function Display(ped, text, isim)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)
    if dist <= 50 then
        TriggerEvent('chat:addMessage', {template = '<div class="chat-message system"><b>' .. isim .. '</b>: /me ' .. text .. '</div>'})   
        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1
        local display = true
        Citizen.CreateThread(function()
            Wait(7000)
            display = false
        end)
        local offset = 0.2 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(x, y, z, text)
            end
            Wait(0)
        end
        pedDisplaying[ped] = pedDisplaying[ped] - 1
    end
end

RegisterNetEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(isim, text, serverId)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        Display(ped, text, isim)
    end
end)

TriggerEvent('chat:addSuggestion', '/me', 'Eylem belirtmek için emote kullanımı.', { name = 'action', help = '"scratch his nose" for example.'})