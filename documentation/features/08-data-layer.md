# Data Layer Architecture

## Overview

The data layer implements the Repository pattern to provide a clean abstraction between the business logic (BLoCs) and data sources (API, local storage, cache). This architecture ensures separation of concerns, testability, and flexible data management throughout the ShartFlix application.

## Repository Pattern Implementation

### Base Repository
```dart
// base_repository.dart
abstract class BaseRepository {
  final ApiClient apiClient;
  final CacheManager cacheManager;
  final LocalStorageService localStorageService;

  BaseRepository({
    required this.apiClient,
    required this.cacheManager,
    required this.localStorageService,
  });

  /// Generic method to handle API calls with caching
  Future<T> executeWithCache<T>({
    required String cacheKey,
    required Future<T> Function() apiCall,
    required T Function(Map<String, dynamic>) fromJson,
    Duration cacheDuration = const Duration(minutes: 5),
    bool forceRefresh = false,
  }) async {
    // Check cache first if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await cacheManager.get<T>(cacheKey);
      if (cachedData != null) {
        return cachedData;
      }
    }

    try {
      // Make API call
      final result = await apiCall();
      
      // Cache the result
      await cacheManager.set(cacheKey, result, duration: cacheDuration);
      
      return result;
    } catch (e) {
      // Try to return cached data if API fails
      final cachedData = await cacheManager.get<T>(cacheKey);
      if (cachedData != null) {
        LoggerService.warning('API failed, returning cached data for $cacheKey');
        return cachedData;
      }
      
      rethrow;
    }
  }

  /// Generic method for paginated data
  Future<PaginatedResponse<T>> executePaginatedWithCache<T>({
    required String cacheKeyPrefix,
    required Future<PaginatedResponse<T>> Function() apiCall,
    required T Function(Map<String, dynamic>) itemFromJson,
    required int page,
    Duration cacheDuration = const Duration(minutes: 5),
    bool forceRefresh = false,
  }) async {
    final cacheKey = '${cacheKeyPrefix}_page_$page';
    
    return executeWithCache<PaginatedResponse<T>>(
      cacheKey: cacheKey,
      apiCall: apiCall,
      fromJson: (json) => PaginatedResponse.fromJson(json, itemFromJson),
      cacheDuration: cacheDuration,
      forceRefresh: forceRefresh,
    );
  }
}
```

### Authentication Repository
```dart
// auth_repository.dart
class AuthRepository extends BaseRepository {
  AuthRepository({
    required super.apiClient,
    required super.cacheManager,
    required super.localStorageService,
  });

  Future<AuthResult> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
        'remember_me': rememberMe,
      },
    );

    final authResult = AuthResult.fromJson(response.data!);
    
    // Store user data locally
    await _storeUserData(authResult.user);
    
    return authResult;
  }

  Future<AuthResult> register({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );

    return AuthResult.fromJson(response.data!);
  }

  Future<AuthResult> refreshToken(String refreshToken) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    return AuthResult.fromJson(response.data!);
  }

  Future<User> getCurrentUser() async {
    // Try to get from cache first
    final cachedUser = await localStorageService.get<User>(
      'current_user',
      (json) => User.fromJson(json),
    );

    if (cachedUser != null) {
      return cachedUser;
    }

    // Fetch from API
    final response = await apiClient.get<Map<String, dynamic>>(
      '/auth/me',
    );

    final user = User.fromJson(response.data!);
    await _storeUserData(user);
    
    return user;
  }

  Future<void> logout() async {
    try {
      await apiClient.post('/auth/logout');
    } finally {
      // Clear local data regardless of API response
      await _clearUserData();
    }
  }

  Future<void> _storeUserData(User user) async {
    await localStorageService.set('current_user', user.toJson());
  }

  Future<void> _clearUserData() async {
    await localStorageService.remove('current_user');
    await cacheManager.clear();
  }
}

// Data Models
class AuthResult {
  final User user;
  final String token;
  final String refreshToken;
  final bool requiresVerification;

  const AuthResult({
    required this.user,
    required this.token,
    required this.refreshToken,
    this.requiresVerification = false,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      user: User.fromJson(json['user']),
      token: json['token'],
      refreshToken: json['refresh_token'],
      requiresVerification: json['requires_verification'] ?? false,
    );
  }
}
```

