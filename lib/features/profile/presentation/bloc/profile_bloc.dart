import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix_movie_app/core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/get_favorite_movies_usecase.dart';
import '../../domain/usecases/remove_favorite_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetFavoriteMoviesUseCase _getFavoriteMoviesUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;

  // Cache sistemi için değişkenler
  DateTime? _lastLoadTime;
  final Duration _cacheDuration = const Duration(minutes: 5);
  bool _isLoading = false;

  ProfileBloc(this._getFavoriteMoviesUseCase, this._removeFavoriteUseCase) : super(const ProfileState.initial()) {
    on<LoadFavoriteMovies>(_onLoadFavoriteMovies);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<RefreshFavoriteMovies>(_onRefreshFavoriteMovies);
  }

  Future<void> _onLoadFavoriteMovies(
    LoadFavoriteMovies event,
    Emitter<ProfileState> emit,
  ) async {
    // Cache kontrolü
    if (_isLoading) {
      Logger.info('Already loading favorite movies, skipping...');
      return;
    }

    final now = DateTime.now();
    if (_lastLoadTime != null && 
        now.difference(_lastLoadTime!) < _cacheDuration) {
      // State'in loaded olup olmadığını kontrol et
      final isLoaded = state.when(
        initial: () => false,
        loading: () => false,
        loaded: (movies) => true,
        error: (message) => false,
      );
      
            if (isLoaded) {
        Logger.info('Using cached favorite movies data');
        return;
      }
    }

    _isLoading = true;
    emit(const ProfileState.loading());
    
    final result = await _getFavoriteMoviesUseCase(const NoParams());
    
    _isLoading = false;
    _lastLoadTime = now;
    
    result.fold(
      (failure) {
        Logger.error('Failed to load favorite movies: ${failure.message}');
        emit(ProfileState.error(failure.message));
      },
      (movies) {
        Logger.info('Loaded ${movies.length} favorite movies');
        emit(ProfileState.loaded(movies: movies));
      },
    );
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _removeFavoriteUseCase(event.movieId);
    
    result.fold(
      (failure) {
        Logger.error('Failed to remove favorite: ${failure.message}');
        // Hata durumunda mevcut state'i koru
      },
      (success) {
        if (success) {
          Logger.info('Successfully removed favorite: ${event.movieId}');
          // Cache'i temizle ve listeyi yenile
          _lastLoadTime = null;
          add(const ProfileEvent.loadFavoriteMovies());
        } else {
          Logger.error('Failed to remove favorite: ${event.movieId}');
        }
      },
    );
  }

  Future<void> _onRefreshFavoriteMovies(
    RefreshFavoriteMovies event,
    Emitter<ProfileState> emit,
  ) async {
    Logger.info('🔄 ProfileBloc: RefreshFavoriteMovies event received');
    // Cache'i temizle ve yeniden yükle
    _lastLoadTime = null;
    _isLoading = false;
    Logger.info('🗑️ ProfileBloc: Cache cleared, loading fresh data');
    add(const ProfileEvent.loadFavoriteMovies());
  }
} 