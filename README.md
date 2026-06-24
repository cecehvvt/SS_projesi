# Vesta Eng Version

Vesta is a social solidarity platform that enables users to donate unused items, create need requests, and communicate directly with one another.

## Tech Stack

- **Frontend (Mobile/Web):** Flutter
- **Backend:** Java 17 & Spring Boot
- **Database:** Supabase PostgreSQL

---

## About the Project

Vesta connects people who have unused items with those who need them through a simple and community-focused platform.

Users can create donation listings, share their needs, browse available items, communicate directly with other users, and support sustainable consumption by giving usable items a second life.

---

## Problem Statement

Many usable items remain unused because there is no organized and reliable platform that connects donors with people in need. At the same time, individuals seeking assistance often struggle to find a common space where they can share their needs and communicate with potential donors.

Vesta addresses this problem by providing:

- Donation listings for unused items
- Need request listings
- Category, condition, and urgency filtering
- Direct messaging between users
- Item exchange (trade) requests
- Favorites and notifications
- Reduced waste through item reuse

---

## Features

### User Management
- User registration and login
- Profile editing
- Profile photo management
- Account deletion

### Listings
- Create donation listings
- Create need request listings
- Category filtering
- Item condition filtering
- Urgency filtering
- Favorite listings

### Communication
- User-to-user messaging
- Trade request system
- Accept or reject trade offers
- Notification system

### Support
- Help center
- Frequently Asked Questions (FAQ)

---

## Requirements

Before running the project, make sure the following tools are installed:

- Flutter SDK
- Java 17 (or Android Studio JBR)
- Android Studio & Android SDK
- Git
- Google Chrome
- Supabase Database Credentials

Verify installations:

```powershell
flutter doctor
java -version
git --version
```

---



## Quick Start

Open the Vesta development shell:

```powershell
.\dev-shell.cmd
```

The script automatically:

- Opens the correct working directory
- Starts backend services when needed
- Configures API URLs
- Executes `adb reverse` for Android devices
- Cleans stale Flutter processes

---

## Available Devices

```powershell
flutter devices
```

---

## Run on Chrome

```powershell
flutter run -d chrome
```

---

## Run on Microsoft Edge

```powershell
flutter run -d edge
```

---

### Flutter Analyze

```powershell
cd mobile
flutter analyze
```

### Flutter Tests

```powershell
cd mobile
flutter test
```

### Backend Tests

```powershell
cd backend

$env:JAVA_HOME="C:\Program Files\Android\Android Studio\jbr"

.\mvnw.cmd test
```

---

## Frequently Used Commands

```powershell
# Open development shell
.\dev-shell.cmd

# List connected devices
flutter devices

# Run on Chrome
flutter run -d chrome

# Run on Android
flutter run -d DEVICE_ID
```

---

## Troubleshooting

### Device Not Detected

```powershell
flutter doctor
adb devices
flutter devices
```

Make sure USB debugging is enabled and authorized.

---


### Flutter Build Directory Locked

Close all Flutter and browser sessions and restart the development shell:

```powershell
.\dev-shell.cmd

flutter run -d chrome
```

---

### Missing Dependencies

```powershell
cd mobile

flutter pub get
```

---

## Project Goal

Vesta aims to create a reliable and accessible community platform where unused items can reach people who need them, reducing waste while encouraging social solidarity and sustainable consumption.

# Vesta Tr Version

Vesta; kullanılmayan eşyaların bağışlanmasını, ihtiyaç ilanlarının paylaşılmasını ve kullanıcıların iletişim kurmasını sağlayan bir dayanışma uygulamasıdır.

Proje üç ana bölümden oluşur:

- **Mobil/Web:** Flutter
- **Backend API:** Java 17 ve Spring Boot
- **Veritabanı:** Supabase PostgreSQL
- 
## Proje Hakkında

