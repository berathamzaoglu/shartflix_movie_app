import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix_movie_app/features/movies/movies_feature.dart';

import '../../../../core/utils/logger.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_popular_movies_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../data/models/movies_response_model.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetPopularMoviesUseCase _getPopularMoviesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

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

  Future<void> _onLoadPopularMovies(
    LoadPopularMovies event,
    Emitter<MoviesState> emit,
  ) async {
    emit(const MoviesState.loading());
    
    final result = await _getPopularMoviesUseCase(
      const GetPopularMoviesParams(page: 1),
    );
    
    result.fold(
      (failure) {
        Logger.error('Failed to load popular movies: ${failure.message}');
        emit(MoviesState.error(failure.message));
      },
      (moviesResponse) {
        final movies = moviesResponse.movies.map((model) => model.toEntity()).toList();
        Logger.info('Loaded ${movies.length} popular movies for page 1');
        emit(MoviesState.loaded(
          movies: movies,
          currentPage: moviesResponse.pagination.currentPage,
          hasReachedMax: moviesResponse.pagination.currentPage >= moviesResponse.pagination.maxPage,
        ));
      },
    );
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
        emit(MoviesState.loaded(
          movies: [...loadedState.movies, ...newMovies],
          currentPage: moviesResponse.pagination.currentPage,
          hasReachedMax: moviesResponse.pagination.currentPage >= moviesResponse.pagination.maxPage,
        ));
      },
    );
  }

  Future<void> _onRefreshMovies(
    RefreshMovies event,
    Emitter<MoviesState> emit,
  ) async {
    add(const MoviesEvent.loadPopularMovies());
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<MoviesState> emit,
  ) async {
    final result = await _toggleFavoriteUseCase(
      ToggleFavoriteParams(movie: event.movie),
    );
    
    result.fold(
      (failure) {
        Logger.error('Failed to toggle favorite: ${failure.message}');
        // TODO: Show error message to user
      },
      (isFavorite) {
        Logger.info('Movie ${event.movie.title} favorite status: $isFavorite');
        // TODO: Update UI state
      },
    );
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MoviesState> emit,
  ) async {
    // TODO: Implement search functionality
    Logger.info('Search movies: ${event.query}');
  }
} 