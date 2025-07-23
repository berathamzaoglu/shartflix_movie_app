# Firebase Integration

## Overview

The ShartFlix application integrates with Firebase services to provide comprehensive analytics, crash reporting, performance monitoring, and remote configuration capabilities. This integration ensures optimal user experience monitoring, real-time error tracking, and data-driven decision making for application improvements.

## Core Firebase Services

### Firebase Core Setup
```dart
// firebase_config.dart
class FirebaseConfig {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Configure Crashlytics
    await _configureCrashlytics();
    
    // Configure Analytics
    await _configureAnalytics();
    
    // Configure Performance Monitoring
    await _configurePerformance();
    
    // Configure Remote Config
    await _configureRemoteConfig();
    
    LoggerService.info('Firebase initialized successfully');
  }

  static Future<void> _configureCrashlytics() async {
    // Enable Crashlytics collection
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    
    // Set user identifier for crash reports
    final userId = await TokenStorage.getUserId();
    if (userId != null) {
      await FirebaseCrashlytics.instance.setUserIdentifier(userId);
    }
    
    // Set custom keys for debugging
    await FirebaseCrashlytics.instance.setCustomKey('app_version', AppInfo.version);
    await FirebaseCrashlytics.instance.setCustomKey('build_number', AppInfo.buildNumber);
    await FirebaseCrashlytics.instance.setCustomKey('platform', Platform.operatingSystem);
    
    LoggerService.info('Crashlytics configured');
  }

  static Future<void> _configureAnalytics() async {
    final analytics = FirebaseAnalytics.instance;
    
    // Enable analytics collection
    await analytics.setAnalyticsCollectionEnabled(true);
    
    // Set default event parameters
    await analytics.setDefaultEventParameters({
      'app_version': AppInfo.version,
      'platform': Platform.operatingSystem,
      'user_type': 'free', // Will be updated when user logs in
    });
    
    // Set user properties
    await analytics.setUserProperty(
      name: 'preferred_language',
      value: Platform.localeName,
    );
    
    LoggerService.info('Analytics configured');
  }

  static Future<void> _configurePerformance() async {
    final performance = FirebasePerformance.instance;
    
    // Enable performance monitoring
    await performance.setPerformanceCollectionEnabled(true);
    
    LoggerService.info('Performance monitoring configured');
  }

  static Future<void> _configureRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    
    // Set configuration settings
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    
    // Set default values
    await remoteConfig.setDefaults(_defaultConfigValues);
    
    // Fetch and activate
    await remoteConfig.fetchAndActivate();
    
    LoggerService.info('Remote Config configured');
  }

  static const Map<String, dynamic> _defaultConfigValues = {
    'feature_limited_offer_enabled': true,
    'feature_social_login_enabled': true,
    'api_timeout_seconds': 30,
    'max_retry_attempts': 3,
    'pagination_page_size': 5,
    'cache_duration_minutes': 10,
    'minimum_app_version': '1.0.0',
    'force_update_required': false,
    'maintenance_mode': false,
    'maintenance_message': 'App is under maintenance. Please try again later.',
    'support_email': 'support@shartflix.com',
    'terms_url': 'https://shartflix.com/terms',
    'privacy_url': 'https://shartflix.com/privacy',
    'feature_dark_theme_enabled': true,
    'feature_multi_language_enabled': true,
    'max_favorite_movies': 100,
    'premium_trial_days': 7,
    'onboarding_slides_count': 3,
    'review_prompt_threshold': 10,
  };
}
```

## Crashlytics Integration

