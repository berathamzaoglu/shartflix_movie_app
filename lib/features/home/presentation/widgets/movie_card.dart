import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/movie.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback onToggleFavorite;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onToggleFavorite,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    Logger.debug('MovieCard build: ${widget.movie.title} - Favorite: ${widget.movie.isFavorite}');
    
    return SizedBox(
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
                    Colors.black.withAlpha(76),
                    Colors.black.withAlpha(179),
                    Colors.black.withAlpha(230),
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),
          
          // Favori butonu - Dinamik konum
          Positioned(
            bottom: _isExpanded ? 240 : 180,
            right: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(82),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  width: 50,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(51), // 0.2 opacity
                    borderRadius: BorderRadius.circular(82),
                    border: Border.all(
                      color: Colors.white.withAlpha(128), // 0.5 opacity
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(51),
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
                          widget.movie.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.movie.isFavorite
                              ? const Color(0xFFE53E3E)
                              : Colors.white,
                          size: 28,
                        ),
                      ),
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
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                        color: const Color(0xFFE53E3E),
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
                          style: Theme.of(context).textTheme.bodyMedium
                        ),
                        if (widget.movie.overview.isNotEmpty && 
                            widget.movie.overview.length > 100 && 
                            !_isExpanded)
                          TextSpan(
                            text: AppLocalizations.of(context)!.movie_show_more,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:  Colors.white,
                              fontWeight: FontWeight.bold,
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
                            text: ' ${AppLocalizations.of(context)!.movie_show_less}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:  Colors.white,
                              fontWeight: FontWeight.bold,
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Text(
                      widget.movie.releaseDate.isNotEmpty 
                          ? widget.movie.releaseDate
                          : 'N/A',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(128),
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