Vesta, kullanılmayan eşyalar ile bu eşyalara ihtiyaç duyan kişileri aynı platformda buluşturan sosyal dayanışma uygulamasıdır. Kullanıcılar bağış ilanı oluşturabilir, ihtiyaçlarını paylaşabilir ve diğer kullanıcılarla doğrudan iletişim kurabilir.

## Çözdüğü Problem

Kullanılabilir durumdaki pek çok eşya, ihtiyaç sahiplerine ulaştırılabilecek düzenli ve güvenilir bir kanal bulunamadığı için değerlendirilememektedir. Aynı zamanda ihtiyaç sahipleri, aradıkları ürünleri paylaşabilecekleri ve bağışçılarla doğrudan iletişim kurabilecekleri ortak bir platform bulmakta zorlanabilmektedir.

Vesta bu soruna şu imkânlarla çözüm sunar:

- Kullanılmayan eşyaların bağış ilanı olarak paylaşılması
- Kullanıcıların ihtiyaç ilanı oluşturabilmesi
- İlanların kategori, ürün durumu ve aciliyet bilgilerine göre filtrelenmesi
- Bağışçı ve ihtiyaç sahibinin doğrudan mesajlaşabilmesi
- İlanlara takas isteği gönderilebilmesi
- Favori ve bildirim özellikleriyle ilanların kolayca takip edilmesi
- Kullanılabilir eşyaların yeniden değerlendirilerek israfın azaltılması

## Özellikler

- Kullanıcı kaydı ve giriş
- Profil ve profil fotoğrafı düzenleme
- Bağış ve ihtiyaç ilanı oluşturma
- Ürün durumu ve aciliyet filtreleri
- Favorilere ilan ekleme
- Kullanıcılar arasında mesajlaşma
- Takas isteği gönderme, onaylama ve reddetme
- Bildirimleri görüntüleme
- Yardım ve sıkça sorulan sorular
- Hesap ve ilişkili kullanıcı verilerini silme

## Gereksinimler

Projeyi çalıştırmak için aşağıdaki araçlar gereklidir:

- Flutter SDK
- Java 17 veya Android Studio JBR
- Android Studio ve Android SDK
- Google Chrome
- Git
- Supabase veritabanı bilgileri

Kurulumları kontrol etmek için:

```powershell
flutter doctor
java -version
git --version
```

## Veritabanı Ayarı

Örnek ortam dosyasını kopyalayın:

```powershell
Copy-Item "backend\.env.example" "backend\.env"
```

`backend\.env` dosyasını açıp Supabase veritabanı şifresini girin:

```properties
SUPABASE_DB_PASSWORD=GERCEK_SUPABASE_SIFRESI
```

Gerekirse bağlantı bilgileri de tanımlanabilir:

```properties
SUPABASE_DB_URL=jdbc:postgresql://aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require
SUPABASE_DB_USER=postgres.rqhylrxkbxmvdromdwlt
```

> `backend/.env` gizli bilgiler içerir ve GitHub'a gönderilmez.

## Kolay Çalıştırma

Proje kök dizininde Vesta geliştirme terminalini açın:

```powershell
.\dev-shell.cmd
```

Bu komut:

- Terminali doğru `mobile` klasöründe açar.
- Flutter komutlarını Vesta çalışma sistemi üzerinden yürütür.
- Backend'i gerektiğinde otomatik başlatır.
- API adresini otomatik ayarlar.
- Android için `adb reverse` işlemini otomatik gerçekleştirir.
- Önceki Flutter çalışmasından kalan kilitli süreçleri temizler.

## Kullanılabilir Cihazları Görme

Vesta terminalinde:

```powershell
flutter devices
```

## Chrome'da Çalıştırma

```powershell
flutter run -d chrome
```

Backend ve API bağlantısı otomatik hazırlanır.

## Edge'de Çalıştırma

```powershell
flutter run -d edge
```

## Android Telefonda Çalıştırma

1. Telefonda geliştirici seçeneklerini açın.
2. USB hata ayıklamayı etkinleştirin.
3. Telefonu USB kablosuyla bilgisayara bağlayın.
4. Telefonda çıkan USB hata ayıklama iznini onaylayın.
5. Cihaz kimliğini bulun:

