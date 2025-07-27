
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../../../home/data/models/movie_model.dart';

abstract class ProfileRemoteDataSource {
  Future<List<MovieModel>> getFavoriteMovies();
  Future<bool> removeFavorite(String movieId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _dioClient;

  ProfileRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<MovieModel>> getFavoriteMovies() async {
    try {
      Logger.info('Fetching favorite movies from profile');
      
      final response = await _dioClient.dio.get(ApiEndpoints.favorites);

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        
        Logger.info('API Response: $responseData');
        
        // API response formatını kontrol et
        List<dynamic> movies = [];
        
        if (responseData['data'] != null) {
          // Direkt data array'i varsa (yeni format)
          movies = responseData['data'] as List;
          Logger.info('Found movies in data: ${movies.length}');
        } else if (responseData['movies'] != null) {
          // Direkt movies array'i varsa (eski format)
          movies = responseData['movies'] as List;
          Logger.info('Found movies directly: ${movies.length}');
        } else if (responseData['response'] != null && responseData['data'] != null) {
          // Wrapper format varsa
          final data = responseData['data'] as Map<String, dynamic>;
          movies = data['movies'] as List? ?? [];
          Logger.info('Found movies in wrapper: ${movies.length}');
        } else {
          Logger.warning('No movies found in response');
        }
        
        final movieModels = movies.map((movie) {
          Logger.info('Processing movie: $movie');
          return MovieModel.fromJson(movie as Map<String, dynamic>);
        }).toList();
        
        Logger.info('Successfully fetched ${movieModels.length} favorite movies from profile');
        return movieModels;
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
  Future<bool> removeFavorite(String movieId) async {
    try {
      Logger.info('Removing movie from favorites: $movieId');
      
      final endpoint = ApiEndpoints.removeFavorite.replaceAll('{id}', movieId);
      final response = await _dioClient.dio.post(endpoint);

      if (response.statusCode == 200) {
        Logger.info('Successfully removed movie from favorites: $movieId');
        return true;
      } else {
        Logger.error('Failed to remove favorite with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      Logger.error('Error removing favorite: $e');
      return false;
    }
  }
} 