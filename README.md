# Dayanisma App

Sosyal paylasim ve dayanisma odakli mobil uygulama.

## Ekipler
- **Frontend** -> mobile/ klasoru (Flutter)
- **Backend** -> backend/ klasoru (Java Spring Boot + Azure App Service + Firebase)

## Figma Tasarim
https://www.figma.com/design/dyvhi5OZ94GmdG3akW64Li/Untitled?node-id=0-1&p=f

## Kurulum

### Flutter (Mobile)
cd mobile
flutter pub get
flutter run

### Backend (Java Spring Boot)
cd backend
./mvnw spring-boot:run

Windows icin:
mvnw.cmd spring-boot:run

### Gereksinimler
- Java 17+
- Maven (veya mvnw kullanin)
- Flutter 3.x+
- Android Studio (emulator icin)

## Firebase Kurulum
1. Firebase Console - Yeni proje olustur
2. Android uygulamasi ekle - google-services.json indir - mobile/android/app/ icine koy
3. Proje ayarlari - Servis hesabi - yeni anahtar olustur - application.properties dosyasina yapistir
4. flutterfire configure komutunu calistir

## Azure Deploy
GitHub repository ayarlarinda su secretlari ekleyin:
- AZURE_APP_NAME - Azure App Service adiniz
- AZURE_PUBLISH_PROFILE - Azure portaldan indirilen publish profile icerigi

## Son committen sonra uygulamayı çalıştırma adımları aşağıdaki gibidir . Bu kılavuzdan yardım alabilirsiniz.

```md
## Uygulamayı Çalıştırma

### 1. Gerekli Kurulumlar

Önce Flutter kurulumunun doğru çalıştığını kontrol edin:

```powershell
flutter doctor
```

Eksik görünen Android Studio, SDK, Chrome/Edge veya cihaz izinlerini tamamlayın.

Projeyi çalıştırmadan önce `mobile` klasörüne girin:

```powershell
cd mobile
flutter pub get
```

### 2. Telefonda Çalıştırma

Telefonu USB ile bilgisayara bağlayın.

Android telefonda:
- Geliştirici seçeneklerini açın.
- USB hata ayıklama modunu etkinleştirin.
- Telefonda çıkan USB hata ayıklama iznine izin verin.

Bağlı cihazları kontrol edin:

```powershell
flutter devices
```

Cihaz listede görünüyorsa uygulamayı çalıştırın:

```powershell
flutter run
```

Belirli bir cihaz seçmek için cihaz ID’sini kullanabilirsiniz:

```powershell
flutter run -d CIHAZ_ID
```

Örnek:

```powershell
flutter run -d R58N123ABC
```

Backend bilgisayarda çalışıyorsa ve uygulama fiziksel telefonda açılıyorsa, `127.0.0.1` telefonun kendisini işaret eder. Bu yüzden bilgisayarın yerel IP adresiyle çalıştırmak gerekir:

```powershell
flutter run --dart-define=API_BASE_URL=http://BILGISAYAR_IP_ADRESI:8081/api
```

Örnek:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.25:8081/api
```

Bilgisayar ve telefon aynı Wi-Fi ağına bağlı olmalıdır.

### 3. Android Emulator ile Çalıştırma

Android emulator açıksa:

```powershell
flutter devices
flutter run
```

Emulator içinden bilgisayardaki backend’e bağlanmak için genelde `10.0.2.2` kullanılır:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8081/api
```

### 4. Chrome veya Edge’de Çalıştırma

Web üzerinde çalıştırmak için cihazları kontrol edin:

```powershell
flutter devices
```

Chrome’da çalıştırmak için:

```powershell
flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8081/api
```

Edge’de çalıştırmak için:

```powershell
flutter run -d edge --dart-define=API_BASE_URL=http://127.0.0.1:8081/api
```

Belirli bir porttan açmak isterseniz:

```powershell
flutter run -d chrome --web-port=3000 --dart-define=API_BASE_URL=http://127.0.0.1:8081/api
```

### 5. Backend’i Çalıştırma

Backend klasörüne girin:

```powershell
cd ../backend
```

Spring Boot backend’i çalıştırın:

```powershell
.\mvnw.cmd spring-boot:run
```

Backend varsayılan olarak şu adreste çalışır:

```text
http://127.0.0.1:8081/api
```

Mobil uygulamayı ayrı bir terminalde `mobile` klasöründen çalıştırın.

### 6. Sık Kullanılan Komutlar

Flutter bağımlılıklarını yüklemek:

```powershell
flutter pub get
```

Cihazları listelemek:

```powershell
flutter devices
```

Uygulamayı varsayılan cihazda çalıştırmak:

```powershell
flutter run
```

Chrome’da çalıştırmak:

```powershell
flutter run -d chrome
```

Edge’de çalıştırmak:

```powershell
flutter run -d edge
```

Android APK oluşturmak:

```powershell
flutter build apk --debug --dart-define=API_BASE_URL=http://127.0.0.1:8081/api
```

Kod analizi yapmak:

```powershell
dart analyze lib
```
```
