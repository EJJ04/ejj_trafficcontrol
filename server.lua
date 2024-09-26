lib.locale()

local speedZones = {}

local function sendNotification(src, messageKey, titleKey, type)
    local message = locale(messageKey) 
    local title = locale(titleKey) 
    TriggerClientEvent('ox_lib:notify', src, {
        title = title,
        description = message,
        type = type
    })
end

RegisterNetEvent('ejj_trafficcontrol:createSpeedZone', function(coords, radius, speed)
    local src = source
    local zoneId = #speedZones + 1 
    speedZones[zoneId] = {coords = coords, radius = radius, speed = speed}

    sendNotification(src, locale('speed_zone_created'), locale('speed_zone_title'), 'success') 
    TriggerClientEvent('ejj_trafficcontrol:createSpeedZoneClient', -1, coords, radius, speed)
end)

RegisterNetEvent('ejj_trafficcontrol:deleteSpeedZone', function(zoneIndex)
    local src = source

    if speedZones[zoneIndex] then
        TriggerClientEvent('ejj_trafficcontrol:deleteSpeedZoneClient', -1, zoneIndex)
        sendNotification(src, locale('speed_zone_deleted'), locale('speed_zone_title'), 'success') 
        speedZones[zoneIndex] = nil
    else
        sendNotification(src, locale('speed_zone_not_exist'), locale('error_title'), 'error')
    end
end)