import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../home/domain/entities/movie.dart';
import '../repositories/profile_repository.dart';

class GetFavoriteMoviesUseCase implements UseCase<List<Movie>, NoParams> {
  final ProfileRepository repository;

  GetFavoriteMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) async {
    return await repository.getFavoriteMovies();
  }
} 