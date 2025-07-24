import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/movie_model.dart';
import '../models/movies_response_model.dart';

abstract class MoviesRemoteDataSource {
  Future<MoviesResponseModel> getMovies({int page = 1});
  Future<List<MovieModel>> getFavoriteMovies();
  Future<bool> toggleFavorite(String movieId);
}

class MoviesRemoteDataSourceImpl implements MoviesRemoteDataSource {
  final DioClient _dioClient;

  MoviesRemoteDataSourceImpl(this._dioClient);

  @override
  Future<MoviesResponseModel> getMovies({int page = 1}) async {
    try {
      Logger.info('Fetching movies for page: $page');
      
      final response = await _dioClient.dio.get(
        '/movie/list',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        
        if (responseData['response'] != null && responseData['data'] != null) {
          final data = responseData['data'] as Map<String, dynamic>;
          
          final moviesResponse = MoviesResponseModel.fromJson(data);
          
          Logger.info('Successfully fetched ${moviesResponse.movies.length} movies for page $page');
          return moviesResponse;
        } else {
          Logger.warning('Invalid response structure for movies');
          throw Exception('Invalid response structure');
        }
      } else {
        Logger.error('Failed to fetch movies with status: ${response.statusCode}');
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      Logger.error('Error fetching movies: $e');
      throw Exception('Error fetching movies: $e');
    }
  }

  @override
  Future<List<MovieModel>> getFavoriteMovies() async {
    try {
      Logger.info('Fetching favorite movies');
      
      final response = await _dioClient.dio.get('/movie/favorites');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        
        if (responseData['response'] != null && responseData['data'] != null) {
          final data = responseData['data'] as Map<String, dynamic>;
          final movies = data['movies'] as List? ?? [];
          
          final movieModels = movies.map((movie) => 
            MovieModel.fromJson(movie as Map<String, dynamic>)
          ).toList();
          
          Logger.info('Successfully fetched ${movieModels.length} favorite movies');
          return movieModels;
        } else {
          Logger.warning('Invalid response structure for favorite movies');
          return [];
        }
      } else {
        Logger.error('Failed to fetch favorite movies with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      Logger.error('Error fetching favorite movies: $e');
      return [];
    }
  }

  @override
  Future<bool> toggleFavorite(String movieId) async {
    try {
      Logger.info('Toggling favorite for movie: $movieId');
      
      final response = await _dioClient.dio.post('/movie/favorite/$movieId');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        final success = responseData['success'] ?? false;
        
        Logger.info('Successfully toggled favorite for movie: $movieId');
        return success;
      } else {
        Logger.error('Failed to toggle favorite with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      Logger.error('Error toggling favorite for movie $movieId: $e');
      return false;
    }
  }
} 