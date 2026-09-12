local Framework = nil

local function DetectFramework()
    if Config.Framework and Config.Framework ~= 'auto' then
        Framework = Config.Framework
    elseif GetResourceState('qbx_core') == 'started' then
        Framework = 'qbx'
    elseif GetResourceState('qb-core') == 'started' then
        Framework = 'qb'
    elseif GetResourceState('es_extended') == 'started' then
        Framework = 'esx'
    else
        Framework = 'standalone'
    end
end

CreateThread(function()
    DetectFramework()
end)

exports('GetRedzoneList', function()
    return Config.Zones
end)
