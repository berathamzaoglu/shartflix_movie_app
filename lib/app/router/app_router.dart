import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/injection_container.dart';
import '../../core/services/route_observer.dart';
import '../../core/usecases/usecase.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

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
            print('CheckAuthStatusUseCase not registered yet, staying on current route');
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
          print('Router redirect error: $e');
          return '/login';
        }
      },
      routes: [
        // Auth Routes
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
        
        // Main App Routes
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        
        // Profile Routes
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text('Profile Page - TODO: Implement'),
            ),
          ),
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
} 