```powershell
flutter devices
```

Ardından uygulamayı çalıştırın:

```powershell
flutter run -d TELEFON_CIHAZ_ID
```

Örnek:

```powershell
flutter run -d R58N123ABC
```

USB bağlantısında telefonun `localhost:8081` adresinin bilgisayardaki backend'e ulaşması için gerekli `adb reverse` işlemi otomatik yapılır.

## Android APK Oluşturma ve Yükleme

Telefon ve bilgisayar aynı Wi-Fi ağına bağlıyken proje kök dizininde:

```powershell
.\install-android.ps1
```

Bu script:

- Bilgisayarın yerel IP adresini bulur.
- Flutter bağımlılıklarını yükler.
- Android APK dosyasını oluşturur.
- APK'yı USB ile bağlı telefona yükler.

Oluşturulan APK şu klasörde bulunur:

```text
mobile\build\app\outputs\flutter-apk\app-debug.apk
```

Kalıcı olarak kurulan uygulamanın API'ye ulaşabilmesi için:

- Telefon ve bilgisayar aynı Wi-Fi ağında olmalıdır.
- Backend bilgisayarda çalışıyor olmalıdır.
- Windows Güvenlik Duvarı `8081` portuna izin vermelidir.

## Backend'i Manuel Çalıştırma

Otomatik çalışma sistemi kullanılmayacaksa:

```powershell
cd backend
$env:JAVA_HOME="C:\Program Files\Android\Android Studio\jbr"
.\mvnw.cmd spring-boot:run
```

Backend adresi:

```text
http://127.0.0.1:8081
```

API adresi:

```text
http://127.0.0.1:8081/api
```

Backend'i durdurmak için terminalde `Ctrl + C` tuşlarına basın.

## Flutter'ı Manuel Çalıştırma

Önce mobil proje klasörüne geçin:

```powershell
cd mobile
flutter pub get
```

Chrome:

```powershell
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8081/api
```

USB Android telefon:

```powershell
adb reverse tcp:8081 tcp:8081
flutter run -d TELEFON_CIHAZ_ID --dart-define=API_BASE_URL=http://127.0.0.1:8081/api
```

## Test Komutları

Flutter analizini çalıştırmak için:

```powershell
cd mobile
flutter analyze
```

Flutter testlerini çalıştırmak için:

```powershell
cd mobile
flutter test
```

Backend testlerini çalıştırmak için:

```powershell
cd backend
$env:JAVA_HOME="C:\Program Files\Android\Android Studio\jbr"
.\mvnw.cmd test
```

## Sık Kullanılan Komutlar

```powershell
# Proje klasörüne geç
cd "C:\Users\exp_name\\Desktop\SS projesi\dayanisma-app"

# Vesta terminalini aç
.\dev-shell.cmd

# Cihazları listele
flutter devices

# Chrome'da çalıştır
flutter run -d chrome

# Android telefonda çalıştır
flutter run -d TELEFON_CIHAZ_ID
```

## Sorun Giderme

### Telefon görünmüyorsa

```powershell
flutter doctor
adb devices
flutter devices
```

Telefonda USB hata ayıklama izninin onaylandığından emin olun.

### Backend başlamıyorsa

`backend/.env` dosyasının bulunduğunu ve aşağıdaki değerin doğru olduğunu kontrol edin:

```properties
SUPABASE_DB_PASSWORD=GERCEK_SUPABASE_SIFRESI
```

Backend logları:

```text
backend\backend.out.log
backend\backend.err.log
```

### Flutter build klasörü kilitlenirse

Açık Flutter ve Chrome oturumlarını kapatıp Vesta terminalini yeniden açın:

```powershell
.\dev-shell.cmd
flutter run -d chrome
```

Vesta çalışma scripti eski Dart süreçlerini ve kilitli Flutter build önbelleğini otomatik temizler.

### Bağımlılıklar eksikse

```powershell
cd mobile
flutter pub get
```




