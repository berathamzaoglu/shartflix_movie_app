# Navigation System

## Overview

The navigation system provides seamless user experience through a bottom navigation bar, smooth screen transitions, deep linking support, and state preservation. The system is built using Go Router for efficient route management and maintains navigation state across the application lifecycle.

## Core Features

### 1. Bottom Navigation Bar

#### Navigation Structure
- **Home Tab ("Anasayfa")**: Movie discovery and browsing
- **Profile Tab ("Profil")**: User profile and settings
- **Persistent State**: Maintains tab selection across app sessions
- **Badge Support**: Notification indicators for updates

#### UI Specifications
```dart
// Bottom Navigation Component
class MainBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        selectedLabelStyle: AppTextStyles.labelMedium,
        unselectedLabelStyle: AppTextStyles.labelSmall,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
```

#### Navigation State Management
```dart
// Navigation BLoC
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(currentIndex: 0));

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is NavigationTabChanged) {
      yield NavigationState(
        currentIndex: event.index,
        previousIndex: state.currentIndex,
      );
    }
  }
}

// Navigation State
class NavigationState {
  final int currentIndex;
  final int previousIndex;
  
  NavigationState({
    required this.currentIndex,
    this.previousIndex = 0,
  });
}

// Navigation Events
abstract class NavigationEvent {}

class NavigationTabChanged extends NavigationEvent {
  final int index;
  NavigationTabChanged(this.index);
}
```

### 2. Route Configuration with Go Router

#### Route Structure
```dart
// Router Configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Shell Route for Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationShell(child: child);
        },
        routes: [
          // Home Routes
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: '/movie/:id',
                name: 'movieDetail',
                builder: (context, state) {
                  final movieId = state.params['id']!;
                  return MovieDetailScreen(movieId: movieId);
                },
              ),
            ],
          ),
          
          // Profile Routes
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
              GoRoute(
                path: '/edit',
                name: 'editProfile',
                builder: (context, state) => const EditProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      
      // Auth Routes (Outside Shell)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Modal Routes
      GoRoute(
        path: '/limited-offer',
        name: 'limitedOffer',
        pageBuilder: (context, state) {
          return MaterialPage(
            fullscreenDialog: true,
            child: const LimitedOfferScreen(),
          );
        },
      ),
    ],
    
    // Redirect logic for authentication
    redirect: (context, state) {
      final isLoggedIn = AuthService.isLoggedIn();
      final isOnAuthPage = state.location.startsWith('/login') || 
                          state.location.startsWith('/register');
      
      if (!isLoggedIn && !isOnAuthPage) {
        return '/login';
      }
      
      if (isLoggedIn && isOnAuthPage) {
        return '/';
      }
      
      return null;
    },
  );
}
```

#### Navigation Shell Implementation
```dart
// Main Navigation Shell
class MainNavigationShell extends StatefulWidget {
  final Widget child;
  
  const MainNavigationShell({required this.child});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: MainBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Navigate based on tab selection
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/profile');
        break;
    }
    
    // Track navigation event
    AnalyticsService.trackNavigation('bottom_tab', {
      'tab_index': index,
      'tab_name': index == 0 ? 'home' : 'profile',
    });
  }
}
```

### 3. Screen Transitions and Animations

#### Custom Page Transitions
```dart
// Custom Page Route Builder
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final SlideDirection direction;

  SlidePageRoute({
    required this.child,
    this.direction = SlideDirection.rightToLeft,
    RouteSettings? settings,
  }) : super(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: _buildTransition,
  );

  static Widget _buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(
        Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut)),
      ),
      child: child,
    );
  }
}

enum SlideDirection {
  rightToLeft,
  leftToRight,
  topToBottom,
  bottomToTop,
}
```

#### Hero Animations
```dart
// Hero Animation for Movie Cards
class MovieCardHero extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return Hero(
      tag: 'movie-${movie.id}',
      child: GestureDetector(
        onTap: () {
          context.push('/movie/${movie.id}');
        },
        child: MovieCard(movie: movie),
      ),
    );
  }
}

// Movie Detail Screen with Hero Animation
class MovieDetailScreen extends StatelessWidget {
  final String movieId;

  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'movie-$movieId',
                child: MoviePosterImage(movieId: movieId),
              ),
            ),
          ),
          // Movie details content
        ],
      ),
    );
  }
}
```

