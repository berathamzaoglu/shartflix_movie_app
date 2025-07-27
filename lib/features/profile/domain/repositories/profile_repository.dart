import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/movie.dart';

abstract class ProfileRepository {
  Future<Either<Failure, List<Movie>>> getFavoriteMovies();
  Future<Either<Failure, bool>> removeFavorite(String movieId);
} 