# Dayanisma App

Sosyal paylasim ve dayanisma odakli mobil uygulama.

## Ekipler
- **Frontend** › mobile/ klasoru (Flutter)
- **Backend** › backend/ klasoru (Node.js + Azure App Service + Firebase)

## Figma Tasarim
https://www.figma.com/design/dyvhi5OZ94GmdG3akW64Li/Untitled?node-id=0-1&p=f

## Kurulum

### Flutter (Mobile)
cd mobile
flutter pub get
flutter run

### Backend (Node.js)
cd backend
npm install
cp .env.example .env
node src/server.js

## Firebase Kurulum
1. Firebase Console - Yeni proje olustur
2. Android uygulamasi ekle - google-services.json indir - mobile/android/app/ icine koy
3. Proje ayarlari - Servis hesabi - yeni anahtar olustur - .env dosyasina yapistir
4. flutterfire configure komutunu calistir

## Azure Deploy
GitHub repository ayarlarinda su secretlari ekleyin:
- AZURE_APP_NAME - Azure App Service adiniz
- AZURE_PUBLISH_PROFILE - Azure portaldan indirilen publish profile icerigi
