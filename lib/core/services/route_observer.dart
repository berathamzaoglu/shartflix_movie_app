import 'package:flutter/material.dart';

import 'analytics_helper.dart';
import 'crashlytics_helper.dart';

/// Sayfa görüntülemelerini takip etmek için route observer
class AnalyticsRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _sendScreenView(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _sendScreenView(newRoute, oldRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null && route.isCurrent) {
      _sendScreenView(previousRoute, null);
    }
  }

  void _sendScreenView(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final String? screenName = _getScreenName(route);
    final String? previousScreenName = previousRoute != null ? _getScreenName(previousRoute) : null;

    if (screenName != null) {
      // Analytics: Screen view
      AnalyticsHelper.logScreenView(
        screenName: screenName,
        screenClass: route.runtimeType.toString(),
      );

      // Crashlytics: Log screen view
      CrashlyticsHelper.log('Screen view: $screenName');
      
      // Crashlytics: Record app state change
      CrashlyticsHelper.recordAppState(
        state: 'screen_view',
        previousState: previousScreenName,
        context: {
          'screen_name': screenName,
          'route_type': route.runtimeType.toString(),
        },
      );
    }
  }

  String? _getScreenName(Route<dynamic> route) {
    if (route.settings.name != null) {
      return route.settings.name;
    }
    
    // Route adı yoksa, route tipini kullan
    return route.runtimeType.toString();
  }
} 