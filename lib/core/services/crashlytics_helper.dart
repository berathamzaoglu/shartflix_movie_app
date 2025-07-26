import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Crashlytics hata takibi için yardımcı sınıf
class CrashlyticsHelper {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Kullanıcı kimliğini ayarlar
  static Future<void> setUserIdentifier(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  /// Kullanıcı özelliklerini ayarlar
  static Future<void> setUserProperty({
    required String key,
    required String value,
  }) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// Hata kaydeder
  static Future<void> recordError(
    dynamic error,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? reason,
  }) async {
    await _crashlytics.recordError(
      error,
      stackTrace,
      fatal: fatal,
      reason: reason,
    );
  }

  /// Log mesajı ekler
  static Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  /// API hatası kaydeder
  static Future<void> recordApiError({
    required String endpoint,
    required int statusCode,
    required String errorMessage,
    Map<String, dynamic>? requestData,
  }) async {
    await _crashlytics.setCustomKey('api_endpoint', endpoint);
    await _crashlytics.setCustomKey('status_code', statusCode);
    await _crashlytics.setCustomKey('error_message', errorMessage);
    
    if (requestData != null) {
      await _crashlytics.setCustomKey('request_data', requestData.toString());
    }
    
    await _crashlytics.log('API Error: $endpoint - $statusCode - $errorMessage');
  }

  /// UI hatası kaydeder
  static Future<void> recordUIError({
    required String screenName,
    required String widgetName,
    required String errorMessage,
    StackTrace? stackTrace,
  }) async {
    await _crashlytics.setCustomKey('screen_name', screenName);
    await _crashlytics.setCustomKey('widget_name', widgetName);
    await _crashlytics.setCustomKey('error_message', errorMessage);
    
    await _crashlytics.recordError(
      Exception(errorMessage),
      stackTrace,
      reason: 'UI Error in $screenName - $widgetName',
    );
  }

  /// Navigasyon hatası kaydeder
  static Future<void> recordNavigationError({
    required String fromRoute,
    required String toRoute,
    required String errorMessage,
  }) async {
    await _crashlytics.setCustomKey('from_route', fromRoute);
    await _crashlytics.setCustomKey('to_route', toRoute);
    await _crashlytics.setCustomKey('error_message', errorMessage);
    
    await _crashlytics.log('Navigation Error: $fromRoute -> $toRoute - $errorMessage');
  }

  /// Performans sorunu kaydeder
  static Future<void> recordPerformanceIssue({
    required String operation,
    required int duration,
    required int threshold,
    String? screenName,
  }) async {
    await _crashlytics.setCustomKey('operation', operation);
    await _crashlytics.setCustomKey('duration_ms', duration);
    await _crashlytics.setCustomKey('threshold_ms', threshold);
    
    if (screenName != null) {
      await _crashlytics.setCustomKey('screen_name', screenName);
    }
    
    await _crashlytics.log('Performance Issue: $operation took ${duration}ms (threshold: ${threshold}ms)');
  }

  /// Kullanıcı eylemi kaydeder
  static Future<void> recordUserAction({
    required String action,
    required String screenName,
    Map<String, dynamic>? parameters,
  }) async {
    await _crashlytics.setCustomKey('user_action', action);
    await _crashlytics.setCustomKey('screen_name', screenName);
    
    if (parameters != null) {
      for (final entry in parameters.entries) {
        await _crashlytics.setCustomKey(entry.key, entry.value.toString());
      }
    }
    
    await _crashlytics.log('User Action: $action in $screenName');
  }

  /// Uygulama durumu kaydeder
  static Future<void> recordAppState({
    required String state,
    String? previousState,
    Map<String, dynamic>? context,
  }) async {
    await _crashlytics.setCustomKey('app_state', state);
    
    if (previousState != null) {
      await _crashlytics.setCustomKey('previous_state', previousState);
    }
    
    if (context != null) {
      for (final entry in context.entries) {
        await _crashlytics.setCustomKey('context_${entry.key}', entry.value.toString());
      }
    }
    
    await _crashlytics.log('App State Change: $previousState -> $state');
  }
} 