### Movie Repository
```dart
// movie_repository.dart
class MovieRepository extends BaseRepository {
  MovieRepository({
    required super.apiClient,
    required super.cacheManager,
    required super.localStorageService,
  });

  Future<PaginatedResponse<Movie>> getMovies({
    int page = 1,
    int limit = 5,
    String? genre,
    String? search,
    String? sortBy,
    bool forceRefresh = false,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (genre != null) 'genre': genre,
      if (search != null) 'search': search,
      if (sortBy != null) 'sort_by': sortBy,
    };

    final cacheKey = 'movies_${queryParams.entries.map((e) => '${e.key}:${e.value}').join('_')}';

    return executeWithCache<PaginatedResponse<Movie>>(
      cacheKey: cacheKey,
      apiCall: () async {
        final response = await apiClient.get<Map<String, dynamic>>(
          '/movies',
          queryParameters: queryParams,
        );
        return PaginatedResponse.fromJson(response.data!, Movie.fromJson);
      },
      fromJson: (json) => PaginatedResponse.fromJson(json, Movie.fromJson),
      cacheDuration: const Duration(minutes: 10),
      forceRefresh: forceRefresh,
    );
  }

  Future<Movie> getMovieDetails(String movieId) async {
    return executeWithCache<Movie>(
      cacheKey: 'movie_details_$movieId',
      apiCall: () async {
        final response = await apiClient.get<Map<String, dynamic>>(
          '/movies/$movieId',
        );
        return Movie.fromJson(response.data!);
      },
      fromJson: Movie.fromJson,
      cacheDuration: const Duration(hours: 1),
    );
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final response = await apiClient.get<Map<String, dynamic>>(
      '/movies/search',
      queryParameters: {'q': query},
    );

    final data = response.data!;
    return (data['movies'] as List)
        .map((json) => Movie.fromJson(json))
        .toList();
  }

  Future<List<String>> getGenres() async {
    return executeWithCache<List<String>>(
      cacheKey: 'movie_genres',
      apiCall: () async {
        final response = await apiClient.get<Map<String, dynamic>>(
          '/movies/genres',
        );
        return List<String>.from(response.data!['genres']);
      },
      fromJson: (json) => List<String>.from(json['genres']),
      cacheDuration: const Duration(hours: 24),
    );
  }

  /// Get trending movies with smart caching
  Future<List<Movie>> getTrendingMovies() async {
    return executeWithCache<List<Movie>>(
      cacheKey: 'trending_movies',
      apiCall: () async {
        final response = await apiClient.get<Map<String, dynamic>>(
          '/movies/trending',
        );
        return (response.data!['movies'] as List)
            .map((json) => Movie.fromJson(json))
            .toList();
      },
      fromJson: (json) => (json['movies'] as List)
          .map((item) => Movie.fromJson(item))
          .toList(),
      cacheDuration: const Duration(hours: 2),
    );
  }

  /// Preload movie data for better UX
  Future<void> preloadMovieDetails(List<String> movieIds) async {
    final futures = movieIds.map((id) async {
      try {
        await getMovieDetails(id);
      } catch (e) {
        LoggerService.warning('Failed to preload movie $id: $e');
      }
    });

    await Future.wait(futures);
  }
}
```

