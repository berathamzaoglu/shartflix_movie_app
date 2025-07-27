import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/injection_container.dart';
import '../../core/services/route_observer.dart';
import '../../core/usecases/usecase.dart';
import '../../features/auth/auth_feature.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/home_feature.dart';
import '../../features/home/presentation/pages/movie_discovery_page.dart';
import '../../features/profile/presentation/pages/profile_wrapper_page.dart';
import '../../features/home/presentation/widgets/bottom_navigation_bar.dart';

class AppRouter {
  static GoRouter? _router;

  static GoRouter get router {
    if (_router == null) {
      throw StateError('Router not initialized. Call AppRouter.initialize() first.');
    }
    return _router!;
  }

  static void initialize() {
    _router = GoRouter(
      initialLocation: '/login',
      observers: [
        AnalyticsRouteObserver(),
      ],
      redirect: (context, state) async {
        // Auth durumunu kontrol et
        try {
          // Dependency injection'ın hazır olup olmadığını kontrol et
          if (!getIt.isRegistered<CheckAuthStatusUseCase>()) {
            debugPrint('CheckAuthStatusUseCase not registered yet, staying on current route');
            return null;
          }
          
          final checkAuthStatusUseCase = getIt<CheckAuthStatusUseCase>();
          final result = await checkAuthStatusUseCase(NoParams());
          
          final isAuthenticated = result.fold(
            (failure) => false,
            (user) => user != null,
          );
          
          final isLoginRoute = state.matchedLocation == '/login';
          final isRegisterRoute = state.matchedLocation == '/register';
          
          // Eğer kullanıcı giriş yapmışsa ve login/register sayfalarındaysa home'a yönlendir
          if (isAuthenticated && (isLoginRoute || isRegisterRoute)) {
            return '/home';
          }
          
          // Eğer kullanıcı giriş yapmamışsa ve protected route'lardaysa login'e yönlendir
          if (!isAuthenticated && !isLoginRoute && !isRegisterRoute) {
            return '/login';
          }
          
          // Diğer durumlarda yönlendirme yapma
          return null;
        } catch (e) {
          // Hata durumunda login'e yönlendir
          debugPrint('Router redirect error: $e');
          return '/login';
        }
      },
      routes: [
        // Auth Routes
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const RegisterPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
          ),
        ),
        
        // Main App Shell Route
        ShellRoute(
          builder: (context, state, child) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>(
                  create: (context) => getIt<AuthBloc>()
                    ..add(const AuthEvent.checkAuthStatus()),
                ),
                BlocProvider<MoviesBloc>(
                  create: (context) => getIt<MoviesBloc>(),
                ),
              ],
              child: Scaffold(
                body: child,
                bottomNavigationBar: CustomBottomNavigationBar(
                  currentIndex: _getCurrentIndex(state.matchedLocation),
                  onTap: (index) {
                    final currentIndex = _getCurrentIndex(state.matchedLocation);
                    
                    // Sadece farklı bir tab'a geçiş yapılıyorsa
                    if (index != currentIndex) {
                      switch (index) {
                        case 0:
                          context.go('/home');
                          break;
                        case 1:
                          context.go('/profile');
                          break;
                      }
                    }
                  },
                ),
              ),
            );
          },
          routes: [
            // Home Route
            GoRoute(
              path: '/home',
              name: 'home',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const MovieDiscoveryPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  // Bottom navigation geçişleri için yumuşak fade animasyonu
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                    child: child,
                  );
                },
              ),
            ),
            
            // Profile Route
            GoRoute(
              path: '/profile',
              name: 'profile',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ProfileWrapperPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  // Bottom navigation geçişleri için yumuşak fade animasyonu
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                    child: child,
                  );
                },
              ),
            ),
          ],
        ),
      ],
      
      // Error Page
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Sayfa bulunamadı: ${state.uri}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Ana Sayfaya Dön'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mevcut route'a göre bottom navigation bar index'ini döndürür
  static int _getCurrentIndex(String location) {
    switch (location) {
      case '/home':
        return 0;
      case '/profile':
        return 1;
      default:
        return 0;
    }
  }
} 