### 4. Deep Linking Support

#### URL Structure
```dart
// Supported URL Patterns
const Map<String, String> urlPatterns = {
  'home': 'shartflix://home',
  'profile': 'shartflix://profile',
  'movie': 'shartflix://movie/{id}',
  'limited_offer': 'shartflix://offer',
  'search': 'shartflix://search?q={query}',
  'genre': 'shartflix://genre/{genre}',
};
```

#### Deep Link Handling
```dart
class DeepLinkHandler {
  static void initialize() {
    // Handle app launch from deep link
    _handleInitialLink();
    
    // Handle deep links while app is running
    _linkStream = linkStream.listen((String link) {
      _handleDeepLink(link);
    });
  }

  static Future<void> _handleInitialLink() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }
    } catch (e) {
      LoggerService.error('Failed to handle initial link: $e');
    }
  }

  static void _handleDeepLink(String link) {
    final uri = Uri.parse(link);
    
    switch (uri.host) {
      case 'movie':
        final movieId = uri.pathSegments.first;
        AppRouter.router.push('/movie/$movieId');
        break;
        
      case 'profile':
        AppRouter.router.push('/profile');
        break;
        
      case 'offer':
        AppRouter.router.push('/limited-offer');
        break;
        
      case 'search':
        final query = uri.queryParameters['q'] ?? '';
        AppRouter.router.push('/search?q=$query');
        break;
        
      default:
        AppRouter.router.push('/');
    }
  }
}
```

### 5. State Preservation

#### Navigation State Persistence
```dart
class NavigationStatePersistence {
  static const String _keyLastRoute = 'last_route';
  static const String _keyTabIndex = 'tab_index';

  static Future<void> saveNavigationState({
    required String route,
    required int tabIndex,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastRoute, route);
    await prefs.setInt(_keyTabIndex, tabIndex);
  }

  static Future<NavigationStateData?> getLastNavigationState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final route = prefs.getString(_keyLastRoute);
      final tabIndex = prefs.getInt(_keyTabIndex);
      
      if (route != null && tabIndex != null) {
        return NavigationStateData(
          route: route,
          tabIndex: tabIndex,
        );
      }
    } catch (e) {
      LoggerService.error('Failed to get navigation state: $e');
    }
    return null;
  }
}

class NavigationStateData {
  final String route;
  final int tabIndex;
  
  NavigationStateData({
    required this.route,
    required this.tabIndex,
  });
}
```

#### Screen State Preservation
```dart
// Automatic State Preservation with AutomaticKeepAliveClientMixin
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> 
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return MovieDiscoveryGrid();
  }
}

// Manual State Preservation
class MovieDiscoveryGrid extends StatefulWidget {
  @override
  State<MovieDiscoveryGrid> createState() => _MovieDiscoveryGridState();
}

class _MovieDiscoveryGridState extends State<MovieDiscoveryGrid> {
  ScrollController? _scrollController;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _restoreScrollPosition();
  }

  @override
  void dispose() {
    _saveScrollPosition();
    _scrollController?.dispose();
    super.dispose();
  }

  Future<void> _saveScrollPosition() async {
    if (_scrollController?.hasClients == true) {
      final position = _scrollController!.offset;
      await NavigationStatePersistence.saveScrollPosition('home', position);
    }
  }

  Future<void> _restoreScrollPosition() async {
    final position = await NavigationStatePersistence.getScrollPosition('home');
    if (position != null && _scrollController?.hasClients == true) {
      _scrollController!.jumpTo(position);
    }
  }
}
```

## Navigation Services

