import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_event.freezed.dart';

@freezed
abstract class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.loadFavoriteMovies() = LoadFavoriteMovies;
  const factory ProfileEvent.removeFavorite(String movieId) = RemoveFavorite;
  const factory ProfileEvent.refreshFavoriteMovies() = RefreshFavoriteMovies;
} 