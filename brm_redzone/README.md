# BRM Redzone & İllegal Satış Alanı Sistemi

FiveM roleplay sunucuları için **ESX**, **QBCore** ve **QBX** tam uyumlu, haritada yarı saydam kırmızı radius çemberi oluşturan, sağ alt köşede doğrudan GTA V native 2D kırmızı gölgeli font ile uyarı veren %100 NUI/HTML bağımsız Redzone sistemi.

## 🌟 Özellikler
- **Framework uyumlu yapı**:
  - `Config.Framework = 'auto'` ile **ESX**, **QBCore**, **QBX** ve standalone sunucularda otomatik çalışma.
  - Framework kaynakları sonradan başlasa veya yeniden başlasa bile sunucu tarafında algılama güncellenir.
- **Büyük kırmızı harita çemberi & ikon**:
  - `Config.Zones` içinde tanımlı her alan için yarı saydam kırmızı radius blipi oluşturur.
  - İsteğe bağlı ikon blipi ile bölge adı haritada gösterilir.
- **Sağ alt köşe native 2D gösterge**:
  - **İçerideyken**: GTA V native font ile kırmızı gölgeli `Redzone icindesin`.
  - **Çıkıldığında**: `Redzone cikis [15s]` geri sayımı.
  - Tamamen **NUI/HTML bağımsızdır**.
- **Yer marker desteği**:
  - Bölgeye yaklaşınca zeminde kırmızı yarı saydam marker görünür.
- **Export desteği**:
  - Client: oyuncunun redzone durumunu ve aktif bölgeyi alabilirsiniz.
  - Server: aktif framework bilgisini ve zone listesini alabilirsiniz.
- **Optimizasyon**:
  - Uzakta daha uzun `Wait` süreleri kullanır.
  - Hafif, native tabanlı ve ek UI bağımlılığı gerektirmez.

## 📁 Dosya Yapısı
```text
brm_redzone/
├── client/main.lua
├── server/main.lua
├── config.lua
└── fxmanifest.lua
```

## ⚙️ Kurulum
1. `brm_redzone` klasörünü `resources` klasörünüze ekleyin.
2. `server.cfg` dosyanıza şu satırı ekleyin:
   ```cfg
   ensure brm_redzone
   ```
3. Gerekirse `config.lua` içinden framework ve zone ayarlarınızı düzenleyin.

## 🛠️ Konfigürasyon

### Framework seçimi
```lua
Config.Framework = 'auto'
```

Desteklenen değerler:
- `auto`
- `esx`
- `es_extended`
- `qb`
- `qb-core`
- `qbcore`
- `qbx`
- `qbx_core`
- `standalone`

> Not: Alias değerler kullanılsa bile `GetFramework()` export'u her zaman normalize edilmiş şu değerlerden birini döndürür: `esx`, `qb`, `qbx`, `standalone`.

### Yazı ayarları
```lua
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
```

- `inside`: Bölge içindeyken gösterilen metin
- `exit`: Çıkış geri sayım metni; `%ss` kullanırsanız `15s`, `%s` kullanırsanız `15` olarak değiştirilir
- `x`, `y`, `scale`: Native HUD konum ve ölçek ayarları
- `alignRight`: Yazıyı sağ hizalı tutar
- `insideColor`, `exitColor`: RGBA renk yapılandırması

### Harita ve marker ayarları
```lua
Config.Map = {
    radiusAlpha = 85
}

Config.DrawGroundMarker = true
Config.MarkerDrawDistance = 150.0
Config.MarkerHeight = 4.0
Config.MarkerAlpha = 35
```

### Zone ekleme
```lua
Config.Zones = {
    {
        name = 'Ornek Redzone',
        coords = vector4(100.0, 200.0, 30.0, 0.0),
        radius = 75.0,
        blip = {
            enable = true,
            sprite = 437,
            scale = 0.85,
            color = 1,
            label = 'Redzone - Ornek'
        }
    }
}
```

## 📦 Export'lar

### Client exports
```lua
local isInside, zoneIndex = exports['brm_redzone']:IsPlayerInRedzone()
local zoneData, currentIndex = exports['brm_redzone']:GetCurrentRedzone()
```

### Server exports
```lua
local zones = exports['brm_redzone']:GetRedzoneList()
local framework = exports['brm_redzone']:GetFramework()
```

## ✅ Uyum
- ESX
- QBCore
- QBX
- Standalone
