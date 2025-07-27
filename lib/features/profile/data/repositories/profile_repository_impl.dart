import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../../../home/domain/entities/movie.dart';
import '../../../home/data/models/movie_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

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
  Future<Either<Failure, bool>> removeFavorite(String movieId) async {
    try {
      final result = await remoteDataSource.removeFavorite(movieId);
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
      return Left(Failure.server(message: 'Favori çıkarılamadı: $e'));
    }
  }
} 