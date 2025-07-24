import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../error/exceptions.dart';
import '../utils/logger.dart';
import 'api_endpoints.dart';

class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  static const String _tokenKey = 'auth_token';

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    // Clear existing interceptors
    _dio.interceptors.clear();

    // Add pretty logger in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    // Add auth interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests
          final token = await _getStoredToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized
          if (error.response?.statusCode == 401) {
            await _clearStoredToken();
            Logger.warning('Token expired, cleared stored token');
          }
          
          final exception = _handleDioError(error);
          handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: exception,
            response: error.response,
            type: error.type,
          ));
        },
      ),
    );
  }

  Future<String?> _getStoredToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      Logger.error('Failed to read stored token: $e');
      return null;
    }
  }

  Future<void> _clearStoredToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
    } catch (e) {
      Logger.error('Failed to clear stored token: $e');
    }
  }

  Future<void> setToken(String token) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
      Logger.info('Token stored successfully');
    } catch (e) {
      Logger.error('Failed to store token: $e');
    }
  }

  Future<void> clearToken() async {
    await _clearStoredToken();
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Bağlantı zaman aşımına uğradı',
        );
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _getErrorMessageFromResponse(error.response);
        
        if (statusCode == 401) {
          return AuthException(
            message: message ?? 'Oturum süreniz dolmuş',
            statusCode: statusCode,
          );
        } else if (statusCode == 400) {
          return ServerException(
            message: message ?? 'Geçersiz istek',
            statusCode: statusCode,
          );
        } else {
          return ServerException(
            message: message ?? 'Sunucu hatası: $statusCode',
            statusCode: statusCode,
          );
        }
      
      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'İstek iptal edildi',
        );
      
      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'İnternet bağlantısı bulunamadı',
        );
      
      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'Güvenlik sertifikası hatası',
        );
      
      case DioExceptionType.unknown:
      default:
        return NetworkException(
          message: error.message ?? 'Bilinmeyen hata oluştu',
        );
    }
  }

  String? _getErrorMessageFromResponse(Response? response) {
    try {
      if (response?.data is Map<String, dynamic>) {
        final data = response!.data as Map<String, dynamic>;
        // Try common error message fields
        return data['message'] ?? 
               data['error'] ?? 
               data['detail'] ?? 
               data['msg'];
      }
    } catch (e) {
      Logger.warning('Failed to parse error response: $e');
    }
    return null;
  }
} 