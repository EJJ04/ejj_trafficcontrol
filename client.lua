local ESX, QBCore = nil, nil

if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local speedZones = {}

RegisterNetEvent('esx_policejob:createSpeedZoneClient', function(coords, radius, speed)
    local zone = AddRoadNodeSpeedZone(coords.x, coords.y, coords.z, radius + 0.0, speed + 0.0, false)
    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, radius + 0.0)
    SetBlipColour(blip, Config.TrafficBlip.color)
    SetBlipSprite(blip, Config.TrafficBlip.sprite)
    SetBlipAlpha(blip, 80)
    SetBlipDisplay(blip, 6)        

    local streetName = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local formattedStreetName = GetStreetNameFromHashKey(streetName)

    TriggerEvent('chat:addMessage', {
        template = '<div style="padding: 0.5vw; margin: 0.05vw; background-color: rgba({1}, {2}, {3}, {4}); border-radius: 3px;"> <b>' .. Config.Strings.PoliceTag .. ' @</b><br> ' .. Config.Strings.TrafficWarning .. ' <b>{5}</b> ' .. Config.Strings.CautionMessage .. '</div>',
        args = { '', Config.TrafficWarningColor.r, Config.TrafficWarningColor.g, Config.TrafficWarningColor.b, Config.TrafficWarningColor.a, formattedStreetName }
    })

    table.insert(speedZones, {zone = zone, blip = blip})
end)

RegisterNetEvent('esx_policejob:deleteLastSpeedZoneClient', function()
    if #speedZones > 0 then
        local lastZone = speedZones[#speedZones]
        if RemoveRoadNodeSpeedZone(lastZone.zone) then
            RemoveBlip(lastZone.blip)
            table.remove(speedZones)
            lib.notify({
                title = Config.Strings.ZoneRemovedTitle,
                description = Config.Strings.ZoneRemovedDescription,
                type = 'success',
                position = Config.NotifySettings.position,
            })
        else
            lib.notify({
                title = Config.Strings.ErrorTitle,
                description = Config.Strings.ErrorDescription,
                type = 'error',
                position = Config.NotifySettings.position,
            })
        end
    else
        lib.notify({
            title = Config.Strings.NoZonesTitle,
            description = Config.Strings.NoZonesDescription,
            type = 'error',
            position = Config.NotifySettings.position,
        })
    end
end)

function politistoptrafik()
    lib.registerContext({
        id = 'esx_policejob:stoptrafik1',
        title = Config.Strings.TrafficControlTitle,
        options = {
            {
                title = Config.Strings.StopTrafficTitle,
                icon = 'fa-solid fa-traffic-light',
                onSelect = function()
                    local input = lib.inputDialog(Config.Strings.StopTrafficDialogTitle, {
                        {type = 'number', label = Config.Strings.ZoneDiameterLabel, required = true}
                    })

                    if input then
                        local radius = tonumber(input[1])
                        local playerCoords = GetEntityCoords(cache.ped)

                        TriggerServerEvent('esx_policejob:createSpeedZone', playerCoords, radius, 0)
                    end
                end
            },
            {
                title = Config.Strings.SlowTrafficTitle,
                icon = 'fa-solid fa-traffic-light',
                onSelect = function()
                    local input = lib.inputDialog(Config.Strings.SlowTrafficDialogTitle, {
                        {type = 'number', label = Config.Strings.ZoneDiameterLabel, required = true},
                        {type = 'number', label = Config.Strings.SpeedLabel, required = true}
                    })

                    if input then
                        local radius = tonumber(input[1])
                        local speed = tonumber(input[2])
                        local playerCoords = GetEntityCoords(cache.ped)
                        TriggerServerEvent('esx_policejob:createSpeedZone', playerCoords, radius, speed)
                    end
                end
            },
            {
                title = Config.Strings.ResetZoneTitle,
                icon = 'fa-solid fa-power-off',
                onSelect = function()
                    TriggerServerEvent('esx_policejob:deleteLastSpeedZone')
                end
            },
        }
    })

    lib.showContext('esx_policejob:stoptrafik1')
end

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    ESX.PlayerData.job = job
end)

RegisterCommand(Config.TrafficControlCommand.CommandName, function()
    if Config.UseJob then
        if ESX then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.PoliceJob.JobName and not ESX.PlayerData.dead then 
                politistoptrafik()
            end
        elseif QBCore then
            local PlayerData = QBCore.Functions.GetPlayerData()
            if PlayerData.job and PlayerData.job.name == Config.PoliceJob.JobName then
                politistoptrafik()
            end
        else
            print("Error: Neither ESX nor QBCore is detected.")
        end
    else
        politistoptrafik()
    end
end)

exports('politistoptrafik', politistoptrafik)