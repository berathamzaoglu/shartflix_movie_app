import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/movie.dart';
import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import 'movie_card.dart';

class MoviePageView extends StatelessWidget {
  final List<Movie> movies;
  final PageController pageController;
  final bool hasReachedMax;
  final Function(Movie) onToggleFavorite;
  final int currentPage;

  const MoviePageView({
    super.key,
    required this.movies,
    required this.pageController,
    required this.hasReachedMax,
    required this.onToggleFavorite,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Film sayfaları
        RefreshIndicator(
          onRefresh: () async {
            // Refresh event'i gönder (cache'i geçersiz kılar)
            context.read<MoviesBloc>().add(const MoviesEvent.refreshMovies());
            // Refresh tamamlanana kadar bekle
            await Future.delayed(const Duration(seconds: 2));
          },
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.vertical,
            pageSnapping: true,
            physics: const BouncingScrollPhysics(),
            itemCount: movies.length + (hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= movies.length) {
                // Loading indicator for pagination
                final l10n = AppLocalizations.of(context)!;
                
                return Skeletonizer(
                  enabled: true,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        // Skeleton poster
                        Positioned.fill(
                          child: Container(
                            color: const Color(0xFF1E293B),
                            child: const Center(
                              child: Icon(
                                Icons.movie,
                                color: Color(0xFF64748B),
                                size: 64,
                              ),
                            ),
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
                                  Colors.black.withAlpha(76),
                                  Colors.black.withAlpha(179),
                                  Colors.black.withAlpha(230),
                                ],
                                stops: const [0.0, 0.4, 0.7, 1.0],
                              ),
                            ),
                          ),
                        ),
                        
                        // Loading mesajı
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.4,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(204),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Color(0xFFE53E3E),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.home_load_more,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final movie = movies[index];
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: MovieCard(
                  key: ValueKey(movie.id),
                  movie: movie,
                  onToggleFavorite: () => onToggleFavorite(movie),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 