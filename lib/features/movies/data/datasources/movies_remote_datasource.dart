import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/movie_model.dart';

abstract class MoviesRemoteDataSource {
  Future<PaginatedResponse<MovieModel>> getMovies({int page = 1});
  Future<List<MovieModel>> getFavoriteMovies();
  Future<bool> toggleFavorite(String movieId);
}

class MoviesRemoteDataSourceImpl extends ApiClient implements MoviesRemoteDataSource {
  MoviesRemoteDataSourceImpl(Dio dio) : super(dio);

  @override
  Future<PaginatedResponse<MovieModel>> getMovies({int page = 1}) async {
    final response = await get<PaginatedResponse<MovieModel>>(
      '/movie/list',
      queryParameters: {'page': page},
      parser: (data) => PaginatedResponse.fromJson(
        data as Map<String, dynamic>,
        MovieModel.fromJson,
      ),
    );

    return response.data!;
  }

  @override
  Future<List<MovieModel>> getFavoriteMovies() async {
    final response = await get<List<MovieModel>>(
      '/movie/favorites',
      parser: (data) {
        final moviesData = data['movies'] as List? ?? [];
        return moviesData
            .map((movie) => MovieModel.fromJson(movie as Map<String, dynamic>))
            .toList();
      },
    );

    return response.data ?? [];
  }

  @override
  Future<bool> toggleFavorite(String movieId) async {
    try {
      final response = await post<Map<String, dynamic>>(
        '/movie/favorite/$movieId',
        parser: (data) => data as Map<String, dynamic>,
      );

      return response.data?['success'] ?? false;
    } catch (e) {
      // If movie is already favorited, the API might return an error
      // In that case, we should try to unfavorite it
      throw e;
    }
  }
} 