import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection/injection.dart';
import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../bloc/movies_state.dart';
import '../widgets/movie_grid.dart';
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
    return BlocProvider(
      create: (context) => getIt<MoviesBloc>()
        ..add(const MoviesEvent.loadPopularMovies()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: [
              // Ana Sayfa - Film Keşif
              const MovieDiscoveryPage(),
              
              // Profil Sayfası
              Container(
                child: const Center(
                  child: Text(
                    'Profil Sayfası',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
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
        // Header with special offer button
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey.shade800,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profil Detayı',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        'Ayça Aydoğan',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'ID: 245677',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Special Offer Button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53E3E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Sınırlı Teklif',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Movies Grid
        Expanded(
          child: BlocBuilder<MoviesBloc, MoviesState>(
            builder: (context, state) {
              return state.when(
                initial: () => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFE53E3E),
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFE53E3E),
                  ),
                ),
                loaded: (movies, hasReachedMax, currentPage) {
                  return MovieGrid(
                    movies: movies,
                    hasReachedMax: hasReachedMax,
                    onLoadMore: () {
                      context.read<MoviesBloc>().add(
                        const MoviesEvent.loadMoreMovies(),
                      );
                    },
                    onRefresh: () {
                      context.read<MoviesBloc>().add(
                        const MoviesEvent.refreshMovies(),
                      );
                    },
                    onToggleFavorite: (movie) {
                      context.read<MoviesBloc>().add(
                        MoviesEvent.toggleFavorite(movie),
                      );
                    },
                  );
                },
                error: (message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFFE53E3E),
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bir hata oluştu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<MoviesBloc>().add(
                            const MoviesEvent.loadPopularMovies(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53E3E),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 