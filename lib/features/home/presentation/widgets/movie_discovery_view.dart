import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/utils/logger.dart';
import '../../../../l10n/app_localizations.dart';

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
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    final newPage = _pageController.page?.round() ?? 0;
    if (newPage != _currentPage) {
      setState(() {
        _currentPage = newPage;
      });
      
      // Son sayfaya yaklaştığında daha fazla film yükle
      final moviesBloc = context.read<MoviesBloc>();
      final state = moviesBloc.state;
      state.when(
        initial: () {},
        loading: () {},
        loaded: (movies, hasReachedMax, currentPage) {
          if (!hasReachedMax && newPage >= movies.length - 3) {
            moviesBloc.add(const MoviesEvent.loadMoreMovies());
          }
        },
        error: (message) {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        Logger.debug('MovieDiscoveryView rebuild - State: ${state.runtimeType}');
        
        return state.when(
          initial: () => const _LoadingView(),
          loading: () => const _LoadingView(),
          loaded: (movies, hasReachedMax, currentPage) {
            Logger.debug('Loaded state with ${movies.length} movies');
            // Favori durumlarını kontrol et
            final favoriteCount = movies.where((m) => m.isFavorite).length;
            Logger.debug('Favorite movies count: $favoriteCount');
            
            if (movies.isEmpty) {
              return const _EmptyView();
            }
            return _MoviePageView(
              movies: movies,
              pageController: _pageController,
              hasReachedMax: hasReachedMax,
              onToggleFavorite: (movie) {
                Logger.info('Favori butonuna tıklandı: ${movie.title} (ID: ${movie.id})');
                Logger.info('Mevcut favorite durumu: ${movie.isFavorite}');
                context.read<MoviesBloc>().add(
                  MoviesEvent.toggleFavorite(movie),
                );
              },
              currentPage: _currentPage,
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
  final bool hasReachedMax;
  final Function(Movie) onToggleFavorite;
  final int currentPage;

  const _MoviePageView({
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
            context.read<MoviesBloc>().add(const MoviesEvent.loadPopularMovies());
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
                  child: Container(
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
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.7),
                                  Colors.black.withOpacity(0.9),
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
                                color: Colors.black.withOpacity(0.8),
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
                child: _MovieCard(
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

class _MovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback onToggleFavorite;

  const _MovieCard({
    super.key,
    required this.movie,
    required this.onToggleFavorite,
  });

  @override
  State<_MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<_MovieCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    Logger.debug('MovieCard build: ${widget.movie.title} - Favorite: ${widget.movie.isFavorite}');
    
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          // Tam ekran film posteri
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.movie.fullPosterUrl,
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
                if (widget.movie.backdropPath != null && widget.movie.backdropPath!.isNotEmpty) {
                  return CachedNetworkImage(
                    imageUrl: widget.movie.backdropPath!,
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
          
          // Favori butonu - Dinamik konum
          Positioned(
            bottom: _isExpanded ? 140 : 180,
            right: 24,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onToggleFavorite,
                  borderRadius: BorderRadius.circular(28),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      key: ValueKey(widget.movie.isFavorite),
                      widget.movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: widget.movie.isFavorite ? const Color(0xFFE53E3E) : Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Film bilgileri - Dinamik konum
          Positioned(
            left: 24,
            right: 24,
            bottom: _isExpanded ? 24 : 24,
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
                        widget.movie.title,
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
                
                // Film açıklaması - Expandable
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 16,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: widget.movie.overview.isNotEmpty 
                              ? _isExpanded 
                                  ? widget.movie.overview
                                  : widget.movie.overview.length > 100 
                                      ? '${widget.movie.overview.substring(0, 100)}... '
                                      : widget.movie.overview
                              : 'Açıklama bulunmuyor.',
                        ),
                        if (widget.movie.overview.isNotEmpty && 
                            widget.movie.overview.length > 100 && 
                            !_isExpanded)
                          TextSpan(
                            text: 'Daha Fazlası',
                            style: const TextStyle(
                              color: Color(0xFFE53E3E),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  _isExpanded = true;
                                });
                              },
                          ),
                        if (widget.movie.overview.isNotEmpty && 
                            widget.movie.overview.length > 100 && 
                            _isExpanded)
                          TextSpan(
                            text: ' Daha Az',
                            style: const TextStyle(
                              color: Color(0xFFE53E3E),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  _isExpanded = false;
                                });
                              },
                          ),
                      ],
                    ),
                  ),
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
                      widget.movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Text(
                      widget.movie.releaseDate.isNotEmpty 
                          ? widget.movie.releaseDate
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
      ),
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
      child: Skeletonizer(
        enabled: true,
        child: PageView.builder(
          itemCount: 3,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Container(
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
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.9),
                          ],
                          stops: const [0.0, 0.4, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),
                  
                  // Skeleton favori butonu
                  Positioned(
                    bottom: 180,
                    right: 24,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  
                  // Skeleton film bilgileri
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
                              child: Container(
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Skeleton açıklama
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 16,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 16,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 16,
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Skeleton detaylar
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Container(
                              height: 20,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      color: const Color(0xFF0F172A),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.movie,
              color: Color(0xFF64748B),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.home_no_movies_found,
              style: const TextStyle(
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
    final l10n = AppLocalizations.of(context)!;
    
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
            Text(
              l10n.errors_general_error,
              style: const TextStyle(
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
              child: Text(l10n.errors_try_again),
            ),
          ],
        ),
      ),
    );
  }
} 