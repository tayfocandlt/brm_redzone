local Framework = nil

local function NormalizeFrameworkName(framework)
    local aliases = {
        ['qb'] = 'qbcore',
        ['qb-core'] = 'qbcore',
        ['qbcore'] = 'qbcore',
        ['qbx'] = 'qbx',
        ['qbx_core'] = 'qbx',
        ['esx'] = 'esx',
        ['es_extended'] = 'esx',
        ['standalone'] = 'standalone'
    }

    return aliases[framework] or framework
end

local function DetectFramework()
    if Config.Framework and Config.Framework ~= 'auto' then
        local normalizedFramework = NormalizeFrameworkName(Config.Framework)
        Framework = normalizedFramework == 'qbcore' and 'qb' or normalizedFramework
    elseif GetResourceState('qbx_core') == 'started' then
        Framework = 'qbx'
    elseif GetResourceState('qb-core') == 'started' then
        Framework = 'qb'
    elseif GetResourceState('es_extended') == 'started' then
        Framework = 'esx'
    else
        Framework = 'standalone'
    end

    return Framework
end

CreateThread(function()
    DetectFramework()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() or resourceName == 'qbx_core' or resourceName == 'qb-core' or resourceName == 'es_extended' then
        DetectFramework()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == 'qbx_core' or resourceName == 'qb-core' or resourceName == 'es_extended' then
        DetectFramework()
    end
end)

exports('GetRedzoneList', function()
    return Config.Zones
end)

exports('GetFramework', function()
    return Framework or DetectFramework()
end)
