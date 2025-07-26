import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection/injection.dart';
import '../../../auth/auth_feature.dart';
import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../bloc/movies_state.dart';
import '../widgets/movie_discovery_view.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/limited_offer_bottom_sheet.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesBloc>(
          create: (context) => getIt<MoviesBloc>()
            ..add(const MoviesEvent.loadPopularMovies()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()
            ..add(const AuthEvent.checkAuthStatus()),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: [
              // Ana Sayfa - Film Keşif
              const MovieDiscoveryPage(),
              
              // Profil Sayfası
              const ProfilePage(),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class MovieDiscoveryPage extends StatelessWidget {
  const MovieDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
            
        // Movie Discovery View
        Expanded(
          child: const MovieDiscoveryView(),
        ),
      ],
    );
  }
} 