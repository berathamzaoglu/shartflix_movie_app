import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/movie.dart';
import 'movie_card.dart';

class MovieGrid extends StatefulWidget {
  final List<Movie> movies;
  final bool hasReachedMax;
  final VoidCallback onLoadMore;
  final VoidCallback onRefresh;
  final Function(Movie) onToggleFavorite;

  const MovieGrid({
    super.key,
    required this.movies,
    required this.hasReachedMax,
    required this.onLoadMore,
    required this.onRefresh,
    required this.onToggleFavorite,
  });

  @override
  State<MovieGrid> createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {
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
    if (_isBottom && !widget.hasReachedMax) {
      widget.onLoadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh();
      },
      color: const Color(0xFFE53E3E),
      backgroundColor: const Color(0xFF374151),
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6, // 2:3 aspect ratio for movie posters
          crossAxisSpacing: 16,
          mainAxisSpacing: 20,
        ),
        itemCount: widget.movies.length + (widget.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= widget.movies.length) {
            // Loading indicator at bottom
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE53E3E),
              ),
            );
          }

          final movie = widget.movies[index];
          return MovieCard(
            movie: movie,
            onTap: () {
              // TODO: Navigate to movie details
            },
            onToggleFavorite: () {
              widget.onToggleFavorite(movie);
            },
          );
        },
      ),
    );
  }
} 