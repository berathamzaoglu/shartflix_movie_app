import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../core/network/api_client.dart';
import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';
import '../core/services/firebase_service.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/domain/usecases/upload_profile_photo_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
// Movies Feature
import '../features/home/data/datasources/movies_remote_datasource.dart';
import '../features/home/data/repositories/movies_repository_impl.dart';
import '../features/home/domain/repositories/movies_repository.dart';
import '../features/home/domain/usecases/get_popular_movies_usecase.dart';
import '../features/home/domain/usecases/toggle_favorite_usecase.dart';
import '../features/home/presentation/bloc/movies_bloc.dart';

// Profile Feature
import '../features/profile/data/datasources/profile_remote_datasource.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/domain/usecases/get_favorite_movies_usecase.dart';
import '../features/profile/domain/usecases/remove_favorite_usecase.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  debugPrint('🔧 Starting dependency injection setup...');
  
  // Core
  setupDio();
  await _setupCoreDependencies();
  
  // Auth
  await _setupAuthDependencies();
  
  // Movies
  await _setupMoviesDependencies();
  
  // Profile
  await _setupProfileDependencies();
  
  debugPrint('✅ Dependency injection setup completed!');
}

void setupDio() {
  debugPrint('📡 Setting up Dio...');
  
  // Check if already registered
  if (getIt.isRegistered<DioClient>()) {
    debugPrint('⚠️ DioClient already registered, skipping...');
    return;
  }
  
  // Register DioClient first
  getIt.registerLazySingleton<DioClient>(() {
    debugPrint('🔧 Creating DioClient instance...');
    return DioClient();
  });
  
  // Register ApiClient
  getIt.registerLazySingleton<ApiClient>(() {
    debugPrint('🔧 Creating ApiClient instance...');
    final dioClient = getIt<DioClient>();
    debugPrint('🔧 DioClient retrieved: ${dioClient != null ? 'success' : 'null'}');
    return ApiClientImpl(dioClient);
  });
  
  debugPrint('✅ Dio setup completed');
}

Future<void> _setupCoreDependencies() async {
  debugPrint('🔧 Setting up core dependencies...');
  
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  
  // Core services
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );
  
  // Firebase Service
  getIt.registerLazySingleton<FirebaseService>(
    () => FirebaseService(),
  );
  
  debugPrint('✅ Core dependencies setup completed');
}

Future<void> _setupAuthDependencies() async {
  debugPrint('🔐 Setting up auth dependencies...');
  
  // Data sources
  if (!getIt.isRegistered<AuthLocalDataSource>()) {
    getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        getIt<FlutterSecureStorage>(),
      ),
    );
    debugPrint('✅ AuthLocalDataSource registered');
  }
  
  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt<ApiClient>()),
    );
    debugPrint('✅ AuthRemoteDataSource registered');
  }
  
  // Repository
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
        localDataSource: getIt<AuthLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ),
    );
    debugPrint('✅ AuthRepository registered');
  }
  
  // Use cases
  if (!getIt.isRegistered<LoginUseCase>()) {
    getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    );
    debugPrint('✅ LoginUseCase registered');
  }
  
  if (!getIt.isRegistered<RegisterUseCase>()) {
    getIt.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(getIt<AuthRepository>()),
    );
    debugPrint('✅ RegisterUseCase registered');
  }
  
  if (!getIt.isRegistered<LogoutUseCase>()) {
    getIt.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(getIt<AuthRepository>()),
    );
    debugPrint('✅ LogoutUseCase registered');
  }
  
  if (!getIt.isRegistered<CheckAuthStatusUseCase>()) {
    getIt.registerLazySingleton<CheckAuthStatusUseCase>(
      () => CheckAuthStatusUseCase(getIt<AuthRepository>()),
    );
    debugPrint('✅ CheckAuthStatusUseCase registered');
  }
  
  if (!getIt.isRegistered<GetCurrentUserUseCase>()) {
    getIt.registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt<AuthRepository>()),
    );
    debugPrint('✅ GetCurrentUserUseCase registered');
  }
  
  if (!getIt.isRegistered<UploadProfilePhotoUseCase>()) {
    getIt.registerLazySingleton<UploadProfilePhotoUseCase>(
      () => UploadProfilePhotoUseCase(getIt<AuthRepository>()),
    );
    debugPrint('✅ UploadProfilePhotoUseCase registered');
  }
  
  // Bloc - LazySingleton registration
  if (!getIt.isRegistered<AuthBloc>()) {
    getIt.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        getIt<LoginUseCase>(),
        getIt<RegisterUseCase>(),
        getIt<LogoutUseCase>(),
        getIt<CheckAuthStatusUseCase>(),
        getIt<UploadProfilePhotoUseCase>(),
      ),
    );
    debugPrint('✅ AuthBloc registered as lazy singleton');
  }
  
  debugPrint('✅ Auth dependencies setup completed');
}