### User Repository
```dart
// user_repository.dart
class UserRepository extends BaseRepository {
  UserRepository({
    required super.apiClient,
    required super.cacheManager,
    required super.localStorageService,
  });

  Future<UserProfile> getProfile({bool forceRefresh = false}) async {
    return executeWithCache<UserProfile>(
      cacheKey: 'user_profile',
      apiCall: () async {
        final response = await apiClient.get<Map<String, dynamic>>(
          '/user/profile',
        );
        return UserProfile.fromJson(response.data!);
      },
      fromJson: UserProfile.fromJson,
      cacheDuration: const Duration(minutes: 30),
      forceRefresh: forceRefresh,
    );
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> updates) async {
    final response = await apiClient.put<Map<String, dynamic>>(
      '/user/profile',
      data: updates,
    );

    final updatedProfile = UserProfile.fromJson(response.data!);
    
    // Update cache
    await cacheManager.set(
      'user_profile',
      updatedProfile,
      duration: const Duration(minutes: 30),
    );

    return updatedProfile;
  }

  Future<String> uploadProfilePhoto(File imageFile) async {
    // Compress image before upload
    final compressedFile = await _compressImage(imageFile);
    
    final fileName = path.basename(compressedFile.path);
    final formData = FormData.fromMap({
      'profile_photo': await MultipartFile.fromFile(
        compressedFile.path,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      ),
    });

    final response = await apiClient.post<Map<String, dynamic>>(
      '/user/profile/photo',
      data: formData,
      headers: {'Content-Type': 'multipart/form-data'},
    );

    final photoUrl = response.data!['photo_url'] as String;
    
    // Update cached profile with new photo URL
    final cachedProfile = await cacheManager.get<UserProfile>('user_profile');
    if (cachedProfile != null) {
      final updatedProfile = cachedProfile.copyWith(profilePhotoUrl: photoUrl);
      await cacheManager.set(
        'user_profile',
        updatedProfile,
        duration: const Duration(minutes: 30),
      );
    }

    return photoUrl;
  }

  Future<void> deleteProfilePhoto() async {
    await apiClient.delete('/user/profile/photo');
    
    // Update cached profile
    final cachedProfile = await cacheManager.get<UserProfile>('user_profile');
    if (cachedProfile != null) {
      final updatedProfile = cachedProfile.copyWith(profilePhotoUrl: null);
      await cacheManager.set(
        'user_profile',
        updatedProfile,
        duration: const Duration(minutes: 30),
      );
    }
  }

  Future<File> _compressImage(File imageFile) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '${(await getTemporaryDirectory()).path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      quality: 80,
      minWidth: 400,
      minHeight: 400,
      format: CompressFormat.jpeg,
    );
    
    return result ?? imageFile;
  }
}
```

