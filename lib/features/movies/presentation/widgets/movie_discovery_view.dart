import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Son 200 piksel kaldığında daha fazla film yükle
      context.read<MoviesBloc>().add(const MoviesEvent.loadMoreMovies());
    }
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
            return _MovieListView(
              movies: movies,
              scrollController: _scrollController,
              hasReachedMax: hasReachedMax,
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

class _MovieListView extends StatelessWidget {
  final List<Movie> movies;
  final ScrollController scrollController;
  final bool hasReachedMax;
  final Function(Movie) onToggleFavorite;

  const _MovieListView({
    required this.movies,
    required this.scrollController,
    required this.hasReachedMax,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: movies.length + (hasReachedMax ? 0 : 1),
      itemBuilder: (context, index) {
        if (index >= movies.length) {
          // Loading indicator for pagination
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE53E3E),
              ),
            ),
          );
        }

        final movie = movies[index];
        return _MovieCard(
          movie: movie,
          onToggleFavorite: () => onToggleFavorite(movie),
        );
      },
    );
  }
}

class _MovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback onToggleFavorite;

  const _MovieCard({
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.8, // Ekranın %80'i kadar yükseklik
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        children: [
          // Tam ekran film posteri
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
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
          ),
          
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
            bottom: _isExpanded ? 140 : 180, // Daha yukarı taşıdım
            right: 24,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7), // Daha koyu arka plan
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
                  child: Icon(
                    widget.movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.movie.isFavorite ? const Color(0xFFE53E3E) : Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          
          // Film bilgileri - Dinamik konum
          Positioned(
            left: 24,
            right: 24,
            bottom: _isExpanded ? 24 : 24, // Expandable durumuna göre konum
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