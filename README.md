# Vesta

Vesta; Flutter frontend, Java Spring Boot backend ve Supabase PostgreSQL
veritabanından oluşur.

## İlk Kurulum

`backend/.env.example` dosyasını `backend/.env` olarak kopyalayın ve
`SUPABASE_DB_PASSWORD` değerini girin.

## Uygulamayı Çalıştırma

Her zaman önce proje köküne girin:

```powershell
cd "C:\Users\ecehv\OneDrive\Desktop\SS projesi\dayanisma-app"
```

Labelscan projesindeki gibi geliştirme terminalini açın:

```powershell
.\dev-shell.cmd
```

Yeni açılan terminalde cihazları görün:

```powershell
flutter devices
```

### Chrome

```powershell
flutter run -d chrome
```

### Edge

```powershell
flutter run -d edge
```

### USB Android Telefon

Telefonu USB ile bağlayın, USB hata ayıklama iznini verin ve:

```powershell
flutter devices
flutter run -d TELEFON_CIHAZ_ID
```

Örnek:

```powershell
flutter run -d R58N123ABC
```

Backend otomatik başlatılır. Android telefon için `adb reverse` otomatik
uygulanır. API adresini veya `--dart-define` parametresini elle yazmanız gerekmez.

## Kısa Özet

```powershell
cd "C:\Users\ecehv\OneDrive\Desktop\SS projesi\dayanisma-app"
.\dev-shell.cmd
flutter devices
flutter run -d chrome
```

Telefon için son komut:

```powershell
flutter run -d TELEFON_CIHAZ_ID
```

## APK Kurulumu

Telefon ve bilgisayar aynı Wi-Fi ağındaysa proje kökünde:

```powershell
.\install-android.ps1
```

Bu script APK oluşturur ve bağlı Android telefona yükler.

## Önemli

Normal PowerShell içinde doğrudan `flutter run` çalıştırmayın. Önce
`.\dev-shell.cmd` komutuyla Vesta terminalini açın. Bu terminal:

- Doğru `mobile` klasörünü açar.
- Backend'i otomatik başlatır.
- API adresini otomatik ekler.
- USB Android bağlantısını otomatik hazırlar.
- Önceki Flutter çalışmasından kalan kilitli Dart sürecini otomatik temizler.
