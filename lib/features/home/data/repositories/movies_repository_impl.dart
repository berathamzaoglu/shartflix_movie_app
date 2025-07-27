import 'package:dartz/dartz.dart';
import 'package:shartflix_movie_app/features/home/home_feature.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDataSource remoteDataSource;

  MoviesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, MoviesResponseModel>> getPopularMovies({int page = 1}) async {
    try {
      final result = await remoteDataSource.getMovies(page: page);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(Failure.network(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(Failure.server(message: 'Beklenmeyen bir hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavoriteMovies() async {
    try {
      final result = await remoteDataSource.getFavoriteMovies();
      final movies = result.map((model) => model.toEntity()).toList();
      return Right(movies);
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(Failure.network(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(Failure.server(message: 'Favori filmler yüklenemedi: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> toggleFavorite(Movie movie) async {
    try {
      final result = await remoteDataSource.toggleFavorite(movie.id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(Failure.network(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(Failure.server(message: 'Favori durumu güncellenemedi: $e'));
    }
  }
} 