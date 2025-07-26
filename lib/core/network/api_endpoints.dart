class ApiEndpoints {
  static const String baseUrl = 'https://caseapi.servicelabs.tech'; // API URL'ini buraya güncelleyin
  
  // Authentication endpoints
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String logout = '/user/logout';
  static const String profile = '/user/profile';
  static const String currentUser = '/user/current';
  static const String uploadProfilePhoto = '/user/upload_photo';
  static const String forgotPassword = '/user/forgot-password';
  
  // Movie endpoints (for future use)
  static const String movies = '/movies';
  static const String popularMovies = '/movies/popular';
  static const String topRatedMovies = '/movies/top-rated';
  static const String nowPlayingMovies = '/movies/now-playing';
  static const String upcomingMovies = '/movies/upcoming';
  static const String searchMovies = '/movies/search';
  static const String movieDetails = '/movies/{id}';
  static const String genres = '/genres';
  
  // User endpoints
  static const String favorites = '/user/favorites';
  static const String toggleFavorite = '/user/favorites/{id}';
} 