### Crash Reporting Service
```dart
// crashlytics_service.dart
class CrashlyticsService {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Record a non-fatal error
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    Map<String, dynamic>? context,
    bool fatal = false,
  }) async {
    try {
      // Add context information
      if (context != null) {
        for (final entry in context.entries) {
          await _crashlytics.setCustomKey(entry.key, entry.value);
        }
      }

      // Record the error
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );

      LoggerService.error(
        'Error recorded to Crashlytics: $exception',
        error: exception,
        stackTrace: stackTrace,
      );
    } catch (e) {
      LoggerService.warning('Failed to record error to Crashlytics: $e');
    }
  }

  /// Record a flutter error
  static Future<void> recordFlutterError(FlutterErrorDetails details) async {
    try {
      await _crashlytics.recordFlutterError(details);
    } catch (e) {
      LoggerService.warning('Failed to record Flutter error to Crashlytics: $e');
    }
  }

  /// Log a message
  static Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);
    } catch (e) {
      LoggerService.warning('Failed to log message to Crashlytics: $e');
    }
  }

  /// Set user information
  static Future<void> setUserInfo({
    required String userId,
    String? email,
    String? name,
  }) async {
    try {
      await _crashlytics.setUserIdentifier(userId);
      
      if (email != null) {
        await _crashlytics.setCustomKey('user_email', email);
      }
      
      if (name != null) {
        await _crashlytics.setCustomKey('user_name', name);
      }
    } catch (e) {
      LoggerService.warning('Failed to set user info in Crashlytics: $e');
    }
  }

  /// Set custom key-value pairs
  static Future<void> setCustomKey(String key, dynamic value) async {
    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      LoggerService.warning('Failed to set custom key in Crashlytics: $e');
    }
  }

  /// Clear user data (on logout)
  static Future<void> clearUserData() async {
    try {
      await _crashlytics.setUserIdentifier('');
      await _crashlytics.setCustomKey('user_email', '');
      await _crashlytics.setCustomKey('user_name', '');
      await _crashlytics.setCustomKey('user_type', 'anonymous');
    } catch (e) {
      LoggerService.warning('Failed to clear user data in Crashlytics: $e');
    }
  }

  /// Record breadcrumb for debugging
  static Future<void> recordBreadcrumb({
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      final breadcrumb = {
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
        ...?data,
      };
      
      await _crashlytics.log('Breadcrumb: ${jsonEncode(breadcrumb)}');
    } catch (e) {
      LoggerService.warning('Failed to record breadcrumb: $e');
    }
  }
}

// Integration with global error handling
class AppErrorHandler {
  static void initialize() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      CrashlyticsService.recordFlutterError(details);
      LoggerService.error(
        'Flutter Error: ${details.exception}',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    // Handle platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      CrashlyticsService.recordError(error, stack, fatal: true);
      LoggerService.error(
        'Platform Error: $error',
        error: error,
        stackTrace: stack,
      );
      return true;
    };
  }
}
```

### BLoC Error Integration
```dart
// bloc_observer.dart
class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    
    // Record BLoC errors to Crashlytics
    CrashlyticsService.recordError(
      error,
      stackTrace,
      reason: 'BLoC Error in ${bloc.runtimeType}',
      context: {
        'bloc_type': bloc.runtimeType.toString(),
        'bloc_state': bloc.state.toString(),
      },
    );
  }

  @override
  void onTransition(BlocBase bloc, Transition transition) {
    super.onTransition(bloc, transition);
    
    // Record important state transitions as breadcrumbs
    if (_isImportantTransition(bloc, transition)) {
      CrashlyticsService.recordBreadcrumb(
        message: 'BLoC Transition: ${bloc.runtimeType}',
        data: {
          'current_state': transition.currentState.toString(),
          'event': transition.event.toString(),
          'next_state': transition.nextState.toString(),
        },
      );
    }
  }

  bool _isImportantTransition(BlocBase bloc, Transition transition) {
    // Define which transitions are important for debugging
    return bloc is AuthBloc || 
           bloc is MovieBloc || 
           bloc is PaymentBloc ||
           transition.nextState.toString().contains('Error');
  }
}
```

## Analytics Integration

