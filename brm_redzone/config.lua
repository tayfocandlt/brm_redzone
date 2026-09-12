Config = {}

Config.Framework = 'auto'

Config.ExitDisplayTime = 15

Config.SoundEffects = true

Config.Text = {
    inside = 'Redzone icindesin',
    exit = 'Redzone cikis [%ss]',
    x = 0.975,
    y = 0.935,
    scale = 0.95,
    alignRight = true,
    insideColor = { r = 230, g = 20, b = 20, a = 255 },
    exitColor = { r = 240, g = 150, b = 20, a = 255 }
}

Config.Map = {
    radiusAlpha = 85
}

Config.DrawGroundMarker = true
Config.MarkerDrawDistance = 150.0
Config.MarkerHeight = 4.0
Config.MarkerAlpha = 35

Config.Zones = {
    [1] = {
        name = 'İllegal Satış Bölgesi #1 (Liman)',
        coords = vector4(892.45, -3172.15, 5.9, 90.0),
        radius = 85.0,
        blip = {
            enable = true,
            sprite = 437,
            scale = 0.85,
            color = 1,
            label = 'Redzone - İllegal Satış (Liman)'
        }
    },
    [2] = {
        name = 'İllegal Satış Bölgesi #2 (Hurdalık)',
        coords = vector4(2414.55, 3098.85, 48.15, 180.0),
        radius = 95.0,
        blip = {
            enable = true,
            sprite = 437,
            scale = 0.85,
            color = 1,
            label = 'Redzone - İllegal Satış (Hurdalık)'
        }
    },
    [3] = {
        name = 'İllegal Satış Bölgesi #3 (Cypress)',
        coords = vector4(981.35, -2125.65, 30.45, 270.0),
        radius = 75.0,
        blip = {
            enable = true,
            sprite = 437,
            scale = 0.85,
            color = 1,
            label = 'Redzone - İllegal Satış (Cypress)'
        }
    }
}
