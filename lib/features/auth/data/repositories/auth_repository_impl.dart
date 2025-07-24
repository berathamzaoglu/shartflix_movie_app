import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_result_model.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.login(
          email: email,
          password: password,
          rememberMe: rememberMe,
        );
        
        // Cache user and tokens
        final userModel = UserModel(
          id: result.id,
          name: result.name,
          email: result.email,
          profilePhoto: result.photoUrl,
        );
        await localDataSource.cacheUser(userModel);
        await localDataSource.saveToken(result.token);
        await localDataSource.saveRefreshToken(result.token); // Using same token as refresh
        
        return Right(result.toEntity());
      } on AuthException catch (e) {
        return Left(Failure.auth(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on ServerException catch (e) {
        return Left(Failure.server(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on NetworkException catch (e) {
        return Left(Failure.network(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } catch (e) {
        return Left(Failure.server(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(Failure.network(
        message: 'İnternet bağlantısı bulunamadı',
      ));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.register(
          name: name,
          email: email,
          password: password,
        );
        
        // Cache user and tokens
        final userModel = UserModel(
          id: result.id,
          name: result.name,
          email: result.email,
          profilePhoto: result.photoUrl,
        );
        await localDataSource.cacheUser(userModel);
        await localDataSource.saveToken(result.token);
        await localDataSource.saveRefreshToken(result.token); // Using same token as refresh
        
        return Right(result.toEntity());
      } on AuthException catch (e) {
        return Left(Failure.auth(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on ServerException catch (e) {
        return Left(Failure.server(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on NetworkException catch (e) {
        return Left(Failure.network(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } catch (e) {
        return Left(Failure.server(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(Failure.network(
        message: 'İnternet bağlantısı bulunamadı',
      ));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      // Always clear local data first
      await localDataSource.clearCachedUser();
      await localDataSource.clearTokens();
      
      // Then try to logout from remote (if connected)
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.logout();
        } catch (e) {
          // If remote logout fails, we still continue since local cleanup is done
          // This ensures user can logout even if network/server has issues
        }
      }
      
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(Failure.cache(
        message: e.message,
      ));
    } catch (e) {
      return Left(Failure.cache(message: 'Failed to logout: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      final isLoggedIn = await localDataSource.isLoggedIn();
      
      if (cachedUser != null && isLoggedIn) {
        return Right(cachedUser.toEntity());
      } else {
        return const Right(null);
      }
    } on CacheException catch (e) {
      return Left(Failure.cache(
        message: e.message,
      ));
    } catch (e) {
      return Left(Failure.cache(message: 'Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> refreshToken(String refreshToken) async {
    // For now, just try to get current user profile to validate token
    if (await networkInfo.isConnected) {
      try {
        final userProfile = await remoteDataSource.getProfile();
        
        // Create a dummy auth result with current token
        final currentToken = await localDataSource.getToken();
        if (currentToken != null) {
          final authResult = AuthResult(
            user: userProfile.toEntity(),
            token: currentToken,
            refreshToken: refreshToken,
            expiresIn: 3600,
          );
          return Right(authResult);
        } else {
          return const Left(Failure.auth(message: 'Token bulunamadı'));
        }
      } on AuthException catch (e) {
        return Left(Failure.auth(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on ServerException catch (e) {
        return Left(Failure.server(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on NetworkException catch (e) {
        return Left(Failure.network(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } catch (e) {
        return Left(Failure.server(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(Failure.network(
        message: 'İnternet bağlantısı bulunamadı',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } on CacheException catch (e) {
      return Left(Failure.cache(message: e.message));
    } catch (e) {
      return Left(Failure.cache(message: 'Failed to check login status: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.forgotPassword(email);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(Failure.server(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on NetworkException catch (e) {
        return Left(Failure.network(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } catch (e) {
        return Left(Failure.server(message: 'Unexpected error: $e'));
      }
    } else {
      return const Left(Failure.network(
        message: 'İnternet bağlantısı bulunamadı',
      ));
    }
  }
} 