### Analytics Service
```dart
// analytics_service.dart
class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Track screen views
  static Future<void> trackScreenView({
    required String screenName,
    String? screenClass,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
        parameters: parameters,
      );
      
      LoggerService.debug('Screen view tracked: $screenName');
    } catch (e) {
      LoggerService.warning('Failed to track screen view: $e');
    }
  }

  /// Track user authentication events
  static Future<void> trackLogin({
    required String method,
    bool isSuccess = true,
  }) async {
    try {
      if (isSuccess) {
        await _analytics.logLogin(loginMethod: method);
      } else {
        await _analytics.logEvent(
          name: 'login_failed',
          parameters: {
            'method': method,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          },
        );
      }
    } catch (e) {
      LoggerService.warning('Failed to track login: $e');
    }
  }

  static Future<void> trackSignUp({
    required String method,
    bool isSuccess = true,
  }) async {
    try {
      if (isSuccess) {
        await _analytics.logSignUp(signUpMethod: method);
      } else {
        await _analytics.logEvent(
          name: 'sign_up_failed',
          parameters: {
            'method': method,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          },
        );
      }
    } catch (e) {
      LoggerService.warning('Failed to track sign up: $e');
    }
  }

  /// Track movie interactions
  static Future<void> trackMovieView({
    required String movieId,
    required String movieTitle,
    String? genre,
    int? year,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'movie_view',
        parameters: {
          'movie_id': movieId,
          'movie_title': movieTitle,
          if (genre != null) 'genre': genre,
          if (year != null) 'year': year,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      LoggerService.warning('Failed to track movie view: $e');
    }
  }

  static Future<void> trackFavoriteAction({
    required String movieId,
    required String action, // 'add' or 'remove'
    String? movieTitle,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'favorite_movie',
        parameters: {
          'movie_id': movieId,
          'action': action,
          if (movieTitle != null) 'movie_title': movieTitle,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      LoggerService.warning('Failed to track favorite action: $e');
    }
  }

  static Future<void> trackMovieSearch({
    required String query,
    required int resultsCount,
  }) async {
    try {
      await _analytics.logSearch(
        searchTerm: query,
        numberOfHits: resultsCount,
      );
    } catch (e) {
      LoggerService.warning('Failed to track movie search: $e');
    }
  }

  /// Track purchase events
  static Future<void> trackPurchase({
    required String itemId,
    required String itemName,
    required double value,
    required String currency,
    String? itemCategory,
  }) async {
    try {
      await _analytics.logPurchase(
        currency: currency,
        value: value,
        parameters: {
          'item_id': itemId,
          'item_name': itemName,
          if (itemCategory != null) 'item_category': itemCategory,
          'transaction_id': const Uuid().v4(),
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      LoggerService.warning('Failed to track purchase: $e');
    }
  }

  static Future<void> trackPurchaseAttempt({
    required String itemId,
    required String paymentMethod,
    required double value,
    String? failureReason,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'purchase_attempt',
        parameters: {
          'item_id': itemId,
          'payment_method': paymentMethod,
          'value': value,
          'currency': 'TRY',
          if (failureReason != null) 'failure_reason': failureReason,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      LoggerService.warning('Failed to track purchase attempt: $e');
    }
  }

  /// Track user behavior
  static Future<void> trackNavigation({
    required String from,
    required String to,
    String? method,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'navigation',
        parameters: {
          'from_screen': from,
          'to_screen': to,
          if (method != null) 'method': method,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      LoggerService.warning('Failed to track navigation: $e');
    }
  }

  static Future<void> trackFeatureUsage({
    required String featureName,
    Map<String, Object>? context,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'feature_usage',
        parameters: {
          'feature_name': featureName,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          ...?context,
        },
      );
    } catch (e) {
      LoggerService.warning('Failed to track feature usage: $e');
    }
  }

  /// Track app performance
  static Future<void> trackApiError({
    required String endpoint,
    int? statusCode,
    String? errorType,
    String? errorMessage,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'api_error',
        parameters: {
          'endpoint': endpoint,
          if (statusCode != null) 'status_code': statusCode,
          if (errorType != null) 'error_type': errorType,
          if (errorMessage != null) 'error_message': errorMessage,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      LoggerService.warning('Failed to track API error: $e');
    }
  }

  /// Track user properties
  static Future<void> setUserProperties({
    required String userId,
    String? email,
    String? membershipType,
    String? preferredLanguage,
    String? preferredTheme,
  }) async {
    try {
      await _analytics.setUserId(id: userId);
      
      if (membershipType != null) {
        await _analytics.setUserProperty(
          name: 'membership_type',
          value: membershipType,
        );
      }
      
      if (preferredLanguage != null) {
        await _analytics.setUserProperty(
          name: 'preferred_language',
          value: preferredLanguage,
        );
      }
      
      if (preferredTheme != null) {
        await _analytics.setUserProperty(
          name: 'preferred_theme',
          value: preferredTheme,
        );
      }
    } catch (e) {
      LoggerService.warning('Failed to set user properties: $e');
    }
  }

  /// Track theme and language changes
  static Future<void> trackThemeChange({
    required String themeMode,
    required bool useSystemTheme,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'theme_change',
        parameters: {
          'theme_mode': themeMode,
          'use_system_theme': useSystemTheme,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      LoggerService.warning('Failed to track theme change: $e');
    }
  }

  static Future<void> trackLanguageChange({
    required String languageCode,
    required bool useSystemLanguage,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'language_change',
        parameters: {
          'language_code': languageCode,
          'use_system_language': useSystemLanguage,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (e) {
      LoggerService.warning('Failed to track language change: $e');
    }
  }

  /// Clear user data
  static Future<void> clearUserData() async {
    try {
      await _analytics.setUserId(id: null);
      await _analytics.setUserProperty(name: 'membership_type', value: null);
    } catch (e) {
      LoggerService.warning('Failed to clear user data from Analytics: $e');
    }
  }
}
```

