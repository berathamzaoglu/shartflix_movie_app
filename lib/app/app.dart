import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';

import '../core/injection_container.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/home/presentation/bloc/movies_bloc.dart';
import '../features/home/presentation/bloc/movies_event.dart';
import '../features/home/presentation/bloc/movies_state.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) {
            final authBloc = getIt<AuthBloc>();
            // App başlatıldığında auth durumunu kontrol et
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                if (authBloc.state.maybeWhen(
                  initial: () => true,
                  orElse: () => false,
                )) {
                  authBloc.add(const AuthEvent.checkAuthStatus());
                }
              } catch (e) {
                debugPrint('AuthBloc not ready for checkAuthStatus: $e');
              }
            });
            return authBloc;
          },
        ),
        BlocProvider<MoviesBloc>(
          create: (context) {
            final moviesBloc = getIt<MoviesBloc>();
            // App başlatıldığında popüler filmleri yükle
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                if (moviesBloc.state.maybeWhen(
                  initial: () => true,
                  orElse: () => false,
                )) {
                  moviesBloc.add(const MoviesEvent.loadPopularMovies());
                }
              } catch (e) {
                debugPrint('MoviesBloc not ready for loadPopularMovies: $e');
              }
            });
            return moviesBloc;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'ShartFlix',
        debugShowCheckedModeBanner: false,
        
        // Themes
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        
        // Router
        routerConfig: AppRouter.router,
        
        // Localization
        locale: const Locale('tr', 'TR'),
        supportedLocales: const [
          Locale('tr', 'TR'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
} 