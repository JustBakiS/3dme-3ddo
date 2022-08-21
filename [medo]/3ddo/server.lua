ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('do', function(source, args)
    local text = table.concat(args, " ")
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {['@identifier'] = player.identifier}, function(result)
        isim = result[1].firstname .. ' ' .. result[1].lastname
        TriggerClientEvent('3ddo:shareDisplay', -1, isim, text, source)
    end)
end)