## Performance Monitoring

### Performance Tracking Service
```dart
// performance_service.dart
class PerformanceService {
  static final FirebasePerformance _performance = FirebasePerformance.instance;
  static final Map<String, Trace> _activeTraces = {};

  /// Start a custom trace
  static Future<void> startTrace(String traceName) async {
    try {
      final trace = _performance.newTrace(traceName);
      await trace.start();
      _activeTraces[traceName] = trace;
      
      LoggerService.debug('Performance trace started: $traceName');
    } catch (e) {
      LoggerService.warning('Failed to start performance trace: $e');
    }
  }

  /// Stop a custom trace
  static Future<void> stopTrace(String traceName) async {
    try {
      final trace = _activeTraces[traceName];
      if (trace != null) {
        await trace.stop();
        _activeTraces.remove(traceName);
        
        LoggerService.debug('Performance trace stopped: $traceName');
      }
    } catch (e) {
      LoggerService.warning('Failed to stop performance trace: $e');
    }
  }

  /// Add attributes to a trace
  static Future<void> setTraceAttribute({
    required String traceName,
    required String attribute,
    required String value,
  }) async {
    try {
      final trace = _activeTraces[traceName];
      if (trace != null) {
        trace.putAttribute(attribute, value);
      }
    } catch (e) {
      LoggerService.warning('Failed to set trace attribute: $e');
    }
  }

  /// Increment a trace metric
  static Future<void> incrementTraceMetric({
    required String traceName,
    required String metric,
    int value = 1,
  }) async {
    try {
      final trace = _activeTraces[traceName];
      if (trace != null) {
        trace.incrementMetric(metric, value);
      }
    } catch (e) {
      LoggerService.warning('Failed to increment trace metric: $e');
    }
  }

  /// Track API call performance
  static Future<T> trackApiCall<T>({
    required String endpoint,
    required Future<T> Function() apiCall,
  }) async {
    final traceName = 'api_call_${endpoint.replaceAll('/', '_')}';
    
    await startTrace(traceName);
    await setTraceAttribute(
      traceName: traceName,
      attribute: 'endpoint',
      value: endpoint,
    );
    
    try {
      final result = await apiCall();
      
      await setTraceAttribute(
        traceName: traceName,
        attribute: 'status',
        value: 'success',
      );
      
      return result;
    } catch (e) {
      await setTraceAttribute(
        traceName: traceName,
        attribute: 'status',
        value: 'error',
      );
      
      await setTraceAttribute(
        traceName: traceName,
        attribute: 'error_type',
        value: e.runtimeType.toString(),
      );
      
      rethrow;
    } finally {
      await stopTrace(traceName);
    }
  }

  /// Track screen load performance
  static Future<void> trackScreenLoad({
    required String screenName,
    required Future<void> Function() loadFunction,
  }) async {
    final traceName = 'screen_load_$screenName';
    
    await startTrace(traceName);
    await setTraceAttribute(
      traceName: traceName,
      attribute: 'screen',
      value: screenName,
    );
    
    try {
      await loadFunction();
      
      await setTraceAttribute(
        traceName: traceName,
        attribute: 'status',
        value: 'success',
      );
    } catch (e) {
      await setTraceAttribute(
        traceName: traceName,
        attribute: 'status',
        value: 'error',
      );
      
      rethrow;
    } finally {
      await stopTrace(traceName);
    }
  }

  /// Track image load performance
  static Future<void> trackImageLoad({
    required String imageUrl,
    required Future<void> Function() loadFunction,
  }) async {
    final traceName = 'image_load';
    
    if (!_activeTraces.containsKey(traceName)) {
      await startTrace(traceName);
    }
    
    await incrementTraceMetric(
      traceName: traceName,
      metric: 'image_load_count',
    );
    
    try {
      await loadFunction();
      
      await incrementTraceMetric(
        traceName: traceName,
        metric: 'image_load_success',
      );
    } catch (e) {
      await incrementTraceMetric(
        traceName: traceName,
        metric: 'image_load_error',
      );
      
      rethrow;
    }
  }

  /// Create HTTP request trace
  static HttpMetric createHttpMetric({
    required String url,
    required HttpMethod httpMethod,
  }) {
    return _performance.newHttpMetric(url, httpMethod);
  }

  /// Clean up all active traces
  static Future<void> cleanup() async {
    for (final trace in _activeTraces.values) {
      try {
        await trace.stop();
      } catch (e) {
        LoggerService.warning('Failed to stop trace during cleanup: $e');
      }
    }
    _activeTraces.clear();
  }
}

// Performance wrapper for Dio
class PerformanceInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final httpMetric = PerformanceService.createHttpMetric(
      url: options.uri.toString(),
      httpMethod: _getHttpMethod(options.method),
    );
    
    options.extra['http_metric'] = httpMetric;
    httpMetric.start();
    
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final httpMetric = response.requestOptions.extra['http_metric'] as HttpMetric?;
    
    if (httpMetric != null) {
      httpMetric.httpResponseCode = response.statusCode;
      httpMetric.responseContentType = response.headers.value('content-type');
      httpMetric.responsePayloadSize = response.data?.toString().length;
      httpMetric.stop();
    }
    
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final httpMetric = err.requestOptions.extra['http_metric'] as HttpMetric?;
    
    if (httpMetric != null) {
      httpMetric.httpResponseCode = err.response?.statusCode;
      httpMetric.stop();
    }
    
    handler.next(err);
  }

  HttpMethod _getHttpMethod(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return HttpMethod.Get;
      case 'POST':
        return HttpMethod.Post;
      case 'PUT':
        return HttpMethod.Put;
      case 'DELETE':
        return HttpMethod.Delete;
      case 'PATCH':
        return HttpMethod.Patch;
      default:
        return HttpMethod.Get;
    }
  }
}
```