### Favorite Repository
```dart
// favorite_repository.dart
class FavoriteRepository extends BaseRepository {
  FavoriteRepository({
    required super.apiClient,
    required super.cacheManager,
    required super.localStorageService,
  });

  Future<PaginatedResponse<Movie>> getFavoriteMovies({
    int page = 1,
    int limit = 20,
    bool forceRefresh = false,
  }) async {
    return executePaginatedWithCache<Movie>(
      cacheKeyPrefix: 'favorite_movies',
      apiCall: () async {
        final response = await apiClient.get<Map<String, dynamic>>(
          '/user/favorites',
          queryParameters: {
            'page': page,
            'limit': limit,
          },
        );
        return PaginatedResponse.fromJson(
          response.data!,
          (json) => Movie.fromJson(json['movie']),
        );
      },
      itemFromJson: (json) => Movie.fromJson(json['movie']),
      page: page,
      cacheDuration: const Duration(minutes: 5),
      forceRefresh: forceRefresh,
    );
  }

  Future<bool> toggleFavorite(String movieId, bool isFavorite) async {
    try {
      if (isFavorite) {
        final response = await apiClient.post<Map<String, dynamic>>(
          '/movies/$movieId/favorite',
          data: {'is_favorite': true},
        );
        
        final isNowFavorite = response.data!['is_favorite'] as bool;
        await _updateFavoriteCache(movieId, isNowFavorite);
        return isNowFavorite;
      } else {
        await apiClient.delete('/movies/$movieId/favorite');
        await _updateFavoriteCache(movieId, false);
        return false;
      }
    } catch (e) {
      LoggerService.error('Failed to toggle favorite for movie $movieId: $e');
      rethrow;
    }
  }

  Future<bool> isFavorite(String movieId) async {
    // Check cache first
    final cachedFavorites = await _getCachedFavoriteIds();
    if (cachedFavorites.isNotEmpty) {
      return cachedFavorites.contains(movieId);
    }

    // Fetch from API
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        '/movies/$movieId/favorite',
      );
      return response.data!['is_favorite'] as bool;
    } catch (e) {
      LoggerService.warning('Failed to check favorite status for $movieId: $e');
      return false;
    }
  }

  Future<List<String>> getFavoriteMovieIds() async {
    return executeWithCache<List<String>>(
      cacheKey: 'favorite_movie_ids',
      apiCall: () async {
        final response = await apiClient.get<Map<String, dynamic>>(
          '/user/favorites/ids',
        );
        return List<String>.from(response.data!['movie_ids']);
      },
      fromJson: (json) => List<String>.from(json['movie_ids']),
      cacheDuration: const Duration(minutes: 10),
    );
  }

  Future<void> _updateFavoriteCache(String movieId, bool isFavorite) async {
    // Update favorite movie IDs cache
    final cachedIds = await _getCachedFavoriteIds();
    if (isFavorite) {
      if (!cachedIds.contains(movieId)) {
        cachedIds.add(movieId);
      }
    } else {
      cachedIds.remove(movieId);
    }
    
    await cacheManager.set(
      'favorite_movie_ids',
      cachedIds,
      duration: const Duration(minutes: 10),
    );

    // Invalidate paginated favorite movies cache
    await _invalidateFavoriteMoviesCache();
  }

  Future<List<String>> _getCachedFavoriteIds() async {
    final cached = await cacheManager.get<List<String>>('favorite_movie_ids');
    return cached ?? [];
  }

  Future<void> _invalidateFavoriteMoviesCache() async {
    final keys = await cacheManager.getKeys();
    final favoriteMovieKeys = keys.where(
      (key) => key.startsWith('favorite_movies_page_'),
    );
    
    for (final key in favoriteMovieKeys) {
      await cacheManager.remove(key);
    }
  }
}
```

## Cache Management

