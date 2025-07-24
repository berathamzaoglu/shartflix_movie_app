import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/movies/data/datasources/movies_remote_datasource.dart';
import '../features/movies/data/repositories/movies_repository_impl.dart';
import '../features/movies/domain/repositories/movies_repository.dart';
import '../features/movies/domain/usecases/get_popular_movies_usecase.dart';
import '../features/movies/domain/usecases/toggle_favorite_usecase.dart';
import '../features/movies/presentation/bloc/movies_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  print('🔧 Starting dependency injection setup...');
  
  // Core
  setupDio();
  await _setupCoreDependencies();
  
  // Auth
  await _setupAuthDependencies();
  
  // Movies
  await _setupMoviesDependencies();
  
  print('✅ Dependency injection setup completed!');
}

void setupDio() {
  print('📡 Setting up Dio...');
  
  // Check if already registered
  if (getIt.isRegistered<Dio>(instanceName: 'dio')) {
    print('⚠️ Dio already registered, skipping...');
    return;
  }
  
  // Configure Dio instance
  final dio = Dio(BaseOptions(
    baseUrl: 'https://caseapi.servicelabs.tech', // Use your actual API base URL
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Add logging in debug mode
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
    ),
  );

  // Register Dio instance
  getIt.registerLazySingleton<Dio>(() => dio, instanceName: 'dio');
  
  // Register DioClient
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  
  print('✅ Dio setup completed');
}

Future<void> _setupCoreDependencies() async {
  print('🔧 Setting up core dependencies...');
  
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  
  // Core services
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(),
  );
  
  print('✅ Core dependencies setup completed');
}

Future<void> _setupAuthDependencies() async {
  print('🔐 Setting up auth dependencies...');
  
  // Data sources
  if (!getIt.isRegistered<AuthLocalDataSource>()) {
    getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        getIt<FlutterSecureStorage>(),
      ),
    );
    print('✅ AuthLocalDataSource registered');
  }
  
  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt<DioClient>()),
    );
    print('✅ AuthRemoteDataSource registered');
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
    print('✅ AuthRepository registered');
  }
  
  // Use cases
  if (!getIt.isRegistered<LoginUseCase>()) {
    getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    );
    print('✅ LoginUseCase registered');
  }
  
  if (!getIt.isRegistered<RegisterUseCase>()) {
    getIt.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(getIt<AuthRepository>()),
    );
    print('✅ RegisterUseCase registered');
  }
  
  if (!getIt.isRegistered<LogoutUseCase>()) {
    getIt.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(getIt<AuthRepository>()),
    );
    print('✅ LogoutUseCase registered');
  }
  
  if (!getIt.isRegistered<CheckAuthStatusUseCase>()) {
    getIt.registerLazySingleton<CheckAuthStatusUseCase>(
      () => CheckAuthStatusUseCase(getIt<AuthRepository>()),
    );
    print('✅ CheckAuthStatusUseCase registered');
  }
  
  if (!getIt.isRegistered<GetCurrentUserUseCase>()) {
    getIt.registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt<AuthRepository>()),
    );
    print('✅ GetCurrentUserUseCase registered');
  }
  
  // Bloc - LazySingleton registration
  if (!getIt.isRegistered<AuthBloc>()) {
    getIt.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        getIt<LoginUseCase>(),
        getIt<RegisterUseCase>(),
        getIt<LogoutUseCase>(),
        getIt<CheckAuthStatusUseCase>(),
      ),
    );
    print('✅ AuthBloc registered as lazy singleton');
  }
  
  print('✅ Auth dependencies setup completed');
}

Future<void> _setupMoviesDependencies() async {
  print('🎬 Setting up movies dependencies...');
  
  // Data sources
  if (!getIt.isRegistered<MoviesRemoteDataSource>()) {
    getIt.registerLazySingleton<MoviesRemoteDataSource>(
      () => MoviesRemoteDataSourceImpl(getIt.get<Dio>(instanceName: 'dio')),
    );
    print('✅ MoviesRemoteDataSource registered');
  }
  
  // Repositories
  if (!getIt.isRegistered<MoviesRepository>()) {
    getIt.registerLazySingleton<MoviesRepository>(
      () => MoviesRepositoryImpl(getIt.get<MoviesRemoteDataSource>()),
    );
    print('✅ MoviesRepository registered');
  }
  
  // Use cases
  if (!getIt.isRegistered<GetPopularMoviesUseCase>()) {
    getIt.registerLazySingleton<GetPopularMoviesUseCase>(
      () => GetPopularMoviesUseCase(getIt.get<MoviesRepository>()),
    );
    print('✅ GetPopularMoviesUseCase registered');
  }
  
  if (!getIt.isRegistered<ToggleFavoriteUseCase>()) {
    getIt.registerLazySingleton<ToggleFavoriteUseCase>(
      () => ToggleFavoriteUseCase(getIt.get<MoviesRepository>()),
    );
    print('✅ ToggleFavoriteUseCase registered');
  }
  
  // Blocs (LazySingleton registration)
  if (!getIt.isRegistered<MoviesBloc>()) {
    getIt.registerLazySingleton<MoviesBloc>(
      () => MoviesBloc(
        getIt.get<GetPopularMoviesUseCase>(),
        getIt.get<ToggleFavoriteUseCase>(),
      ),
    );
    print('✅ MoviesBloc registered as lazy singleton');
  }
  
  print('✅ Movies dependencies setup completed');
} 