## Remote Config

### Remote Configuration Service
```dart
// remote_config_service.dart
class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  static const Duration _fetchTimeout = Duration(minutes: 1);
  static const Duration _minimumFetchInterval = Duration(hours: 1);

  /// Initialize Remote Config
  static Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: _fetchTimeout,
        minimumFetchInterval: _minimumFetchInterval,
      ));

      await _remoteConfig.setDefaults(FirebaseConfig._defaultConfigValues);
      await _remoteConfig.fetchAndActivate();
      
      LoggerService.info('Remote Config initialized');
    } catch (e) {
      LoggerService.error('Failed to initialize Remote Config: $e');
    }
  }

  /// Fetch latest configuration
  static Future<bool> fetchConfig() async {
    try {
      await _remoteConfig.fetch();
      return await _remoteConfig.activate();
    } catch (e) {
      LoggerService.error('Failed to fetch remote config: $e');
      return false;
    }
  }

  /// Get configuration values
  static bool getBool(String key) {
    try {
      return _remoteConfig.getBool(key);
    } catch (e) {
      LoggerService.warning('Failed to get bool config for $key: $e');
      return FirebaseConfig._defaultConfigValues[key] as bool? ?? false;
    }
  }

  static int getInt(String key) {
    try {
      return _remoteConfig.getInt(key);
    } catch (e) {
      LoggerService.warning('Failed to get int config for $key: $e');
      return FirebaseConfig._defaultConfigValues[key] as int? ?? 0;
    }
  }

  static double getDouble(String key) {
    try {
      return _remoteConfig.getDouble(key);
    } catch (e) {
      LoggerService.warning('Failed to get double config for $key: $e');
      return FirebaseConfig._defaultConfigValues[key] as double? ?? 0.0;
    }
  }

  static String getString(String key) {
    try {
      return _remoteConfig.getString(key);
    } catch (e) {
      LoggerService.warning('Failed to get string config for $key: $e');
      return FirebaseConfig._defaultConfigValues[key] as String? ?? '';
    }
  }

  /// Feature flags
  static bool isFeatureEnabled(String featureName) {
    return getBool('feature_${featureName}_enabled');
  }

  /// App configuration
  static bool isLimitedOfferEnabled() => getBool('feature_limited_offer_enabled');
  static bool isSocialLoginEnabled() => getBool('feature_social_login_enabled');
  static bool isDarkThemeEnabled() => getBool('feature_dark_theme_enabled');
  static bool isMultiLanguageEnabled() => getBool('feature_multi_language_enabled');

  static int getApiTimeoutSeconds() => getInt('api_timeout_seconds');
  static int getMaxRetryAttempts() => getInt('max_retry_attempts');
  static int getPaginationPageSize() => getInt('pagination_page_size');
  static int getCacheDurationMinutes() => getInt('cache_duration_minutes');
  static int getMaxFavoriteMovies() => getInt('max_favorite_movies');
  static int getPremiumTrialDays() => getInt('premium_trial_days');
  static int getOnboardingSlidesCount() => getInt('onboarding_slides_count');
  static int getReviewPromptThreshold() => getInt('review_prompt_threshold');

  static String getMinimumAppVersion() => getString('minimum_app_version');
  static String getSupportEmail() => getString('support_email');
  static String getTermsUrl() => getString('terms_url');
  static String getPrivacyUrl() => getString('privacy_url');
  static String getMaintenanceMessage() => getString('maintenance_message');

  static bool isForceUpdateRequired() => getBool('force_update_required');
  static bool isMaintenanceMode() => getBool('maintenance_mode');

  /// Check if app update is required
  static bool isAppUpdateRequired() {
    final currentVersion = AppInfo.version;
    final minimumVersion = getMinimumAppVersion();
    
    return _compareVersions(currentVersion, minimumVersion) < 0;
  }

  static int _compareVersions(String version1, String version2) {
    final v1Parts = version1.split('.').map(int.parse).toList();
    final v2Parts = version2.split('.').map(int.parse).toList();
    
    final maxLength = math.max(v1Parts.length, v2Parts.length);
    
    for (int i = 0; i < maxLength; i++) {
      final v1Part = i < v1Parts.length ? v1Parts[i] : 0;
      final v2Part = i < v2Parts.length ? v2Parts[i] : 0;
      
      if (v1Part < v2Part) return -1;
      if (v1Part > v2Part) return 1;
    }
    
    return 0;
  }

  /// Listen for config changes
  static Stream<RemoteConfigUpdate> get onConfigUpdated {
    return _remoteConfig.onConfigUpdated;
  }
}
```

