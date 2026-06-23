# Vesta Backend

Java 17 ve Spring Boot ile çalışan REST API'dir. Veriler JDBC üzerinden
Supabase PostgreSQL veritabanında tutulur.

## Çalıştırma

`backend/.env.example` dosyasını `backend/.env` olarak kopyalayın ve
`SUPABASE_DB_PASSWORD` değerini girin.

```powershell
cd backend
$env:JAVA_HOME="C:\Program Files\Android\Android Studio\jbr"
.\mvnw.cmd spring-boot:run
```

API adresi:

```text
http://127.0.0.1:8081/api
```

## Test

```powershell
cd backend
$env:JAVA_HOME="C:\Program Files\Android\Android Studio\jbr"
.\mvnw.cmd test
```

## Temel Endpointler

```text
POST   /api/auth/register
POST   /api/auth/login

GET    /api/ilanlar
POST   /api/ilanlar
PUT    /api/ilanlar/{id}
DELETE /api/ilanlar/{id}

GET    /api/favoriler
POST   /api/favoriler/{ilanId}
DELETE /api/favoriler/{ilanId}

GET    /api/mesajlar/sohbetler
POST   /api/mesajlar

GET    /api/bildirimler
GET    /api/takas-istekleri/gelen

GET    /api/users/me
PUT    /api/users/me
DELETE /api/users/me
```
