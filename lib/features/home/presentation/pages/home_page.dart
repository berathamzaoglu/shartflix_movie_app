import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix_movie_app/features/profile/presentation/pages/profile_page.dart';

import '../../../../core/injection_container.dart';
import '../../../auth/auth_feature.dart';
import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../widgets/movie_discovery_view.dart';
import '../widgets/bottom_navigation_bar.dart';


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
        body: IndexedStack(
            index: _currentIndex,
            children: const [
              // Ana Sayfa - Film Keşif
              MovieDiscoveryPage(),
              
              // Profil Sayfası
              ProfilePage(),
            ],
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