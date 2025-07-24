import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/auth_response_model.dart';
import '../models/auth_result_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResultModel> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  Future<AuthResultModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserModel> getProfile();

  Future<void> forgotPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);
  
  @override
  Future<AuthResultModel> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      Logger.info('Attempting login for email: $email');
      
      final response = await _dioClient.dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Parse the API response structure
        final authResponse = AuthResponseModel.fromJson(responseData);
        
        if (authResponse.response.code == 200 && authResponse.data != null) {
          final data = authResponse.data!;
          
          // Store token
          final token = data.token;
          await _dioClient.setToken(token);
          
          Logger.info('Login successful for user: ${data.email}');
          return data;
        } else {
          throw ServerException(
            message: authResponse.response.message ?? 'Login failed',
            statusCode: authResponse.response.code,
          );
        }
      } else {
        throw ServerException(
          message: 'Login failed with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e) {
      Logger.error('Login error: $e');
      throw ServerException(message: 'Login failed: $e');
    }
  }

  @override
  Future<AuthResultModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      Logger.info('Attempting registration for email: $email');
      
      final response = await _dioClient.dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Parse the API response structure
        final authResponse = AuthResponseModel.fromJson(responseData);
        
        if (authResponse.response.code == 200 && authResponse.data != null) {
          final data = authResponse.data!;
          
          // Store token
          final token = data.token;
          await _dioClient.setToken(token);
          
          Logger.info('Registration successful for user: ${data.email}');
          return data;
        } else {
          throw ServerException(
            message: authResponse.response.message ?? 'Registration failed',
            statusCode: authResponse.response.code,
          );
        }
      } else {
        throw ServerException(
          message: 'Registration failed with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e) {
      Logger.error('Registration error: $e');
      throw ServerException(message: 'Registration failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      Logger.info('Logging out user');
      
      // Clear stored token
      await _dioClient.clearToken();
      
      Logger.info('Logout successful');
    } catch (e) {
      Logger.error('Logout error: $e');
      throw ServerException(message: 'Logout failed: $e');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      Logger.info('Fetching user profile');
      
      final response = await _dioClient.dio.get(ApiEndpoints.profile);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        final userModel = UserModel.fromJson(data);
        Logger.info('Profile fetched for user: ${userModel.email}');
        return userModel;
      } else {
        throw ServerException(
          message: 'Failed to fetch profile with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } on AuthException {
      rethrow;
    } catch (e) {
      Logger.error('Get profile error: $e');
      throw ServerException(message: 'Failed to fetch profile: $e');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      Logger.info('Sending forgot password request for email: $email');
      
      // Note: This endpoint is not shown in the API docs, 
      // implementing as a placeholder
      final response = await _dioClient.dio.post(
        '/user/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        Logger.info('Forgot password email sent successfully');
      } else {
        throw ServerException(
          message: 'Failed to send forgot password email',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      Logger.error('Forgot password error: $e');
      throw ServerException(message: 'Failed to send forgot password email: $e');
    }
  }
} 