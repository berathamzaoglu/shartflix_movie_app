import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final dynamic originalError;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.originalError,
  });

  factory ApiException.fromDioError(DioException dioError) {
    final response = dioError.response;
    final data = response?.data;

    return ApiException(
      message: data?['message'] ?? dioError.message ?? 'Network error',
      statusCode: response?.statusCode,
      errorCode: data?['error_code'],
      originalError: dioError,
    );
  }

  String get userFriendlyMessage {
    switch (statusCode) {
      case 401:
        return 'Oturum süreniz dolmuş, tekrar giriş yapın';
      case 403:
        return 'Bu işlem için yetkiniz bulunmuyor';
      case 404:
        return 'İstenen kaynak bulunamadı';
      case 429:
        return 'Çok fazla istek gönderdiniz, lütfen bekleyin';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Sunucu hatası, lütfen daha sonra tekrar deneyin';
      default:
        return message;
    }
  }

  @override
  String toString() {
    return 'ApiException{message: $message, statusCode: $statusCode, errorCode: $errorCode}';
  }
} 