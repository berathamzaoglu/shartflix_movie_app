import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();
  
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
  
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  
  static const String _userKey = 'cached_user';
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  AuthLocalDataSourceImpl(this._secureStorage);
  
  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _secureStorage.write(key: _userKey, value: userJson);
      Logger.info('User cached successfully: ${user.email}');
    } catch (e) {
      Logger.error('Failed to cache user: $e');
      throw CacheException(message: 'Failed to cache user: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = await _secureStorage.read(key: _userKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user = UserModel.fromJson(userMap);
        Logger.info('Retrieved cached user: ${user.email}');
        return user;
      }
      Logger.info('No cached user found');
      return null;
    } catch (e) {
      Logger.error('Failed to get cached user: $e');
      throw CacheException(message: 'Failed to get cached user: $e');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await _secureStorage.delete(key: _userKey);
      Logger.info('Cached user cleared');
    } catch (e) {
      Logger.error('Failed to clear cached user: $e');
      throw CacheException(message: 'Failed to clear cached user: $e');
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
      Logger.info('Token saved successfully');
    } catch (e) {
      Logger.error('Failed to save token: $e');
      throw CacheException(message: 'Failed to save token: $e');
    }
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      Logger.info('Refresh token saved successfully');
    } catch (e) {
      Logger.error('Failed to save refresh token: $e');
      throw CacheException(message: 'Failed to save refresh token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      if (token != null) {
        Logger.info('Token retrieved successfully');
      } else {
        Logger.info('No token found');
      }
      return token;
    } catch (e) {
      Logger.error('Failed to get token: $e');
      throw CacheException(message: 'Failed to get token: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      if (refreshToken != null) {
        Logger.info('Refresh token retrieved successfully');
      } else {
        Logger.info('No refresh token found');
      }
      return refreshToken;
    } catch (e) {
      Logger.error('Failed to get refresh token: $e');
      throw CacheException(message: 'Failed to get refresh token: $e');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      Logger.info('Tokens cleared successfully');
    } catch (e) {
      Logger.error('Failed to clear tokens: $e');
      throw CacheException(message: 'Failed to clear tokens: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      final cachedUser = await getCachedUser();
      
      final isLoggedIn = token != null && cachedUser != null;
      Logger.info('Login status: $isLoggedIn');
      return isLoggedIn;
    } catch (e) {
      Logger.error('Failed to check login status: $e');
      return false;
    }
  }
} 