import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/injection_container.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/home/presentation/bloc/movies_bloc.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
        ),
        BlocProvider<MoviesBloc>(
          create: (context) => getIt<MoviesBloc>(),
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
        
        // Localization (TODO: Implement)
        // locale: const Locale('tr', 'TR'),
        // supportedLocales: const [
        //   Locale('tr', 'TR'),
        //   Locale('en', 'US'),
        // ],
      ),
    );
  }
} 