## Firebase Push Notifications

### FCM Service
```dart
// fcm_service.dart
class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initialize FCM
  static Future<void> initialize() async {
    try {
      // Request permission for notifications
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        LoggerService.info('FCM permission granted');
        
        // Get FCM token
        final token = await _messaging.getToken();
        if (token != null) {
          await _sendTokenToServer(token);
        }

        // Listen for token refresh
        _messaging.onTokenRefresh.listen(_sendTokenToServer);

        // Configure message handlers
        _configureForegroundMessageHandler();
        _configureBackgroundMessageHandler();
        _configureNotificationTapHandler();
        
      } else {
        LoggerService.warning('FCM permission not granted');
      }
    } catch (e) {
      LoggerService.error('Failed to initialize FCM: $e');
    }
  }

  static void _configureForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LoggerService.info('Received foreground message: ${message.messageId}');
      
      // Show local notification
      _showLocalNotification(message);
      
      // Handle data payload
      _handleMessageData(message.data);
    });
  }

  static void _configureBackgroundMessageHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void _configureNotificationTapHandler() {
    // Handle notification tap when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  static Future<void> _sendTokenToServer(String token) async {
    try {
      // Send token to your server
      await Dio().post(
        '${EnvironmentConfig.apiBaseUrl}/fcm/token',
        data: {'token': token},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await TokenStorage.getToken()}',
          },
        ),
      );
      
      LoggerService.info('FCM token sent to server');
    } catch (e) {
      LoggerService.error('Failed to send FCM token to server: $e');
    }
  }

  static void _showLocalNotification(RemoteMessage message) {
    // Implementation depends on your local notification setup
    // This is typically handled by flutter_local_notifications package
  }

  static void _handleMessageData(Map<String, dynamic> data) {
    // Handle custom data payload
    final type = data['type'];
    
    switch (type) {
      case 'new_movie':
        _handleNewMovieNotification(data);
        break;
      case 'favorite_update':
        _handleFavoriteUpdateNotification(data);
        break;
      case 'promotion':
        _handlePromotionNotification(data);
        break;
      default:
        LoggerService.info('Unhandled message type: $type');
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    final type = data['type'];
    
    switch (type) {
      case 'new_movie':
        final movieId = data['movie_id'];
        NavigationService.push('/movie/$movieId');
        break;
      case 'promotion':
        NavigationService.push('/limited-offer');
        break;
      default:
        NavigationService.push('/');
    }
  }

  static void _handleNewMovieNotification(Map<String, dynamic> data) {
    // Handle new movie notification
    final movieId = data['movie_id'];
    final movieTitle = data['movie_title'];
    
    AnalyticsService.trackFeatureUsage(
      featureName: 'notification_received',
      context: {
        'notification_type': 'new_movie',
        'movie_id': movieId,
      },
    );
  }

  static void _handleFavoriteUpdateNotification(Map<String, dynamic> data) {
    // Handle favorite update notification
    final movieId = data['movie_id'];
    
    // Refresh favorites list if user is on profile screen
    // This could be handled through BLoC events
  }

  static void _handlePromotionNotification(Map<String, dynamic> data) {
    // Handle promotion notification
    final offerType = data['offer_type'];
    
    AnalyticsService.trackFeatureUsage(
      featureName: 'notification_received',
      context: {
        'notification_type': 'promotion',
        'offer_type': offerType,
      },
    );
  }

  /// Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      LoggerService.info('Subscribed to topic: $topic');
    } catch (e) {
      LoggerService.error('Failed to subscribe to topic $topic: $e');
    }
  }

  /// Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      LoggerService.info('Unsubscribed from topic: $topic');
    } catch (e) {
      LoggerService.error('Failed to unsubscribe from topic $topic: $e');
    }
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  
  LoggerService.info('Received background message: ${message.messageId}');
  
  // Handle background message
  // Note: Limited operations available in background
}
```

