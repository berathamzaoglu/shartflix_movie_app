class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });
}

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException({
    required this.message,
    this.statusCode,
  });
}

class CacheException implements Exception {
  final String message;

  const CacheException({
    required this.message,
  });
}

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException({
    required this.message,
    this.statusCode,
  });
} 