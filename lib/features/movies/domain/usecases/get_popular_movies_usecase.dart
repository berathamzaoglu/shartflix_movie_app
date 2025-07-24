import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movies_repository.dart';

class GetPopularMoviesUseCase implements UseCase<List<Movie>, GetPopularMoviesParams> {
  final MoviesRepository repository;

  GetPopularMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GetPopularMoviesParams params) async {
    return await repository.getPopularMovies(page: params.page);
  }
}

class GetPopularMoviesParams {
  final int page;

  const GetPopularMoviesParams({this.page = 1});
} 