## Testing Firebase Integration

### Firebase Testing Utilities
```dart
// firebase_test_helper.dart
class FirebaseTestHelper {
  static Future<void> initializeForTesting() async {
    // Use Firebase emulators for testing
    if (kDebugMode) {
      try {
        // Connect to Firestore emulator
        FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
        
        // Connect to Auth emulator
        await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
        
        LoggerService.info('Connected to Firebase emulators');
      } catch (e) {
        LoggerService.warning('Failed to connect to Firebase emulators: $e');
      }
    }
  }

  static void mockRemoteConfig(Map<String, dynamic> values) {
    // Mock remote config values for testing
    // This would require a custom implementation or test doubles
  }

  static void verifyAnalyticsEvent(String eventName) {
    // Verify that analytics event was logged
    // This would require analytics verification in tests
  }
}

// Example Firebase test
group('Firebase Integration Tests', () {
  setUpAll(() async {
    await FirebaseTestHelper.initializeForTesting();
  });

  group('Remote Config', () {
    test('should return default values when fetch fails', () {
      final isFeatureEnabled = RemoteConfigService.isLimitedOfferEnabled();
      expect(isFeatureEnabled, isTrue); // Default value
    });

    test('should handle version comparison correctly', () {
      // Test app update requirement logic
    });
  });

  group('Analytics', () {
    test('should track user events correctly', () async {
      await AnalyticsService.trackLogin(method: 'email');
      
      // Verify event was logged (requires test setup)
      FirebaseTestHelper.verifyAnalyticsEvent('login');
    });
  });
});
```

Bu kapsamlı Firebase entegrasyonu dokümantasyonu, ShartFlix uygulaması için Crashlytics, Analytics, Performance Monitoring ve Remote Config özelliklerinin eksiksiz bir şekilde uygulanması için sağlam bir temel sağlar. 