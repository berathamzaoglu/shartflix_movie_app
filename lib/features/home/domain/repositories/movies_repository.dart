import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../../data/models/movies_response_model.dart';

abstract class MoviesRepository {
  Future<Either<Failure, MoviesResponseModel>> getPopularMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> getFavoriteMovies();
  Future<Either<Failure, Map<String, dynamic>>> toggleFavorite(Movie movie);
} 