### Cache Manager Implementation
```dart
// cache_manager.dart
class CacheManager {
  final Box _box;
  
  CacheManager._(this._box);
  
  static CacheManager? _instance;
  
  static Future<CacheManager> getInstance() async {
    if (_instance == null) {
      final box = await Hive.openBox('app_cache');
      _instance = CacheManager._(box);
    }
    return _instance!;
  }

  Future<T?> get<T>(String key) async {
    try {
      final cached = _box.get(key);
      if (cached == null) return null;
      
      final cacheEntry = CacheEntry.fromJson(cached);
      
      if (cacheEntry.isExpired) {
        await remove(key);
        return null;
      }
      
      if (T == String) {
        return cacheEntry.data as T;
      } else if (T == int) {
        return cacheEntry.data as T;
      } else if (T == bool) {
        return cacheEntry.data as T;
      } else if (T == List<String>) {
        return List<String>.from(cacheEntry.data) as T;
      } else {
        // For complex objects, assume they have fromJson constructor
        return _deserializeObject<T>(cacheEntry.data);
      }
    } catch (e) {
      LoggerService.error('Failed to get cache for key $key: $e');
      await remove(key);
      return null;
    }
  }

  Future<void> set<T>(
    String key,
    T data, {
    Duration duration = const Duration(minutes: 5),
  }) async {
    try {
      final entry = CacheEntry(
        data: _serializeObject(data),
        expiresAt: DateTime.now().add(duration),
      );
      
      await _box.put(key, entry.toJson());
    } catch (e) {
      LoggerService.error('Failed to set cache for key $key: $e');
    }
  }

  Future<void> remove(String key) async {
    try {
      await _box.delete(key);
    } catch (e) {
      LoggerService.error('Failed to remove cache for key $key: $e');
    }
  }

  Future<void> clear() async {
    try {
      await _box.clear();
    } catch (e) {
      LoggerService.error('Failed to clear cache: $e');
    }
  }

  Future<List<String>> getKeys() async {
    return _box.keys.cast<String>().toList();
  }

  Future<void> removeExpired() async {
    final keys = await getKeys();
    for (final key in keys) {
      final cached = _box.get(key);
      if (cached != null) {
        try {
          final entry = CacheEntry.fromJson(cached);
          if (entry.isExpired) {
            await remove(key);
          }
        } catch (e) {
          // Remove corrupted entries
          await remove(key);
        }
      }
    }
  }

  dynamic _serializeObject<T>(T object) {
    if (object is String || 
        object is int || 
        object is bool || 
        object is double ||
        object is List ||
        object is Map) {
      return object;
    }
    
    // For custom objects, call toJson if available
    if (object is Object && object.runtimeType.toString().contains('toJson')) {
      return (object as dynamic).toJson();
    }
    
    return object.toString();
  }

  T? _deserializeObject<T>(dynamic data) {
    if (T == String || T == int || T == bool || T == double) {
      return data as T?;
    }
    
    if (data is Map<String, dynamic>) {
      // Use reflection or manual mapping based on type
      switch (T.toString()) {
        case 'Movie':
          return Movie.fromJson(data) as T;
        case 'UserProfile':
          return UserProfile.fromJson(data) as T;
        case 'PaginatedResponse<Movie>':
          return PaginatedResponse.fromJson(data, Movie.fromJson) as T;
        // Add other types as needed
        default:
          LoggerService.warning('Unknown type for deserialization: $T');
          return null;
      }
    }
    
    return null;
  }
}

class CacheEntry {
  final dynamic data;
  final DateTime expiresAt;

  CacheEntry({
    required this.data,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  factory CacheEntry.fromJson(Map<String, dynamic> json) {
    return CacheEntry(
      data: json['data'],
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}
```

## Local Storage Service

### Local Storage Implementation
```dart
// local_storage_service.dart
class LocalStorageService {
  final SharedPreferences _prefs;
  
  LocalStorageService._(this._prefs);
  
  static LocalStorageService? _instance;
  
  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = LocalStorageService._(prefs);
    }
    return _instance!;
  }

  Future<T?> get<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;
      
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(json);
    } catch (e) {
      LoggerService.error('Failed to get from local storage for key $key: $e');
      await remove(key);
      return null;
    }
  }

  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  Future<List<String>?> getStringList(String key) async {
    return _prefs.getStringList(key);
  }

  Future<void> set<T>(String key, T value) async {
    try {
      if (value is String) {
        await _prefs.setString(key, value);
      } else if (value is int) {
        await _prefs.setInt(key, value);
      } else if (value is bool) {
        await _prefs.setBool(key, value);
      } else if (value is List<String>) {
        await _prefs.setStringList(key, value);
      } else {
        // Serialize object to JSON
        final jsonString = jsonEncode((value as dynamic).toJson());
        await _prefs.setString(key, jsonString);
      }
    } catch (e) {
      LoggerService.error('Failed to set local storage for key $key: $e');
    }
  }

  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      LoggerService.error('Failed to remove from local storage for key $key: $e');
    }
  }

  Future<void> clear() async {
    try {
      await _prefs.clear();
    } catch (e) {
      LoggerService.error('Failed to clear local storage: $e');
    }
  }

  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}
```

## Data Synchronization

