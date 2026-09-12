# BRM Redzone & İllegal Satış Alanı Sistemi

FiveM roleplay sunucuları için **ESX**, **QBCore** ve **QBX** tam uyumlu, haritada yarı saydam kırmızı radius çemberi oluşturan, sağ alt köşede doğrudan GTA V native 2D kırmızı gölgeli font ile uyarı veren %100 NUI/HTML bağımsız Redzone sistemi.

## 🌟 Özellikler
- **Büyük Kırmızı Harita Çemberi & İkon**:
  - `Config.Zones` içerisinde tanımlı `vector4` koordinatlarına göre haritada kırmızı şeffaf radius blipi ve özel kuru kafa ikonu.
- **Sağ Alt Köşe Native 2D Gösterge**:
  - **İçerideyken**: Sağ alt köşede kırmızı konturlu `Redzone icindesin` metni (içeride kalındığı sürece ekranda aktif kalır).
  - **Çıkıldığında**: `Redzone cikis [15s]` metni 15 saniye geri sayar ve kaybolur.
- **3 Adet İllegal Satış Konumu**:
  1. Liman İllegal Satış Noktası
  2. Hurdalık İllegal Satış Noktası
  3. Cypress Flats İllegal Satış Noktası
- **Optimizasyon**:
  - `0.00ms` idle CPU tüketimi.
  - HTML / NUI yükü olmadan ultra hafif yapı.

## ⚙️ Kurulum
1. `brm_redzone` klasörünü `resources` klasörünüze ekleyin.
2. `server.cfg` dosyanıza şu satırı ekleyin:
   ```cfg
   ensure brm_redzone
   ```
