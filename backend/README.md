## Vesta Backend

Spring Boot tabanli gecici backend. Firebase baglantisi eklenmedi; veriler su an in-memory tutulur.

### Calistirma

PowerShell:

```powershell
cd "C:\Users\ecehv\OneDrive\Desktop\SS projesi\dayanisma-app\backend"
$env:JAVA_HOME="C:\Program Files\Android\Android Studio\jbr"
.\mvnw.cmd spring-boot:run
```

Backend API adresi:

```text
http://127.0.0.1:8081/api
```

Tek uygulama olarak calistirmak icin proje kokunden:

```powershell
cd "C:\Users\ecehv\OneDrive\Desktop\SS projesi\dayanisma-app"
.\run-app.ps1
```

Uygulama adresi:

```text
http://127.0.0.1:8081
```

### Test

```powershell
cd "C:\Users\ecehv\OneDrive\Desktop\SS projesi\dayanisma-app\backend"
$env:JAVA_HOME="C:\Program Files\Android\Android Studio\jbr"
.\mvnw.cmd test
```

### Tasarim

- `FavoriteEventPublisher` Observer publisher gorevini yapar.
- `NotificationService`, `FavoriteObserver` olarak favori/takip olaylarini dinler.
- `VestaFacade`, birden fazla servisi ilgilendiren akislari sade tutar: ilan guncelleme, silme, talep ve destek.
- Firebase icin ileride `InMemoryStore` yerine repository/adaptor katmani baglanabilir.

### Onemli endpointler

```text
GET    /api/ilanlar
POST   /api/ilanlar
PUT    /api/ilanlar/{id}
DELETE /api/ilanlar/{id}
POST   /api/ilanlar/{id}/talep

GET    /api/favoriler
POST   /api/favoriler/{ilanId}
DELETE /api/favoriler/{ilanId}

GET    /api/bildirimler
GET    /api/mesajlar/sohbetler
POST   /api/mesajlar

GET    /api/users/me
PUT    /api/users/me
POST   /api/destek
```
