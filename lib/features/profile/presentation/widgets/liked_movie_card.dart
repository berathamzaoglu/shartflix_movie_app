import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/domain/entities/movie.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';

class LikedMovieCard extends StatelessWidget {
  final Movie movie;

  const LikedMovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Poster
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: movie.fullPosterUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF374151),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFE53E3E),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFF374151),
                        child: const Center(
                          child: Icon(
                            Icons.movie,
                            color: Color(0xFF64748B),
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Favorite Icon with Toggle
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        // Favori filmden çıkar
                        context.read<ProfileBloc>().add(
                          ProfileEvent.removeFavorite(movie.id),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(128),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: const Color(0xFFE53E3E),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Movie Info
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontFamily: 'EuclidCircular',
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    movie.releaseDate.isNotEmpty 
                        ? movie.releaseDate.split('-').first 
                        : l10n.common_na,
                    style: TextStyle(
                      color: Colors.white.withAlpha(128),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 