### Navigation Service Implementation
```dart
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = 
      GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  // Push new route
  static Future<T?> push<T>(String routeName, {Object? arguments}) {
    return Navigator.of(context!).pushNamed(routeName, arguments: arguments);
  }

  // Replace current route
  static Future<T?> pushReplacement<T>(String routeName, {Object? arguments}) {
    return Navigator.of(context!).pushReplacementNamed(
      routeName, 
      arguments: arguments,
    );
  }

  // Clear stack and push new route
  static Future<T?> pushAndClearStack<T>(String routeName, {Object? arguments}) {
    return Navigator.of(context!).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Pop current route
  static void pop<T>([T? result]) {
    return Navigator.of(context!).pop(result);
  }

  // Pop until specific route
  static void popUntil(String routeName) {
    return Navigator.of(context!).popUntil(ModalRoute.withName(routeName));
  }

  // Show bottom sheet
  static Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context!,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor ?? AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => child,
    );
  }

  // Show dialog
  static Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context!,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }
}
```

## Error Handling

### Navigation Error Handling
```dart
class NavigationErrorHandler {
  static Widget handleError(BuildContext context, GoRouterState state) {
    LoggerService.error('Navigation error: ${state.error}');
    
    return Scaffold(
      appBar: AppBar(title: const Text('Sayfa Bulunamadı')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Aradığınız sayfa bulunamadı',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Lütfen ana sayfaya dönün',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Ana Sayfa'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Performance Optimizations

### Route Lazy Loading
```dart
// Lazy route loading for better performance
class LazyRouteBuilder {
  static Widget buildLazyRoute(
    Widget Function() builder,
    String routeName,
  ) {
    return FutureBuilder(
      future: _preloadRoute(routeName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return builder();
        }
        return const LoadingScreen();
      },
    );
  }

  static Future<void> _preloadRoute(String routeName) async {
    // Preload necessary data for the route
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
```

### Memory Management
```dart
class NavigationMemoryManager {
  static final Map<String, Widget> _routeCache = {};
  static const int maxCacheSize = 5;

  static Widget getCachedRoute(String routeName, Widget Function() builder) {
    if (_routeCache.containsKey(routeName)) {
      return _routeCache[routeName]!;
    }

    final widget = builder();
    
    if (_routeCache.length >= maxCacheSize) {
      // Remove oldest cached route
      final oldestKey = _routeCache.keys.first;
      _routeCache.remove(oldestKey);
    }
    
    _routeCache[routeName] = widget;
    return widget;
  }

  static void clearCache() {
    _routeCache.clear();
  }
}
```

## Analytics and Monitoring

### Navigation Analytics
```dart
class NavigationAnalytics {
  static void trackScreenView({
    required String screenName,
    String? screenClass,
    Map<String, dynamic>? parameters,
  }) {
    FirebaseAnalytics.instance.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
      parameters: parameters,
    );
  }

  static void trackNavigation({
    required String from,
    required String to,
    String? method,
    Map<String, dynamic>? parameters,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'navigation',
      parameters: {
        'from_screen': from,
        'to_screen': to,
        'method': method ?? 'unknown',
        ...?parameters,
      },
    );
  }
}
```

## Testing Strategy

### Navigation Testing
```dart
// Navigation testing helpers
class NavigationTestHelpers {
  static Widget createTestApp({
    required Widget child,
    String initialRoute = '/',
  }) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: initialRoute,
      routes: AppRouter.testRoutes,
      home: child,
    );
  }

  static Future<void> navigateAndSettle(
    WidgetTester tester,
    String routeName,
  ) async {
    NavigationService.push(routeName);
    await tester.pumpAndSettle();
  }
}

// Example navigation test
group('Navigation Tests', () {
  testWidgets('should navigate to profile screen', (tester) async {
    await tester.pumpWidget(
      NavigationTestHelpers.createTestApp(
        child: const HomeScreen(),
      ),
    );

    // Tap profile tab
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    // Verify profile screen is displayed
    expect(find.byType(ProfileScreen), findsOneWidget);
  });
});
```

## Accessibility

### Navigation Accessibility
- **Screen Reader**: Proper semantic labels for navigation elements
- **Focus Management**: Logical focus order during navigation
- **Announcements**: Screen reader announcements for navigation changes
- **Keyboard Navigation**: Full keyboard support for navigation
- **High Contrast**: Navigation elements visible in high contrast mode 