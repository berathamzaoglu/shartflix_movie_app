import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/movie.dart';
import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../bloc/movies_state.dart';

class MovieDiscoveryView extends StatefulWidget {
  const MovieDiscoveryView({super.key});

  @override
  State<MovieDiscoveryView> createState() => _MovieDiscoveryViewState();
}

class _MovieDiscoveryViewState extends State<MovieDiscoveryView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        return state.when(
          initial: () => const _LoadingView(),
          loading: () => const _LoadingView(),
          loaded: (movies, hasReachedMax, currentPage) {
            if (movies.isEmpty) {
              return const _EmptyView();
            }
            return _MoviePageView(
              movies: movies,
              pageController: _pageController,
              currentPage: _currentPage,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
                
                // Son sayfaya yaklaştığımızda daha fazla film yükle
                if (page >= movies.length - 2 && !hasReachedMax) {
                  context.read<MoviesBloc>().add(
                    const MoviesEvent.loadMoreMovies(),
                  );
                }
              },
              onToggleFavorite: (movie) {
                context.read<MoviesBloc>().add(
                  MoviesEvent.toggleFavorite(movie),
                );
              },
            );
          },
          error: (message) => _ErrorView(message: message),
        );
      },
    );
  }
}

class _MoviePageView extends StatelessWidget {
  final List<Movie> movies;
  final PageController pageController;
  final int currentPage;
  final Function(int) onPageChanged;
  final Function(Movie) onToggleFavorite;

  const _MoviePageView({
    required this.movies,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _MovieCard(
          movie: movie,
          onToggleFavorite: () => onToggleFavorite(movie),
        );
      },
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onToggleFavorite;

  const _MovieCard({
    required this.movie,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tam ekran film posteri
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: movie.fullPosterUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: const Color(0xFF1E293B),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFE53E3E),
                ),
              ),
            ),
            errorWidget: (context, url, error) {
              // Poster yüklenemezse backdrop image'ı dene
              if (movie.backdropPath != null && movie.backdropPath!.isNotEmpty) {
                return CachedNetworkImage(
                  imageUrl: movie.backdropPath!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFF1E293B),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE53E3E),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => _buildPlaceholder(),
                );
              }
              return _buildPlaceholder();
            },
          ),
        ),
        
        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.9),
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),
        
        // Favori butonu
        Positioned(
          bottom: 120,
          right: 24,
          child: GestureDetector(
            onTap: onToggleFavorite,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: movie.isFavorite ? const Color(0xFFE53E3E) : Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        
        // Film bilgileri
        Positioned(
          left: 24,
          right: 24,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // App ikonu ve başlık
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53E3E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Film açıklaması
              Text(
                movie.overview.isNotEmpty 
                    ? movie.overview.length > 100 
                        ? '${movie.overview.substring(0, 100)}... Daha Fazlası'
                        : movie.overview
                    : 'Açıklama bulunmuyor.',
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 16,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 16),
              
              // Film detayları
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    movie.voteAverage.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    movie.releaseDate.isNotEmpty 
                        ? movie.releaseDate
                        : 'N/A',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFF1E293B),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie,
              color: Color(0xFF64748B),
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Resim Yüklenemedi',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE53E3E),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie,
              color: Color(0xFF64748B),
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Film bulunamadı',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFFE53E3E),
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Bir hata oluştu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
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
  }
} 