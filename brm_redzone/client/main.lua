local currentZoneIndex = nil
local isInsideRedzone = false
local exitTimerEnd = 0
local zoneBlips = {}
local textConfig = Config.Text or {}

local function GetZoneCenter(zone)
    return vector3(zone.coords.x, zone.coords.y, zone.coords.z)
end

local function Coalesce(value, default)
    if value == nil then
        return default
    end

    return value
end

local function ReplaceFirstLiteral(text, token, replacement)
    local startPos, endPos = text:find(token, 1, true)
    if not startPos then
        return nil
    end

    return text:sub(1, startPos - 1) .. replacement .. text:sub(endPos + 1)
end

local function GetTextColor(state)
    local fallback = { r = 255, g = 255, b = 255, a = 255 }
    return textConfig[state] or fallback
end

local function BuildExitMessage(secondsLeft)
    local template = textConfig.exit

    if type(template) ~= 'string' or template == '' then
        return 'Redzone cikis [' .. secondsLeft .. 's]'
    end

    local replacedMessage = ReplaceFirstLiteral(template, '%ss', tostring(secondsLeft) .. 's')
    if replacedMessage then
        return replacedMessage
    end

    replacedMessage = ReplaceFirstLiteral(template, '%s', tostring(secondsLeft))
    if replacedMessage then
        return replacedMessage
    end

    return template .. ' [' .. secondsLeft .. 's]'
end

local function DrawRedzoneText(text, x, y, scale, r, g, b, a)
    local alignRight = textConfig.alignRight ~= false

    SetTextFont(4)
    SetTextProportional(true)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(2, 2, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextOutline()
    SetTextRightJustify(alignRight)
    if alignRight then
        SetTextWrap(0.0, x)
    else
        SetTextWrap(x, 1.0)
    end
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

local function CreateRedzoneBlips()
    for i, zone in ipairs(Config.Zones) do
        local center = GetZoneCenter(zone)

        local radiusBlip = AddBlipForRadius(center.x, center.y, center.z, zone.radius)
        SetBlipRotation(radiusBlip, 0)
        SetBlipColour(radiusBlip, 1)
        SetBlipAlpha(radiusBlip, Coalesce(Config.Map and Config.Map.radiusAlpha, 85))

        local iconBlip = nil
        if zone.blip and zone.blip.enable then
            iconBlip = AddBlipForCoord(center.x, center.y, center.z)
            SetBlipSprite(iconBlip, zone.blip.sprite or 437)
            SetBlipDisplay(iconBlip, 4)
            SetBlipScale(iconBlip, zone.blip.scale or 0.85)
            SetBlipColour(iconBlip, zone.blip.color or 1)
            SetBlipAsShortRange(iconBlip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(zone.blip.label or zone.name)
            EndTextCommandSetBlipName(iconBlip)
        end

        zoneBlips[i] = {
            radius = radiusBlip,
            icon = iconBlip
        }
    end
end

local function OnEnterRedzone(zoneIdx)
    local zone = Config.Zones[zoneIdx]
    if not zone then return end

    isInsideRedzone = true
    currentZoneIndex = zoneIdx
    exitTimerEnd = 0

    if Config.SoundEffects then
        PlaySoundFrontend(-1, 'CHECKPOINT_PERFECT', 'HUD_MINI_GAME_SOUNDSET', 1)
    end
end

local function OnExitRedzone()
    isInsideRedzone = false
    currentZoneIndex = nil
    exitTimerEnd = GetGameTimer() + ((Config.ExitDisplayTime or 15) * 1000)

    if Config.SoundEffects then
        PlaySoundFrontend(-1, 'CANCEL', 'HUD_MINI_GAME_SOUNDSET', 1)
    end
end

CreateThread(function()
    CreateRedzoneBlips()

    while true do
        local sleep = 750
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)
        local foundZoneIndex = nil

        for i, zone in ipairs(Config.Zones) do
            local zCoords = GetZoneCenter(zone)
            local dist = #(pCoords - zCoords)

            if dist <= zone.radius then
                foundZoneIndex = i
                sleep = 150
                break
            elseif dist <= (zone.radius + 60.0) then
                sleep = 250
            end
        end

        if foundZoneIndex ~= nil then
            if not isInsideRedzone or currentZoneIndex ~= foundZoneIndex then
                OnEnterRedzone(foundZoneIndex)
            end
        else
            if isInsideRedzone then
                OnExitRedzone()
            end
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 500

        if isInsideRedzone then
            sleep = 0
            local color = GetTextColor('insideColor')
            DrawRedzoneText(
                Coalesce(textConfig.inside, 'Redzone icindesin'),
                Coalesce(textConfig.x, 0.975),
                Coalesce(textConfig.y, 0.935),
                Coalesce(textConfig.scale, 0.95),
                Coalesce(color.r, 230),
                Coalesce(color.g, 20),
                Coalesce(color.b, 20),
                Coalesce(color.a, 255)
            )
        elseif exitTimerEnd > GetGameTimer() then
            sleep = 0
            local leftSec = math.ceil((exitTimerEnd - GetGameTimer()) / 1000)
            local color = GetTextColor('exitColor')
            local message = BuildExitMessage(leftSec)
            DrawRedzoneText(
                message,
                Coalesce(textConfig.x, 0.975),
                Coalesce(textConfig.y, 0.935),
                Coalesce(textConfig.scale, 0.95),
                Coalesce(color.r, 240),
                Coalesce(color.g, 150),
                Coalesce(color.b, 20),
                Coalesce(color.a, 255)
            )
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    if not Config.DrawGroundMarker then return end

    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)

        for i, zone in ipairs(Config.Zones) do
            local zCoords = GetZoneCenter(zone)
            local dist = #(pCoords - zCoords)

            if dist <= (zone.radius + (Config.MarkerDrawDistance or 150.0)) then
                sleep = 0
                DrawMarker(
                    1,
                    zCoords.x, zCoords.y, zCoords.z - 1.0,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    zone.radius * 2.0, zone.radius * 2.0, Coalesce(Config.MarkerHeight, 4.0),
                    239, 68, 68, Coalesce(Config.MarkerAlpha, 35),
                    false, false, 2, false, nil, nil, false
                )
            end
        end

        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    for _, b in pairs(zoneBlips) do
        if b.radius and DoesBlipExist(b.radius) then
            RemoveBlip(b.radius)
        end
        if b.icon and DoesBlipExist(b.icon) then
            RemoveBlip(b.icon)
        end
    end
end)

exports('IsPlayerInRedzone', function()
    return isInsideRedzone, currentZoneIndex
end)

exports('GetCurrentRedzone', function()
    return currentZoneIndex and Config.Zones[currentZoneIndex] or nil, currentZoneIndex
end)
