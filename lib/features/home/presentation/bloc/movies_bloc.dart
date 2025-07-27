import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix_movie_app/features/home/data/models/movie_model.dart';

import '../../../../core/utils/logger.dart';
import '../../../../core/services/analytics_helper.dart';
import '../../../../core/services/crashlytics_helper.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_popular_movies_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetPopularMoviesUseCase _getPopularMoviesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  // Cache yapısı
  DateTime? _lastLoadTime;
  static const Duration _cacheDuration = Duration(minutes: 5); // 5 dakika cache
  bool _isLoading = false;

  MoviesBloc(
    this._getPopularMoviesUseCase,
    this._toggleFavoriteUseCase,
  ) : super(const MoviesState.initial()) {
    on<LoadPopularMovies>(_onLoadPopularMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<RefreshMovies>(_onRefreshMovies);
    on<ToggleFavorite>(_onToggleFavorite);
    on<SearchMovies>(_onSearchMovies);
  }

  /// Cache'in geçerli olup olmadığını kontrol eder
  bool get _isCacheValid {
    if (_lastLoadTime == null) return false;
    return DateTime.now().difference(_lastLoadTime!) < _cacheDuration;
  }

  /// Cache'i geçersiz kılar (refresh için)
  void _invalidateCache() {
    _lastLoadTime = null;
  }

  Future<void> _onLoadPopularMovies(
    LoadPopularMovies event,
    Emitter<MoviesState> emit,
  ) async {
    // Eğer zaten loading durumundaysa, yeni request yapma
    if (_isLoading) {
      Logger.info('Already loading movies, skipping request');
      return;
    }

    // Cache kontrolü - eğer cache geçerliyse ve data varsa, API çağrısı yapma
    if (_isCacheValid && state.maybeWhen(
      loaded: (movies, hasReachedMax, currentPage) => movies.isNotEmpty,
      orElse: () => false,
    )) {
      Logger.info('Using cached data, skipping API call');
      return;
    }

    _isLoading = true;
    emit(const MoviesState.loading());
    
    // Analytics: Load popular movies
    await AnalyticsHelper.logCustomEvent(
      name: 'load_popular_movies',
      parameters: {'page': 1},
    );
    await CrashlyticsHelper.log('Loading popular movies - page 1');
    
    final result = await _getPopularMoviesUseCase(
      const GetPopularMoviesParams(page: 1),
    );
    
    result.fold(
      (failure) {
        Logger.error('Failed to load popular movies: ${failure.message}');
        
        // Analytics: Load movies failure
        AnalyticsHelper.logError(
          errorType: 'load_movies_failure',
          errorMessage: failure.message,
          screenName: 'home_page',
        );
        
        // Crashlytics: Record load movies error
        CrashlyticsHelper.recordError(
          Exception('Failed to load popular movies: ${failure.message}'),
          null,
          reason: 'Load popular movies failure',
        );
        
        emit(MoviesState.error(failure.message));
      },
      (moviesResponse) {
        final movies = moviesResponse.movies.map((model) => model.toEntity()).toList();
        Logger.info('Loaded ${movies.length} popular movies for page 1');
        
        // Cache'i güncelle
        _lastLoadTime = DateTime.now();
        
        // Analytics: Load movies success
        AnalyticsHelper.logCustomEvent(
          name: 'movies_loaded',
          parameters: {
            'count': movies.length,
            'page': 1,
            'total_pages': moviesResponse.pagination.maxPage,
          },
        );
        
        emit(MoviesState.loaded(
          movies: movies,
          currentPage: moviesResponse.pagination.currentPage,
          hasReachedMax: moviesResponse.pagination.currentPage >= moviesResponse.pagination.maxPage,
        ));
      },
    );
    
    _isLoading = false;
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMovies event,
    Emitter<MoviesState> emit,
  ) async {
    final currentState = state;
    
    // State'in loaded olup olmadığını kontrol et
    final loadedState = currentState.maybeWhen(
      loaded: (movies, hasReachedMax, currentPage) => 
          (movies: movies, hasReachedMax: hasReachedMax, currentPage: currentPage),
      orElse: () => null,
    );
    
    if (loadedState == null) return;
    if (loadedState.hasReachedMax) return;
    if (_isLoading) {
      Logger.info('Already loading more movies, skipping request');
      return;
    }

    _isLoading = true;
    final nextPage = loadedState.currentPage + 1;
    
    final result = await _getPopularMoviesUseCase(
      GetPopularMoviesParams(page: nextPage),
    );
    
    result.fold(
      (failure) {
        Logger.error('Failed to load more movies: ${failure.message}');
        emit(MoviesState.error(failure.message));
      },
      (moviesResponse) {
        final newMovies = moviesResponse.movies.map((model) => model.toEntity()).toList();
        Logger.info('Loaded ${newMovies.length} more movies (page $nextPage)');
        
        // Cache'i güncelle
        _lastLoadTime = DateTime.now();
        
        emit(MoviesState.loaded(
          movies: [...loadedState.movies, ...newMovies],
          currentPage: moviesResponse.pagination.currentPage,
          hasReachedMax: moviesResponse.pagination.currentPage >= moviesResponse.pagination.maxPage,
        ));
      },
    );
    
    _isLoading = false;
  }

  Future<void> _onRefreshMovies(
    RefreshMovies event,
    Emitter<MoviesState> emit,
  ) async {
    Logger.info('Refreshing movies - invalidating cache');
    _invalidateCache(); // Cache'i geçersiz kıl
    add(const MoviesEvent.loadPopularMovies());
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<MoviesState> emit,
  ) async {
    Logger.info('=== TOGGLE FAVORITE START ===');
    Logger.info('Movie: ${event.movie.title} (ID: ${event.movie.id})');
    Logger.info('Current favorite status: ${event.movie.isFavorite}');
    
    // Analytics: Toggle favorite attempt
    await AnalyticsHelper.logMovieFavorite(
      movieId: event.movie.id,
      movieTitle: event.movie.title,
      isFavorite: !event.movie.isFavorite, // Toggle edilecek durum
    );
    await CrashlyticsHelper.log('Toggle favorite for movie: ${event.movie.title}');
    
    final result = await _toggleFavoriteUseCase(
      ToggleFavoriteParams(movie: event.movie),
    );
    
    result.fold(
      (failure) {
        Logger.error('Failed to toggle favorite: ${failure.message}');
        
        // Analytics: Toggle favorite failure
        AnalyticsHelper.logError(
          errorType: 'toggle_favorite_failure',
          errorMessage: failure.message,
          screenName: 'home_page',
        );
        
        // Crashlytics: Record toggle favorite error
        CrashlyticsHelper.recordError(
          Exception('Failed to toggle favorite: ${failure.message}'),
          null,
          reason: 'Toggle favorite failure for movie ${event.movie.title}',
        );
      },
      (responseData) {
        Logger.info('API response: $responseData');
        
        // API'den dönen movie bilgisini al
        final success = responseData['success'] ?? false;
        final movieData = responseData['data']?['movie'];
        
        Logger.info('API success: $success');
        Logger.info('Movie data: $movieData');
        
        // Mevcut state'i al
        final currentState = state;
        Logger.info('Current state type: ${currentState.runtimeType}');
        
        // State'i güncelle
        currentState.when(
          initial: () {
            Logger.warning('Cannot update - state is initial');
          },
          loading: () {
            Logger.warning('Cannot update - state is loading');
          },
          loaded: (movies, hasReachedMax, currentPage) {
            Logger.info('Updating loaded state with ${movies.length} movies');
            
            // Movie'yi bul ve güncelle
            final movieIndex = movies.indexWhere((movie) => movie.id == event.movie.id);
            if (movieIndex != -1) {
              Logger.info('Found movie at index: $movieIndex');
              Logger.info('Old favorite status: ${movies[movieIndex].isFavorite}');
              
              // Yeni favorite durumu: API'den dönen movie bilgisini kullan
              bool newFavoriteStatus;
              if (movieData != null && movieData['isFavorite'] != null) {
                newFavoriteStatus = movieData['isFavorite'] as bool;
                Logger.info('Using API movie data for favorite status: $newFavoriteStatus');
              } else {
                // Fallback: API success ise tersine çevir
                newFavoriteStatus = success ? !movies[movieIndex].isFavorite : movies[movieIndex].isFavorite;
                Logger.info('Using fallback favorite status: $newFavoriteStatus');
              }
              
              Logger.info('New favorite status: $newFavoriteStatus');
              
              // Analytics: Toggle favorite success
              AnalyticsHelper.logMovieFavorite(
                movieId: event.movie.id,
                movieTitle: event.movie.title,
                isFavorite: newFavoriteStatus,
              );
              
              // Yeni movies listesi oluştur
              final updatedMovies = List<Movie>.from(movies);
              updatedMovies[movieIndex] = updatedMovies[movieIndex].copyWith(isFavorite: newFavoriteStatus);
              
              Logger.info('Emitting new state...');
              emit(MoviesState.loaded(
                movies: updatedMovies,
                currentPage: currentPage,
                hasReachedMax: hasReachedMax,
              ));
              Logger.info('State emitted successfully');
            } else {
              Logger.error('Movie not found in list! ID: ${event.movie.id}');
              Logger.error('Available movie IDs: ${movies.map((m) => m.id).toList()}');
              
              // Crashlytics: Record movie not found error
              CrashlyticsHelper.recordError(
                Exception('Movie not found in list'),
                null,
                reason: 'Movie ${event.movie.id} not found in movies list',
              );
            }
          },
          error: (message) {
            Logger.warning('Cannot update - state is error: $message');
          },
        );
      },
    );
    Logger.info('=== TOGGLE FAVORITE END ===');
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MoviesState> emit,
  ) async {
    // TODO: Implement search functionality
    Logger.info('Search movies: ${event.query}');
    
    // Analytics: Search attempt
    await AnalyticsHelper.logSearch(searchTerm: event.query);
    await CrashlyticsHelper.log('Search movies: ${event.query}');
  }
} 