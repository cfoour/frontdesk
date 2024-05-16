local serverCooldown = {}

----------------------------------------------
------------ Coldown for each job ------------
----------------------------------------------

RegisterServerEvent('frontdesk:server:AlertCooldown', function(job, bool)
    if serverCooldown[job] == nil then serverCooldown[job] = false end
    if bool then
        serverCooldown[job] = true

        SetTimeout((Config.Cooldown * 60000), function()
            serverCooldown[job] = false
        end)
    end
end)

----------------------------------------------
--------------- Coldown Check ----------------
----------------------------------------------

lib.callback.register('frontdesk:server:coolDownCheck',function(source, job)
    local callback = false

    if not serverCooldown[job] then callback = true end
    return callback
end)