### Sync Manager
```dart
// sync_manager.dart
class SyncManager {
  final List<BaseRepository> _repositories;
  final NetworkStatusService _networkService;
  
  SyncManager({
    required List<BaseRepository> repositories,
    required NetworkStatusService networkService,
  }) : _repositories = repositories,
       _networkService = networkService;

  Future<void> syncOnConnectivity() async {
    _networkService.onStatusChanged.listen((isConnected) {
      if (isConnected) {
        _performSync();
      }
    });
  }

  Future<void> _performSync() async {
    try {
      // Sync critical data first
      await _syncCriticalData();
      
      // Then sync less critical data
      await _syncNonCriticalData();
      
    } catch (e) {
      LoggerService.error('Sync failed: $e');
    }
  }

  Future<void> _syncCriticalData() async {
    final futures = <Future>[];
    
    // Sync user profile
    futures.add(_syncUserProfile());
    
    // Sync favorite movies
    futures.add(_syncFavoriteMovies());
    
    await Future.wait(futures);
  }

  Future<void> _syncNonCriticalData() async {
    // Sync movie cache
    await _syncMovieCache();
  }

  Future<void> _syncUserProfile() async {
    try {
      final userRepo = _repositories.whereType<UserRepository>().first;
      await userRepo.getProfile(forceRefresh: true);
    } catch (e) {
      LoggerService.warning('Failed to sync user profile: $e');
    }
  }

  Future<void> _syncFavoriteMovies() async {
    try {
      final favoriteRepo = _repositories.whereType<FavoriteRepository>().first;
      await favoriteRepo.getFavoriteMovies(forceRefresh: true);
    } catch (e) {
      LoggerService.warning('Failed to sync favorite movies: $e');
    }
  }

  Future<void> _syncMovieCache() async {
    try {
      final movieRepo = _repositories.whereType<MovieRepository>().first;
      await movieRepo.getMovies(forceRefresh: true);
    } catch (e) {
      LoggerService.warning('Failed to sync movie cache: $e');
    }
  }
}
```

## Testing Data Layer

### Repository Testing
```dart
// test/repositories/movie_repository_test.dart
group('MovieRepository Tests', () {
  late MovieRepository movieRepository;
  late MockApiClient mockApiClient;
  late MockCacheManager mockCacheManager;
  late MockLocalStorageService mockLocalStorage;

  setUp(() {
    mockApiClient = MockApiClient();
    mockCacheManager = MockCacheManager();
    mockLocalStorage = MockLocalStorageService();
    
    movieRepository = MovieRepository(
      apiClient: mockApiClient,
      cacheManager: mockCacheManager,
      localStorageService: mockLocalStorage,
    );
  });

  group('getMovies', () {
    test('should return cached data when available and not expired', () async {
      // Arrange
      final cachedResponse = PaginatedResponse<Movie>(
        items: [testMovie],
        currentPage: 1,
        totalPages: 1,
        totalItems: 1,
        hasNext: false,
        hasPrevious: false,
      );
      
      when(() => mockCacheManager.get<PaginatedResponse<Movie>>(any()))
          .thenAnswer((_) async => cachedResponse);

      // Act
      final result = await movieRepository.getMovies();

      // Assert
      expect(result, equals(cachedResponse));
      verifyNever(() => mockApiClient.get(any()));
    });

    test('should fetch from API when cache is empty', () async {
      // Arrange
      when(() => mockCacheManager.get<PaginatedResponse<Movie>>(any()))
          .thenAnswer((_) async => null);
      
      when(() => mockApiClient.get<Map<String, dynamic>>(any()))
          .thenAnswer((_) async => ApiResponse.success(testMovieApiResponse));
      
      when(() => mockCacheManager.set(any(), any(), duration: any(named: 'duration')))
          .thenAnswer((_) async {});

      // Act
      final result = await movieRepository.getMovies();

      // Assert
      expect(result.items.length, equals(1));
      verify(() => mockApiClient.get('/movies')).called(1);
      verify(() => mockCacheManager.set(any(), any(), duration: any(named: 'duration'))).called(1);
    });
  });
});
```

This comprehensive data layer documentation provides a robust foundation for implementing the repository pattern with caching, local storage, and synchronization capabilities throughout the ShartFlix application. 