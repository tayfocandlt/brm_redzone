local Framework = nil
local FrameworkAliases = {
    ['esx'] = 'esx',
    ['es_extended'] = 'esx',
    ['qb'] = 'qb',
    ['qb-core'] = 'qb',
    ['qbcore'] = 'qb',
    ['qbx'] = 'qbx',
    ['qbx_core'] = 'qbx',
    ['standalone'] = 'standalone'
}

local function IsAutoFramework()
    return not Config.Framework or Config.Framework == 'auto'
end

local function DetectFramework()
    if not IsAutoFramework() then
        Framework = FrameworkAliases[Config.Framework] or 'standalone'
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
    if not IsAutoFramework() and resourceName ~= GetCurrentResourceName() then
        return
    end

    if resourceName == GetCurrentResourceName() or resourceName == 'qbx_core' or resourceName == 'qb-core' or resourceName == 'es_extended' then
        DetectFramework()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if not IsAutoFramework() then
        return
    end

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
