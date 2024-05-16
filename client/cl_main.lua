local Renewed = exports['Renewed-Lib']:getLib()
local closestDesk = nil
local CurrentCops = 0
local doctorCount = 0
PlayerData = QBX.PlayerData.job
PlayerJob = QBX.PlayerData.job

-- Front Desk Target Zones

local function nearestDesk()
    for k in pairs(Config.Locations) do
        local Pos = GetEntityCoords(cache.ped)
        local Distance = #(Pos - vec3(Config.Locations[k].zone.coords.xyz))
        if Distance < 5 then
            closestDesk = k
        end
    end
    return closestDesk
end


local function FrontDeskZones()
    for _, v in pairs(Config.Locations) do
        Renewed.addPed({
            model = 'a_f_y_business_01',
            dist = 30,
            coords = v.zone.coords,
            heading = v.zone.heading,
            freeze = true,
            invincible = true,
            tempevents = true,
            scenario = false,
            id = v.zone.name,
            target = {
                {
                    name = v.zone.name,
                    icon = 'fas fa-desktop',
                    label = "Front Desk",
                    onSelect = function()
                        local location = nearestDesk()
                        OpenFrontDesk(location)
                    end,
                }
            }
        })
    end
end

-----------------------------------------
------------ Front Desk Menu ------------
-----------------------------------------
function OpenFrontDesk(job)
    local FrontDeskMenu = {}

    FrontDeskMenu[#FrontDeskMenu + 1] = {
        title = 'Assistance menu',
        description = 'Get assistance',
        icon = 'fas fa-desktop',
        event = 'frontdesk:client:OpenAssistanceMenu',
        args = job
    }
    lib.registerContext({
        id = 'frontdesk_menu',
        title = Config.Locations[job].zone.name,
        options = FrontDeskMenu
    })
    lib.showContext('frontdesk_menu')
end

-----------------------------------------
----------- Toggle Duty Event -----------
-----------------------------------------
RegisterNetEvent('frontdesk:client:ToggleDuty', function(job)
    TriggerServerEvent('QBCore:ToggleDuty')
end)

-----------------------------------------
------------ Assistance Menu ------------
-----------------------------------------
RegisterNetEvent('frontdesk:client:OpenAssistanceMenu', function(job)
    local AssistanceMenu = {}
    for _, s in pairs(Config.Locations[job].Menu) do
        AssistanceMenu[#AssistanceMenu + 1] = {
            title = s.title,
            description = s.description,
            icon = s.icon,
            event = s.event,
            args = { type = s.Args, job = job }
        }
    end

    lib.registerContext({
        id = 'assistance_menu',
        title = 'Assistance Menu',
        menu = 'frontdesk_menu',
        options = AssistanceMenu
    })
    lib.showContext('assistance_menu')
end)

----------------------------------------
------------ Dispatch Alert ------------
----------------------------------------

local function createCustomAlert(data)
    local playerData = QBX.PlayerData
    local coords = GetEntityCoords(cache.ped)
    local alertData = {
        coords = data.job == 'police' and Config.Locations.police.zone.coords or Config.Locations.ambulance.zone.coords,
        job = { data.job },
        message = '',
        dispatchCode = '10-60',
        firstStreet = coords,
        name = playerData.charinfo.firstname .. ' ' .. playerData.charinfo.lastname,
        description = '',
        radius = 0,
        sprite = 205,
        color = 2,
        scale = 1.0,
        length = 3,
    }
    if data.type == 'assistance' then
        alertData.message = 'Assistance Required'
        alertData.description = 'Assistance Required'
    elseif data.type == 'interview' then
        alertData.message = 'Interview Request'
        alertData.description = 'Interview Request'
    elseif data.type == 'weaponlicense' then
        alertData.message = 'Weapon License Request'
        alertData.description = 'Weapon License Request'
    elseif data.type == 'supervisor' then
        alertData.message = 'Supervisor Request'
        alertData.description = 'Supervisor Request'
    end

    exports['ps-dispatch']:CustomAlert(alertData)
end

------------------------------------------------
----------- Request Assistance Event -----------
------------------------------------------------
RegisterNetEvent('frontdesk:client:RequestAssistance', function(data)
    local alert = lib.callback.await('frontdesk:server:coolDownCheck', false, data.job)
    if alert then
        if Config.Dispatch == 'ps-dispatch' then
            if data.job == 'police' then
                if CurrentCops >= Config.Locations[data.job].Required then
                    exports.qbx_core:Notify('You will be assisted shortly!', 'success')
                    createCustomAlert(data)
                    TriggerServerEvent('frontdesk:server:AlertCooldown', data.job, true)
                else
                    exports.qbx_core:Notify('Not enough officers on duty!', 'error', 5000)
                end
            elseif data.job == 'ambulance' then
                if doctorCount >= Config.Locations[data.job].Required then
                    exports.qbx_core:Notify('You will be assisted shortly!', 'success')
                    createCustomAlert(data)
                    TriggerServerEvent('frontdesk:server:AlertCooldown', data.job, true)
                else
                    exports.qbx_core:Notify('Not enough doctors on duty!', 'error', 3000)
                end
            end
        else
            ---- [Add Other Disptach Here]
        end
    else
        exports.qbx_core:Notify('Alert was recently sent, please wait!', 'error', 7500)
    end
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('hospital:client:SetDoctorCount', function(amount)
    doctorCount = amount
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBX.PlayerData
    PlayerJob = QBX.PlayerData.job
    FrontDeskzones()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == cache.resource then
        PlayerData = QBX.PlayerData
        PlayerJob = QBX.PlayerData.job
        FrontDeskZones()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == cache.resource then
        for i = 1, #Config.Locations do
            local location = Config.Locations[i]
            Renewed.removePed(location.zone.name)
        end
    end
end)
