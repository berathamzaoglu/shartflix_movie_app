import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/movie.dart';

part 'movies_state.freezed.dart';

@freezed
abstract class MoviesState with _$MoviesState {
  const factory MoviesState.initial() = _Initial;
  const factory MoviesState.loading() = _Loading;
  const factory MoviesState.loaded({
    required List<Movie> movies,
    @Default(false) bool hasReachedMax,
    @Default(1) int currentPage,
  }) = _Loaded;
  const factory MoviesState.error(String message) = _Error;
} 