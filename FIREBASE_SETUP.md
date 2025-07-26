# Firebase Crashlytics ve Analytics Kurulum Rehberi

Bu rehber, ShartFlix uygulamasına Firebase Crashlytics ve Analytics entegrasyonunu tamamlamak için gereken adımları açıklar.

## 1. Firebase Console'da Proje Oluşturma

1. [Firebase Console](https://console.firebase.google.com/)'a gidin
2. "Proje Ekle" butonuna tıklayın
3. Proje adını "shartflix-movie-app" olarak belirleyin
4. Google Analytics'i etkinleştirin
5. Proje oluşturmayı tamamlayın

## 2. Android Uygulaması Ekleme

1. Firebase Console'da "Android" simgesine tıklayın
2. Android paket adını girin: `com.example.shartflix_movie_app`
3. Uygulama takma adını girin: "ShartFlix"
4. "Uygulama Kaydet" butonuna tıklayın
5. `google-services.json` dosyasını indirin
6. İndirilen dosyayı `android/app/` klasörüne yerleştirin

## 3. iOS Uygulaması Ekleme

1. Firebase Console'da "iOS" simgesine tıklayın
2. iOS bundle ID'sini girin: `com.example.shartflixMovieApp`
3. Uygulama takma adını girin: "ShartFlix"
4. "Uygulama Kaydet" butonuna tıklayın
5. `GoogleService-Info.plist` dosyasını indirin
6. İndirilen dosyayı `ios/Runner/` klasörüne yerleştirin

## 4. Firebase Servislerini Etkinleştirme

### Crashlytics
1. Firebase Console'da "Crashlytics" bölümüne gidin
2. "Crashlytics'i etkinleştir" butonuna tıklayın
3. Android ve iOS için ayrı ayrı etkinleştirin

### Analytics
1. Firebase Console'da "Analytics" bölümüne gidin
2. Analytics otomatik olarak etkinleştirilmiş olmalı
3. Gerekirse "Analytics'i etkinleştir" butonuna tıklayın

## 5. Konfigürasyon Dosyalarını Güncelleme

### Android (google-services.json)
Mevcut template dosyasını gerçek Firebase proje bilgileriyle güncelleyin:

```json
{
  "project_info": {
    "project_number": "GERÇEK_PROJE_NUMARASI",
    "project_id": "shartflix-movie-app",
    "storage_bucket": "shartflix-movie-app.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "GERÇEK_MOBILE_SDK_APP_ID",
        "android_client_info": {
          "package_name": "com.example.shartflix_movie_app"
        }
      },
      "oauth_client": [],
      "api_key": [
        {
          "current_key": "GERÇEK_API_KEY"
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": []
        }
      }
    }
  ],
  "configuration_version": "1"
}
```

### iOS (GoogleService-Info.plist)
Mevcut template dosyasını gerçek Firebase proje bilgileriyle güncelleyin:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>API_KEY</key>
	<string>GERÇEK_API_KEY</string>
	<key>GCM_SENDER_ID</key>
	<string>GERÇEK_GCM_SENDER_ID</string>
	<key>PLIST_VERSION</key>
	<string>1</string>
	<key>BUNDLE_ID</key>
	<string>com.example.shartflixMovieApp</string>
	<key>PROJECT_ID</key>
	<string>shartflix-movie-app</string>
	<key>STORAGE_BUCKET</key>
	<string>shartflix-movie-app.appspot.com</string>
	<key>IS_ADS_ENABLED</key>
	<false></false>
	<key>IS_ANALYTICS_ENABLED</key>
	<true></true>
	<key>IS_APPINVITE_ENABLED</key>
	<true></true>
	<key>IS_GCM_ENABLED</key>
	<true></true>
	<key>IS_SIGNIN_ENABLED</key>
	<true></true>
	<key>GOOGLE_APP_ID</key>
	<string>GERÇEK_GOOGLE_APP_ID</string>
</dict>
</plist>
```

## 6. Bağımlılıkları Yükleme

Terminal'de proje klasöründe şu komutu çalıştırın:

```bash
flutter pub get
```

## 7. Uygulamayı Test Etme

### Debug Modda Test
```bash
flutter run
```

### Release Modda Test (Crashlytics için)
```bash
flutter run --release
```

## 8. Entegre Edilen Özellikler

### Analytics Olayları
- **Kullanıcı Giriş/Kayıt**: `login`, `sign_up`, `logout`
- **Film İşlemleri**: `movie_view`, `movie_favorite`
- **Arama**: `search`
- **Ekran Görüntülemeleri**: Otomatik takip
- **Hata Olayları**: `app_error`
- **Performans Metrikleri**: `performance_metric`

### Crashlytics Özellikleri
- **Otomatik Hata Yakalama**: Flutter framework hataları
- **Platform Hataları**: Android/iOS native hataları
- **Kullanıcı Kimliği**: Giriş yapan kullanıcılar için
- **Özel Anahtarlar**: API endpoint'leri, hata mesajları
- **Log Mesajları**: Debugging için detaylı loglar

### Route Observer
- **Sayfa Görüntülemeleri**: Otomatik takip
- **Navigasyon Hataları**: Route geçişlerindeki sorunlar
- **Uygulama Durumu**: Sayfa değişimlerini kaydetme

## 9. Firebase Console'da Görüntüleme

### Analytics
1. Firebase Console > Analytics > Dashboard
2. Gerçek zamanlı kullanıcı aktivitelerini görüntüleyin
3. Özel olayları "Events" bölümünde kontrol edin

### Crashlytics
1. Firebase Console > Crashlytics > Issues
2. Uygulama çökmelerini ve hataları görüntüleyin
3. Kullanıcı bilgilerini ve hata detaylarını inceleyin

## 10. Güvenlik Notları

- Konfigürasyon dosyalarını git'e commit etmeyin
- API anahtarlarını güvenli tutun
- Production'da debug loglarını kapatın
- Kullanıcı gizliliğine dikkat edin

## 11. Sorun Giderme

### Yaygın Sorunlar
1. **Konfigürasyon dosyaları bulunamıyor**: Dosyaların doğru konumda olduğundan emin olun
2. **Analytics verileri görünmüyor**: 24-48 saat beklemeniz gerekebilir
3. **Crashlytics çalışmıyor**: Release modda test edin
4. **Import hataları**: `flutter pub get` komutunu çalıştırın

### Debug Komutları
```bash
# Bağımlılıkları temizle ve yeniden yükle
flutter clean
flutter pub get

# iOS için pod'ları yeniden yükle
cd ios && pod install && cd ..

# Android için gradle'ı temizle
cd android && ./gradlew clean && cd ..
```

## 12. Ek Kaynaklar

- [Firebase Flutter Dokümantasyonu](https://firebase.flutter.dev/)
- [Firebase Analytics Rehberi](https://firebase.google.com/docs/analytics)
- [Firebase Crashlytics Rehberi](https://firebase.google.com/docs/crashlytics)
- [Flutter Firebase Paketleri](https://pub.dev/packages?q=firebase) 