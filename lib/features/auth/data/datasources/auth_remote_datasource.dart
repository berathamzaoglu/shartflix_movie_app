import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../models/auth_response_model.dart';
import '../models/auth_result_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResultModel> login(String email, String password, bool rememberMe);
  Future<AuthResultModel> register(String name, String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<UserModel> getProfile();
  Future<void> forgotPassword(String email);
  Future<String> uploadProfilePhoto(File imageFile);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthRemoteDataSourceImpl(this._apiClient);

  Future<String?> _getStoredToken() async {
    try {
      return await _secureStorage.read(key: 'auth_token');
    } catch (e) {
      Logger.error('Failed to read stored token: $e');
      return null;
    }
  }

  @override
  Future<AuthResultModel> login(String email, String password, bool rememberMe) async {
    try {
      Logger.info('Attempting login for email: $email');
      
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
          'rememberMe': rememberMe,
        },
      );

      Logger.info('Login response received: ${response.statusCode}');
      
      final authResponse = AuthResponseModel.fromJson(response.data);
      
      if (authResponse.data == null) {
        throw ServerException(message: 'Login response data is null');
      }

      return authResponse.data!;
    } catch (e) {
      Logger.error('Login failed: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Login failed: $e');
    }
  }

  @override
  Future<AuthResultModel> register(String name, String email, String password) async {
    try {
      Logger.info('Attempting registration for email: $email');
      
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      Logger.info('Registration response received: ${response.statusCode}');
      
      final authResponse = AuthResponseModel.fromJson(response.data);
      
      if (authResponse.data == null) {
        throw ServerException(message: 'Registration response data is null');
      }

      return authResponse.data!;
    } catch (e) {
      Logger.error('Registration failed: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Registration failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      Logger.info('Attempting logout');
      
      await _apiClient.post(ApiEndpoints.logout);
      
      Logger.info('Logout successful');
    } catch (e) {
      Logger.error('Logout failed: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Logout failed: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      Logger.info('Fetching current user');
      
      final response = await _apiClient.get(ApiEndpoints.currentUser);
      
      Logger.info('Current user response received: ${response.statusCode}');
      
      if (response.data == null) {
        return null;
      }

      return UserModel.fromJson(response.data);
    } catch (e) {
      Logger.error('Get current user failed: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Get current user failed: $e');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      Logger.info('Fetching profile');
      
      final response = await _apiClient.get(ApiEndpoints.profile);
      
      Logger.info('Profile response received: ${response.statusCode}');
      
      if (response.data == null) {
        throw ServerException(message: 'Profile response data is null');
      }

      return UserModel.fromJson(response.data);
    } catch (e) {
      Logger.error('Get profile failed: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Get profile failed: $e');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      Logger.info('Attempting forgot password for email: $email');
      
      final response = await _apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {
          'email': email,
        },
      );

      Logger.info('Forgot password response received: ${response.statusCode}');
      
      if (response.data == null) {
        throw ServerException(message: 'Forgot password response data is null');
      }

      Logger.info('Forgot password successful');
    } catch (e) {
      Logger.error('Forgot password failed: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Forgot password failed: $e');
    }
  }

  @override
  Future<String> uploadProfilePhoto(File imageFile) async {
    try {
      print('📡 RemoteDataSource: Starting uploadProfilePhoto');
      Logger.info('Uploading profile photo');
      
      // Get stored token
      final token = await _getStoredToken();
      if (token == null) {
        throw ServerException(message: 'Authentication token not found');
      }
      
      print('📡 RemoteDataSource: Token found: ${token.substring(0, 20)}...');
      
      print('📡 RemoteDataSource: Creating FormData');
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'profile_photo.jpg',
        ),
      });
      
      print('📡 RemoteDataSource: Calling API endpoint: ${ApiEndpoints.uploadProfilePhoto}');
      final response = await _apiClient.post(
        ApiEndpoints.uploadProfilePhoto,
        data: formData,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('📡 RemoteDataSource: API response received: ${response.statusCode}');
      Logger.info('Upload profile photo response received: ${response.statusCode}');
      
      print('📡 RemoteDataSource: Response data: ${response.data}');
      
      // Check if response.data is null
      if (response.data == null) {
        print('❌ RemoteDataSource: Response data is null');
        throw ServerException(message: 'Upload response data is null');
      }
      
      // Try to extract photoUrl from different possible locations
      String? photoUrl;
      
      // First, try to get photoUrl from data.photoUrl
      if (response.data['photoUrl'] != null) {
        photoUrl = response.data['photoUrl'] as String;
        print('📡 RemoteDataSource: Found photoUrl in data.photoUrl: $photoUrl');
      }
      // If not found, try to get it from data.data.photoUrl (nested structure)
      else if (response.data['data'] != null && response.data['data']['photoUrl'] != null) {
        photoUrl = response.data['data']['photoUrl'] as String;
        print('📡 RemoteDataSource: Found photoUrl in data.data.photoUrl: $photoUrl');
      }
      // If still not found, check if the entire data object is the photoUrl
      else if (response.data is String) {
        photoUrl = response.data as String;
        print('📡 RemoteDataSource: Found photoUrl as direct string: $photoUrl');
      }
      
      if (photoUrl == null || photoUrl.isEmpty) {
        print('❌ RemoteDataSource: Could not find photoUrl in response');
        print('📡 RemoteDataSource: Response structure: ${response.data.runtimeType}');
        print('📡 RemoteDataSource: Response keys: ${response.data is Map ? (response.data as Map).keys.toList() : 'Not a Map'}');
        throw ServerException(message: 'Upload response does not contain photoUrl');
      }

      print('✅ RemoteDataSource: Photo URL extracted: $photoUrl');
      Logger.info('Profile photo uploaded successfully: $photoUrl');
      
      return photoUrl;
    } catch (e) {
      print('❌ RemoteDataSource: Exception occurred: $e');
      Logger.error('Upload profile photo failed: $e');
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Upload profile photo failed: $e');
    }
  }
} 