lib.locale()

local ESX, QBCore = nil, nil

if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local speedZones = {}

RegisterNetEvent('ejj_trafficcontrol:createSpeedZoneClient', function(coords, radius, speed)
    local zone = {
        id = AddRoadNodeSpeedZone(coords.x, coords.y, coords.z, radius + 0.0, speed + 0.0, false),  
        coords = {x = coords.x, y = coords.y, z = coords.z}  
    }
    
    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, radius + 0.0)  
    SetBlipColour(blip, Config.TrafficBlip.color)
    SetBlipSprite(blip, Config.TrafficBlip.sprite)
    SetBlipAlpha(blip, 80)
    SetBlipDisplay(blip, 6)

    local streetName = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local formattedStreetName = GetStreetNameFromHashKey(streetName)

    TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; margin: 0.05vw; background-color: rgba({1}, {2}, {3}, {4}); border-radius: 3px;"> <b>' .. locale('police_tag') .. ' @</b><br> ' .. locale('traffic_warning') .. ' <b>{5}</b> ' .. locale('caution_message') .. '</div>',
        args = { '', Config.TrafficWarningColor.r, Config.TrafficWarningColor.g, Config.TrafficWarningColor.b, Config.TrafficWarningColor.a, formattedStreetName }
    })

    table.insert(speedZones, {zone = zone, blip = blip})  
end)

RegisterNetEvent('ejj_trafficcontrol:deleteSpeedZoneClient', function(zoneIndex)
    if speedZones[zoneIndex] then
        local zone = speedZones[zoneIndex]
        if RemoveRoadNodeSpeedZone(zone.zone.id) then  
            RemoveBlip(zone.blip)
            table.remove(speedZones, zoneIndex)
        end
    end
end)

RegisterNetEvent('ejj_trafficcontrol:deleteSpeedZoneNotify', function()
    lib.notify({
        title = locale('zone_removed_title'),
        description = locale('zone_removed_description'),
        type = 'success',
        position = Config.NotifySettings.position,
    })
end)

RegisterNetEvent('ejj_trafficcontrol:deleteSpeedZoneErrorNotify', function()
    lib.notify({
        title = locale('error_title'),
        description = locale('error_description'),
        type = 'error',
        position = Config.NotifySettings.position,
    })
end)

function OpenTrafficMenu()
    lib.registerContext({
        id = 'ejj_trafficcontrol:stoptrafik1',
        title = locale('traffic_control_title'),
        options = {
            {
                title = locale('stop_traffic_title'),
                icon = 'fa-solid fa-traffic-light',
                onSelect = function()
                    local input = lib.inputDialog(locale('stop_traffic_dialog_title'), {
                        {type = 'number', label = locale('zone_diameter_label'), required = true}
                    })

                    if input then
                        local radius = tonumber(input[1]) + 0.0  
                        local playerCoords = GetEntityCoords(cache.ped)

                        TriggerServerEvent('ejj_trafficcontrol:createSpeedZone', playerCoords, radius, 0)
                    end
                end
            },
            {
                title = locale('slow_traffic_title'),
                icon = 'fa-solid fa-traffic-light',
                onSelect = function()
                    local input = lib.inputDialog(locale('slow_traffic_dialog_title'), {
                        {type = 'number', label = locale('zone_diameter_label'), required = true},
                        {type = 'number', label = locale('speed_label'), required = true}
                    })

                    if input then
                        local radius = tonumber(input[1]) + 0.0  
                        local speed = tonumber(input[2]) + 0.0  
                        local playerCoords = GetEntityCoords(cache.ped)
                        TriggerServerEvent('ejj_trafficcontrol:createSpeedZone', playerCoords, radius, speed)
                    end
                end
            },
            {
                title = locale('reset_zone_title'),
                icon = 'fa-solid fa-power-off',
                onSelect = function()
                    local playerCoords = GetEntityCoords(cache.ped)
                    local zoneIndex = nil

                    for index, zone in ipairs(speedZones) do
                        if IsPointInZone(playerCoords, zone) then
                            zoneIndex = index
                            break
                        end
                    end

                    if zoneIndex then
                        TriggerServerEvent('ejj_trafficcontrol:deleteSpeedZone', zoneIndex)
                    else
                        lib.notify({
                            title = locale('no_zones_title'),
                            description = locale('no_zones_description'),
                            type = 'error',
                            position = Config.NotifySettings.position,
                        })
                    end
                end
            },
        }
    })

    lib.showContext('ejj_trafficcontrol:stoptrafik1')
end

function IsPointInZone(coords, zone)
    local zoneCoords = zone.zone.coords  
    local radius = zone.zone.radius or 10.0  
    return Vdist(coords.x, coords.y, coords.z, zoneCoords.x, zoneCoords.y, zoneCoords.z) <= radius
end

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData.job = job
end)

RegisterCommand(Config.TrafficControlCommand.CommandName, function()
    if Config.UseJob then
        if ESX then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.PoliceJob.JobName and not ESX.PlayerData.dead then 
                OpenTrafficMenu()
            end
        elseif QBCore then
            local PlayerData = QBCore.Functions.GetPlayerData()
            if PlayerData.job and PlayerData.job.name == Config.PoliceJob.JobName then
                OpenTrafficMenu()
            end
        else
            print("Error: Neither ESX nor QBCore is detected.")
        end
    else
        OpenTrafficMenu()
    end
end)

exports('OpenTrafficMenu', OpenTrafficMenu)