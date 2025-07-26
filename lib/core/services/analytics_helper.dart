import 'package:firebase_analytics/firebase_analytics.dart';

/// Analytics olaylarını takip etmek için yardımcı sınıf
class AnalyticsHelper {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Kullanıcı giriş olayı
  static Future<void> logLogin({String? method}) async {
    await _analytics.logLogin(loginMethod: method ?? 'unknown');
  }

  /// Kullanıcı kayıt olayı
  static Future<void> logSignUp({String? method}) async {
    await _analytics.logSignUp(signUpMethod: method ?? 'unknown');
  }

  /// Kullanıcı çıkış olayı
  static Future<void> logLogout() async {
    await _analytics.logEvent(name: 'user_logout');
  }

  /// Film görüntüleme olayı
  static Future<void> logMovieView({
    required String movieId,
    required String movieTitle,
    String? genre,
  }) async {
    final Map<String, Object> parameters = {
      'movie_id': movieId,
      'movie_title': movieTitle,
    };
    if (genre != null) {
      parameters['genre'] = genre;
    }
    
    await _analytics.logEvent(
      name: 'movie_view',
      parameters: parameters,
    );
  }

  /// Film favorilere ekleme olayı
  static Future<void> logMovieFavorite({
    required String movieId,
    required String movieTitle,
    required bool isFavorite,
  }) async {
    await _analytics.logEvent(
      name: 'movie_favorite',
      parameters: {
        'movie_id': movieId,
        'movie_title': movieTitle,
        'is_favorite': isFavorite.toString(), // Boolean'ı string'e dönüştür
      },
    );
  }

  /// Arama olayı
  static Future<void> logSearch({
    required String searchTerm,
    int? resultCount,
  }) async {
    await _analytics.logSearch(searchTerm: searchTerm);
    
    // Sonuç sayısını ayrı bir olay olarak gönder
    if (resultCount != null) {
      await _analytics.logEvent(
        name: 'search_results',
        parameters: {
          'search_term': searchTerm,
          'result_count': resultCount,
        },
      );
    }
  }

  /// Ekran görüntüleme olayı
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  /// Özel olay
  static Future<void> logCustomEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
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
      await _analytics.logEvent(
        name: name,
        parameters: convertedParams,
      );
    } else {
      await _analytics.logEvent(name: name);
    }
  }

  /// Kullanıcı özelliği ayarlama
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  /// Kullanıcı kimliği ayarlama
  static Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  /// Uygulama açılış olayı
  static Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  /// Hata olayı
  static Future<void> logError({
    required String errorType,
    required String errorMessage,
    String? screenName,
  }) async {
    final Map<String, Object> parameters = {
      'error_type': errorType,
      'error_message': errorMessage,
    };
    if (screenName != null) {
      parameters['screen_name'] = screenName;
    }
    
    await _analytics.logEvent(
      name: 'app_error',
      parameters: parameters,
    );
  }

  /// Performans olayı
  static Future<void> logPerformance({
    required String eventName,
    required int duration,
    String? screenName,
  }) async {
    final Map<String, Object> parameters = {
      'event_name': eventName,
      'duration_ms': duration,
    };
    if (screenName != null) {
      parameters['screen_name'] = screenName;
    }
    
    await _analytics.logEvent(
      name: 'performance_metric',
      parameters: parameters,
    );
  }
} 