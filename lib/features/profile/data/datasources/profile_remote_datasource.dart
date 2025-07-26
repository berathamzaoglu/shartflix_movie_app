import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../../../home/data/models/movie_model.dart';

abstract class ProfileRemoteDataSource {
  Future<List<MovieModel>> getFavoriteMovies();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _dioClient;

  ProfileRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<MovieModel>> getFavoriteMovies() async {
    try {
      Logger.info('Fetching favorite movies from profile');
      
      final response = await _dioClient.dio.get('/movie/favorites');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        
        if (responseData['response'] != null && responseData['data'] != null) {
          final data = responseData['data'] as Map<String, dynamic>;
          final movies = data['movies'] as List? ?? [];
          
          final movieModels = movies.map((movie) => 
            MovieModel.fromJson(movie as Map<String, dynamic>)
          ).toList();
          
          Logger.info('Successfully fetched ${movieModels.length} favorite movies from profile');
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
} 