Future<void> _setupMoviesDependencies() async {
  debugPrint('🎬 Setting up movies dependencies...');
  
  // Data sources
  if (!getIt.isRegistered<MoviesRemoteDataSource>()) {
    getIt.registerLazySingleton<MoviesRemoteDataSource>(
      () => MoviesRemoteDataSourceImpl(getIt<DioClient>()),
    );
    debugPrint('✅ MoviesRemoteDataSource registered');
  }
  
  // Repositories
  if (!getIt.isRegistered<MoviesRepository>()) {
    getIt.registerLazySingleton<MoviesRepository>(
      () => MoviesRepositoryImpl(getIt.get<MoviesRemoteDataSource>()),
    );
    debugPrint('✅ MoviesRepository registered');
  }
  
  // Use cases
  if (!getIt.isRegistered<GetPopularMoviesUseCase>()) {
    getIt.registerLazySingleton<GetPopularMoviesUseCase>(
      () => GetPopularMoviesUseCase(getIt.get<MoviesRepository>()),
    );
    debugPrint('✅ GetPopularMoviesUseCase registered');
  }
  
  if (!getIt.isRegistered<ToggleFavoriteUseCase>()) {
    getIt.registerLazySingleton<ToggleFavoriteUseCase>(
      () => ToggleFavoriteUseCase(getIt.get<MoviesRepository>()),
    );
    debugPrint('✅ ToggleFavoriteUseCase registered');
  }
  
  // Blocs (LazySingleton registration)
  if (!getIt.isRegistered<MoviesBloc>()) {
    getIt.registerLazySingleton<MoviesBloc>(
      () => MoviesBloc(
        getIt.get<GetPopularMoviesUseCase>(),
        getIt.get<ToggleFavoriteUseCase>(),
      ),
    );
    debugPrint('✅ MoviesBloc registered as lazy singleton');
  }
  
  debugPrint('✅ Movies dependencies setup completed');
}

Future<void> _setupProfileDependencies() async {
  debugPrint('👤 Setting up profile dependencies...');
  
  // Data sources
  if (!getIt.isRegistered<ProfileRemoteDataSource>()) {
    getIt.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(getIt<DioClient>()),
    );
    debugPrint('✅ ProfileRemoteDataSource registered');
  }
  
  // Repositories
  if (!getIt.isRegistered<ProfileRepository>()) {
    getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt.get<ProfileRemoteDataSource>()),
    );
    debugPrint('✅ ProfileRepository registered');
  }
  
  // Use cases
  if (!getIt.isRegistered<GetFavoriteMoviesUseCase>()) {
    getIt.registerLazySingleton<GetFavoriteMoviesUseCase>(
      () => GetFavoriteMoviesUseCase(getIt.get<ProfileRepository>()),
    );
    debugPrint('✅ GetFavoriteMoviesUseCase registered');
  }

  if (!getIt.isRegistered<RemoveFavoriteUseCase>()) {
    getIt.registerLazySingleton<RemoveFavoriteUseCase>(
      () => RemoveFavoriteUseCase(getIt.get<ProfileRepository>()),
    );
    debugPrint('✅ RemoveFavoriteUseCase registered');
  }
  
  // Blocs (LazySingleton registration)
  if (!getIt.isRegistered<ProfileBloc>()) {
    getIt.registerLazySingleton<ProfileBloc>(
      () => ProfileBloc(
        getIt.get<GetFavoriteMoviesUseCase>(),
        getIt.get<RemoveFavoriteUseCase>(),
      ),
    );
    debugPrint('✅ ProfileBloc registered as lazy singleton');
  }
  
  debugPrint('✅ Profile dependencies setup completed');
} 