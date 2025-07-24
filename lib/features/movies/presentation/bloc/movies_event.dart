import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/movie.dart';

part 'movies_event.freezed.dart';

@freezed
abstract class MoviesEvent with _$MoviesEvent {
  const factory MoviesEvent.loadPopularMovies() = LoadPopularMovies;
  const factory MoviesEvent.loadMoreMovies() = LoadMoreMovies;
  const factory MoviesEvent.refreshMovies() = RefreshMovies;
  const factory MoviesEvent.toggleFavorite(Movie movie) = ToggleFavorite;
  const factory MoviesEvent.searchMovies(String query) = SearchMovies;
} 