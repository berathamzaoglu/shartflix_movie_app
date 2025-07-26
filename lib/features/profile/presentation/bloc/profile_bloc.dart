import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix_movie_app/core/usecases/usecase.dart';

import '../../../../core/utils/logger.dart';
import '../../../home/domain/entities/movie.dart';
import '../../domain/usecases/get_favorite_movies_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetFavoriteMoviesUseCase _getFavoriteMoviesUseCase;

  ProfileBloc(this._getFavoriteMoviesUseCase) : super(const ProfileState.initial()) {
    on<LoadFavoriteMovies>(_onLoadFavoriteMovies);
  }

  Future<void> _onLoadFavoriteMovies(
    LoadFavoriteMovies event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileState.loading());
    
    final result = await _getFavoriteMoviesUseCase(const NoParams());
    
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
} 