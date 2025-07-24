import 'package:dio/dio.dart';

import '../../core/error/api_exception.dart';
import 'api_response.dart';

abstract class ApiClient {
  final Dio dio;
  
  ApiClient(this.dio);
  
  // Common headers for all requests
  Map<String, dynamic> get commonHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // GET request wrapper
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: {...commonHeaders, ...?headers},
        ),
      );
      
      return _handleResponse<T>(response, parser);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST request wrapper
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: {...commonHeaders, ...?headers},
        ),
      );
      
      return _handleResponse<T>(response, parser);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request wrapper
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: {...commonHeaders, ...?headers},
        ),
      );
      
      return _handleResponse<T>(response, parser);
    } catch (e) {
      throw _handleError(e);
    }
  }

  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? parser,
  ) {
    final data = response.data;
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiResponse<T>(
        success: true,
        data: parser != null ? parser(data) : data,
        statusCode: response.statusCode,
      );
    } else {
      throw ApiException(
        message: data['message'] ?? 'Request failed',
        statusCode: response.statusCode,
      );
    }
  }

  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      return ApiException.fromDioError(error);
    }
    return ApiException(message: error.toString());
  }
} 