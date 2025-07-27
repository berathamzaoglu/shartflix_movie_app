import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static FirebaseAnalytics? _analytics;
  static FirebaseCrashlytics? _crashlytics;

  /// Firebase'i başlatır ve servisleri yapılandırır
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      
      _analytics = FirebaseAnalytics.instance;
      _crashlytics = FirebaseCrashlytics.instance;
      
      // Crashlytics'i yapılandır
      await _configureCrashlytics();
      
      // Analytics'i yapılandır
      await _configureAnalytics();
      
      debugPrint('Firebase başarıyla başlatıldı');
    } catch (e, stackTrace) {
      debugPrint('Firebase başlatılırken hata oluştu: $e');
      // Firebase başlatılamazsa bile uygulamanın çalışmasına devam etmesini sağla
    }
  }

  /// Crashlytics'i yapılandırır
  static Future<void> _configureCrashlytics() async {
    if (_crashlytics == null) return;

    // Debug modda crashlytics'i devre dışı bırak (isteğe bağlı)
    await _crashlytics!.setCrashlyticsCollectionEnabled(!kDebugMode);
    
    // Flutter framework hatalarını yakala
    FlutterError.onError = _crashlytics!.recordFlutterFatalError;
    
    // Platform hatalarını yakala
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics!.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Analytics'i yapılandırır
  static Future<void> _configureAnalytics() async {
    if (_analytics == null) return;

    // Analytics'i etkinleştir
    await _analytics!.setAnalyticsCollectionEnabled(true);
    
    // Kullanıcı özelliklerini ayarla
    await _analytics!.setUserProperty(name: 'app_version', value: '1.0.0');
  }

  /// Kullanıcı kimliğini ayarlar
  static Future<void> setUserIdentifier(String userId) async {
    if (_crashlytics != null) {
      await _crashlytics!.setUserIdentifier(userId);
    }
    if (_analytics != null) {
      await _analytics!.setUserId(id: userId);
    }
  }

  /// Kullanıcı özelliklerini ayarlar
  static Future<void> setUserProperty(String name, String value) async {
    if (_analytics != null) {
      await _analytics!.setUserProperty(name: name, value: value);
    }
  }

  /// Özel olay gönderir
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    if (_analytics != null) {
      if (parameters != null) {
        // Firebase Analytics sadece String ve num değerleri kabul eder
        final Map<String, Object> convertedParams = parameters.map(
          (key, value) {
            if (value is bool) {
              return MapEntry(key, value.toString());
            } else if (value is String || value is num) {
              return MapEntry(key, value as Object);
            } else {
              // Diğer tipleri string'e dönüştür
              return MapEntry(key, value.toString());
            }
          },
        );
        await _analytics!.logEvent(
          name: name,
          parameters: convertedParams,
        );
      } else {
        await _analytics!.logEvent(name: name);
      }
    }
  }

  /// Ekran görüntüleme olayı gönderir
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (_analytics != null) {
      await _analytics!.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    }
  }

  /// Hata kaydeder
  static Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    bool fatal = false,
  }) async {
    if (_crashlytics != null) {
      await _crashlytics!.recordError(error, stackTrace, fatal: fatal);
    }
  }

  /// Özel anahtar değer çifti ekler
  static Future<void> setCustomKey(String key, dynamic value) async {
    if (_crashlytics != null) {
      await _crashlytics!.setCustomKey(key, value);
    }
  }

  /// Log mesajı ekler
  static Future<void> log(String message) async {
    if (_crashlytics != null) {
      await _crashlytics!.log(message);
    }
  }

  /// Analytics instance'ını döndürür
  static FirebaseAnalytics? get analytics => _analytics;
  
  /// Crashlytics instance'ını döndürür
  static FirebaseCrashlytics? get crashlytics => _crashlytics;
} 