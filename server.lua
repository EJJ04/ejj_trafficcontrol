RegisterNetEvent('esx_policejob:createSpeedZone', function(coords, radius, speed)
    local src = source
    TriggerClientEvent('esx_policejob:createSpeedZoneClient', -1, coords, radius, speed)
end)

RegisterNetEvent('esx_policejob:deleteLastSpeedZone', function()
    local src = source
    TriggerClientEvent('esx_policejob:deleteLastSpeedZoneClient', -1)
end)