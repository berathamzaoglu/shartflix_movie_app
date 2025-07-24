import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class ToggleFavoriteUseCase implements UseCase<bool, ToggleFavoriteParams> {
  final MoviesRepository repository;

  ToggleFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ToggleFavoriteParams params) async {
    return await repository.toggleFavorite(params.movie);
  }
}

class ToggleFavoriteParams {
  final Movie movie;

  const ToggleFavoriteParams({required this.movie});
} 