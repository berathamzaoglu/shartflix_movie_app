import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/movies_repository.dart';
import '../../data/models/movies_response_model.dart';

class GetPopularMoviesUseCase implements UseCase<MoviesResponseModel, GetPopularMoviesParams> {
  final MoviesRepository repository;

  GetPopularMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, MoviesResponseModel>> call(GetPopularMoviesParams params) async {
    return await repository.getPopularMovies(page: params.page);
  }
}

class GetPopularMoviesParams {
  final int page;

  const GetPopularMoviesParams({this.page = 1});
} 