import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/api_exception.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movies_repository.dart';
import '../datasources/movies_remote_datasource.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesRemoteDataSource remoteDataSource;

  MoviesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1}) async {
    try {
      final result = await remoteDataSource.getMovies(page: page);
      final movies = result.items.map((model) => model.toEntity()).toList();
      return Right(movies);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.userFriendlyMessage));
    } catch (e) {
      return Left(ServerFailure(message: 'Beklenmeyen bir hata oluştu'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavoriteMovies() async {
    try {
      final result = await remoteDataSource.getFavoriteMovies();
      final movies = result.map((model) => model.toEntity()).toList();
      return Right(movies);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.userFriendlyMessage));
    } catch (e) {
      return Left(ServerFailure(message: 'Favori filmler yüklenemedi'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(Movie movie) async {
    try {
      final result = await remoteDataSource.toggleFavorite(movie.id.toString());
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.userFriendlyMessage));
    } catch (e) {
      return Left(ServerFailure(message: 'Favori durumu güncellenemedi'));
    }
  }
} 