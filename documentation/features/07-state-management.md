# State Management with BLoC

## Overview

The ShartFlix application uses the BLoC (Business Logic Component) pattern for state management, providing a reactive programming approach that separates business logic from UI components. This implementation ensures predictable state changes, easy testing, and maintainable code architecture throughout the application.

## Core Architecture

### BLoC Pattern Structure
```dart
// Base BLoC implementation
abstract class AppBloc<Event, State> extends Bloc<Event, State> {
  AppBloc(State initialState) : super(initialState);

  @override
  void add(Event event) {
    if (!isClosed) {
      super.add(event);
    }
  }

  @override
  Stream<State> mapEventToState(Event event);

  @override
  void onTransition(Transition<Event, State> transition) {
    super.onTransition(transition);
    LoggerService.debug('BLoC Transition: ${transition.toString()}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    LoggerService.error('BLoC Error: $error', 
      error: error, 
      stackTrace: stackTrace
    );
  }
}

// Base State class with common properties
abstract class AppState {
  final bool isLoading;
  final String? error;
  final DateTime timestamp;

  const AppState({
    this.isLoading = false,
    this.error,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  AppState copyWith({
    bool? isLoading,
    String? error,
  });
}

// Base Event class
abstract class AppEvent {
  const AppEvent();
}
```

## Authentication State Management

### Authentication BLoC
```dart
// auth_bloc.dart
class AuthBloc extends AppBloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final TokenStorage tokenStorage;

  AuthBloc({
    required this.authRepository,
    required this.tokenStorage,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthTokenRefreshRequested>(_onTokenRefreshRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final result = await authRepository.login(
        email: event.email,
        password: event.password,
        rememberMe: event.rememberMe,
      );
      
      await tokenStorage.saveToken(result.token);
      await tokenStorage.saveRefreshToken(result.refreshToken);
      
      emit(AuthAuthenticated(
        user: result.user,
        token: result.token,
      ));
      
      // Track successful login
      AnalyticsService.trackLogin(method: 'email');
      
    } catch (error) {
      emit(AuthError(
        message: error is ApiException 
            ? error.userFriendlyMessage 
            : 'Giriş yapılırken hata oluştu',
      ));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final result = await authRepository.register(
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      );
      
      if (result.requiresVerification) {
        emit(AuthVerificationRequired(
          email: event.email,
          message: 'E-posta adresinizi doğrulayın',
        ));
      } else {
        await tokenStorage.saveToken(result.token!);
        emit(AuthAuthenticated(
          user: result.user!,
          token: result.token!,
        ));
      }
      
      // Track successful registration
      AnalyticsService.trackSignUp(method: 'email');
      
    } catch (error) {
      emit(AuthError(
        message: error is ApiException 
            ? error.userFriendlyMessage 
            : 'Kayıt olurken hata oluştu',
      ));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.logout();
      await tokenStorage.clearAll();
      emit(AuthUnauthenticated());
    } catch (error) {
      // Even if logout API fails, clear local storage
      await tokenStorage.clearAll();
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        emit(AuthUnauthenticated());
        return;
      }

      final result = await authRepository.refreshToken(refreshToken);
      await tokenStorage.saveToken(result.token);
      
      // Don't emit new state, just update token
    } catch (error) {
      await tokenStorage.clearAll();
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    final token = await tokenStorage.getToken();
    if (token != null && !_isTokenExpired(token)) {
      try {
        final user = await authRepository.getCurrentUser();
        emit(AuthAuthenticated(user: user, token: token));
      } catch (error) {
        await tokenStorage.clearAll();
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  bool _isTokenExpired(String token) {
    try {
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1])))
      );
      final exp = payload['exp'] as int;
      return DateTime.now().millisecondsSinceEpoch > exp * 1000;
    } catch (e) {
      return true;
    }
  }
}

// Authentication States
abstract class AuthState extends AppState {
  const AuthState({
    super.isLoading,
    super.error,
    super.timestamp,
  });
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  const AuthLoading() : super(isLoading: true);
}

class AuthAuthenticated extends AuthState {
  final User user;
  final String token;

  const AuthAuthenticated({
    required this.user,
    required this.token,
  });

  @override
  AuthState copyWith({bool? isLoading, String? error}) {
    return AuthAuthenticated(user: user, token: token);
  }
}

class AuthUnauthenticated extends AuthState {}

class AuthVerificationRequired extends AuthState {
  final String email;
  final String message;

  const AuthVerificationRequired({
    required this.email,
    required this.message,
  });
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message}) : super(error: message);
}

// Authentication Events
abstract class AuthEvent extends AppEvent {
  const AuthEvent();
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const AuthLoginRequested({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthTokenRefreshRequested extends AuthEvent {
  const AuthTokenRefreshRequested();
}

class AuthStatusChecked extends AuthEvent {
  const AuthStatusChecked();
}
```

## Movie Discovery State Management

### Movie BLoC
```dart
// movie_bloc.dart
class MovieBloc extends AppBloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;
  final FavoriteRepository favoriteRepository;

  MovieBloc({
    required this.movieRepository,
    required this.favoriteRepository,
  }) : super(MovieInitial()) {
    on<MovieFetchRequested>(_onMovieFetchRequested);
    on<MovieRefreshRequested>(_onMovieRefreshRequested);
    on<MovieLoadMoreRequested>(_onMovieLoadMoreRequested);
    on<MovieFavoriteToggled>(_onMovieFavoriteToggled);
    on<MovieSearchRequested>(_onMovieSearchRequested);
    on<MovieFilterChanged>(_onMovieFilterChanged);
  }

  Future<void> _onMovieFetchRequested(
    MovieFetchRequested event,
    Emitter<MovieState> emit,
  ) async {
    if (state is MovieInitial) {
      emit(MovieLoading());
    }

    try {
      final response = await movieRepository.getMovies(
        page: 1,
        limit: 5,
        genre: event.genre,
        search: event.search,
      );

      emit(MovieLoaded(
        movies: response.items,
        hasReachedMax: !response.hasNext,
        currentPage: 1,
        totalPages: response.totalPages,
        currentFilter: MovieFilter(
          genre: event.genre,
          search: event.search,
        ),
      ));
    } catch (error) {
      emit(MovieError(
        message: error is ApiException 
            ? error.userFriendlyMessage 
            : 'Filmler yüklenirken hata oluştu',
      ));
    }
  }

  Future<void> _onMovieRefreshRequested(
    MovieRefreshRequested event,
    Emitter<MovieState> emit,
  ) async {
    if (state is! MovieLoaded) return;

    final currentState = state as MovieLoaded;
    
    try {
      final response = await movieRepository.getMovies(
        page: 1,
        limit: 5,
        genre: currentState.currentFilter?.genre,
        search: currentState.currentFilter?.search,
      );

      emit(currentState.copyWith(
        movies: response.items,
        hasReachedMax: !response.hasNext,
        currentPage: 1,
        totalPages: response.totalPages,
        isRefreshing: false,
      ));
    } catch (error) {
      emit(currentState.copyWith(
        error: error is ApiException 
            ? error.userFriendlyMessage 
            : 'Yenileme sırasında hata oluştu',
        isRefreshing: false,
      ));
    }
  }

  Future<void> _onMovieLoadMoreRequested(
    MovieLoadMoreRequested event,
    Emitter<MovieState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MovieLoaded || 
        currentState.hasReachedMax || 
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final response = await movieRepository.getMovies(
        page: currentState.currentPage + 1,
        limit: 5,
        genre: currentState.currentFilter?.genre,
        search: currentState.currentFilter?.search,
      );

      emit(currentState.copyWith(
        movies: [...currentState.movies, ...response.items],
        hasReachedMax: !response.hasNext,
        currentPage: currentState.currentPage + 1,
        isLoadingMore: false,
      ));
    } catch (error) {
      emit(currentState.copyWith(
        error: error is ApiException 
            ? error.userFriendlyMessage 
            : 'Daha fazla film yüklenirken hata oluştu',
        isLoadingMore: false,
      ));
    }
  }

  Future<void> _onMovieFavoriteToggled(
    MovieFavoriteToggled event,
    Emitter<MovieState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MovieLoaded) return;

    // Optimistic update
    final updatedMovies = currentState.movies.map((movie) {
      if (movie.id == event.movieId) {
        return movie.copyWith(isFavorite: !movie.isFavorite);
      }
      return movie;
    }).toList();

    emit(currentState.copyWith(movies: updatedMovies));

    try {
      final movie = updatedMovies.firstWhere((m) => m.id == event.movieId);
      await favoriteRepository.toggleFavorite(event.movieId, movie.isFavorite);
      
      // Track favorite action
      AnalyticsService.trackFavoriteAction(
        movieId: event.movieId,
        action: movie.isFavorite ? 'add' : 'remove',
      );
    } catch (error) {
      // Rollback optimistic update
      emit(currentState);
      
      // Show error message
      SnackBarService.showError(
        error is ApiException 
            ? error.userFriendlyMessage 
            : 'Favori işlemi sırasında hata oluştu',
      );
    }
  }

  Future<void> _onMovieSearchRequested(
    MovieSearchRequested event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());

    try {
      final response = await movieRepository.getMovies(
        page: 1,
        limit: 5,
        search: event.query,
      );

      emit(MovieLoaded(
        movies: response.items,
        hasReachedMax: !response.hasNext,
        currentPage: 1,
        totalPages: response.totalPages,
        currentFilter: MovieFilter(search: event.query),
      ));
    } catch (error) {
      emit(MovieError(
        message: error is ApiException 
            ? error.userFriendlyMessage 
            : 'Arama sırasında hata oluştu',
      ));
    }
  }

  Future<void> _onMovieFilterChanged(
    MovieFilterChanged event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());

    try {
      final response = await movieRepository.getMovies(
        page: 1,
        limit: 5,
        genre: event.filter.genre,
        search: event.filter.search,
      );

      emit(MovieLoaded(
        movies: response.items,
        hasReachedMax: !response.hasNext,
        currentPage: 1,
        totalPages: response.totalPages,
        currentFilter: event.filter,
      ));
    } catch (error) {
      emit(MovieError(
        message: error is ApiException 
            ? error.userFriendlyMessage 
            : 'Filtreler uygulanırken hata oluştu',
      ));
    }
  }
}

// Movie States
abstract class MovieState extends AppState {
  const MovieState({
    super.isLoading,
    super.error,
    super.timestamp,
  });
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {
  const MovieLoading() : super(isLoading: true);
}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final bool hasReachedMax;
  final int currentPage;
  final int totalPages;
  final MovieFilter? currentFilter;
  final bool isLoadingMore;
  final bool isRefreshing;

  const MovieLoaded({
    required this.movies,
    required this.hasReachedMax,
    required this.currentPage,
    required this.totalPages,
    this.currentFilter,
    this.isLoadingMore = false,
    this.isRefreshing = false,
  });

  @override
  MovieLoaded copyWith({
    List<Movie>? movies,
    bool? hasReachedMax,
    int? currentPage,
    int? totalPages,
    MovieFilter? currentFilter,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? error,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      currentFilter: currentFilter ?? this.currentFilter,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class MovieError extends MovieState {
  final String message;

  const MovieError({required this.message}) : super(error: message);
}

// Movie Events
abstract class MovieEvent extends AppEvent {
  const MovieEvent();
}

class MovieFetchRequested extends MovieEvent {
  final String? genre;
  final String? search;

  const MovieFetchRequested({this.genre, this.search});
}

class MovieRefreshRequested extends MovieEvent {
  const MovieRefreshRequested();
}

class MovieLoadMoreRequested extends MovieEvent {
  const MovieLoadMoreRequested();
}

class MovieFavoriteToggled extends MovieEvent {
  final String movieId;

  const MovieFavoriteToggled({required this.movieId});
}

class MovieSearchRequested extends MovieEvent {
  final String query;

  const MovieSearchRequested({required this.query});
}

class MovieFilterChanged extends MovieEvent {
  final MovieFilter filter;

  const MovieFilterChanged({required this.filter});
}

// Supporting Models
class MovieFilter {
  final String? genre;
  final String? search;
  final String? sortBy;

  const MovieFilter({
    this.genre,
    this.search,
    this.sortBy,
  });

  MovieFilter copyWith({
    String? genre,
    String? search,
    String? sortBy,
  }) {
    return MovieFilter(
      genre: genre ?? this.genre,
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}
```

## Profile State Management

### Profile BLoC
```dart
// profile_bloc.dart
class ProfileBloc extends AppBloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;
  final FavoriteRepository favoriteRepository;

  ProfileBloc({
    required this.userRepository,
    required this.favoriteRepository,
  }) : super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfilePhotoUpdateRequested>(_onProfilePhotoUpdateRequested);
    on<ProfileInfoUpdateRequested>(_onProfileInfoUpdateRequested);
    on<ProfileFavoriteMoviesRequested>(_onProfileFavoriteMoviesRequested);
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await userRepository.getProfile();
      final favoriteMovies = await favoriteRepository.getFavoriteMovies(
        page: 1,
        limit: 20,
      );

      emit(ProfileLoaded(
        user: user,
        favoriteMovies: favoriteMovies.items,
        totalFavorites: favoriteMovies.totalItems,
      ));
    } catch (error) {
      emit(ProfileError(
        message: error is ApiException 
            ? error.userFriendlyMessage 
            : 'Profil yüklenirken hata oluştu',
      ));
    }
  }

  Future<void> _onProfilePhotoUpdateRequested(
    ProfilePhotoUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(currentState.copyWith(isUpdatingPhoto: true));

    try {
      final photoUrl = await userRepository.uploadProfilePhoto(event.imageFile);
      final updatedUser = currentState.user.copyWith(profilePhotoUrl: photoUrl);

      emit(currentState.copyWith(
        user: updatedUser,
        isUpdatingPhoto: false,
      ));

      SnackBarService.showSuccess('Profil fotoğrafı güncellendi');
    } catch (error) {
      emit(currentState.copyWith(
        isUpdatingPhoto: false,
        error: error is ApiException 
            ? error.userFriendlyMessage 
            : 'Fotoğraf yüklenirken hata oluştu',
      ));
    }
  }

  Future<void> _onProfileInfoUpdateRequested(
    ProfileInfoUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(currentState.copyWith(isUpdating: true));

    try {
      final updatedUser = await userRepository.updateProfile(event.updates);

      emit(currentState.copyWith(
        user: updatedUser,
        isUpdating: false,
      ));

      SnackBarService.showSuccess('Profil bilgileri güncellendi');
    } catch (error) {
      emit(currentState.copyWith(
        isUpdating: false,
        error: error is ApiException 
            ? error.userFriendlyMessage 
            : 'Profil güncellenirken hata oluştu',
      ));
    }
  }

  Future<void> _onProfileFavoriteMoviesRequested(
    ProfileFavoriteMoviesRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      final favoriteMovies = await favoriteRepository.getFavoriteMovies(
        page: 1,
        limit: 20,
      );

      emit(currentState.copyWith(
        favoriteMovies: favoriteMovies.items,
        totalFavorites: favoriteMovies.totalItems,
      ));
    } catch (error) {
      emit(currentState.copyWith(
        error: error is ApiException 
            ? error.userFriendlyMessage 
            : 'Favori filmler yüklenirken hata oluştu',
      ));
    }
  }
}

// Profile States
abstract class ProfileState extends AppState {
  const ProfileState({
    super.isLoading,
    super.error,
    super.timestamp,
  });
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {
  const ProfileLoading() : super(isLoading: true);
}

class ProfileLoaded extends ProfileState {
  final UserProfile user;
  final List<Movie> favoriteMovies;
  final int totalFavorites;
  final bool isUpdating;
  final bool isUpdatingPhoto;

  const ProfileLoaded({
    required this.user,
    required this.favoriteMovies,
    required this.totalFavorites,
    this.isUpdating = false,
    this.isUpdatingPhoto = false,
  });

  @override
  ProfileLoaded copyWith({
    UserProfile? user,
    List<Movie>? favoriteMovies,
    int? totalFavorites,
    bool? isUpdating,
    bool? isUpdatingPhoto,
    String? error,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      totalFavorites: totalFavorites ?? this.totalFavorites,
      isUpdating: isUpdating ?? this.isUpdating,
      isUpdatingPhoto: isUpdatingPhoto ?? this.isUpdatingPhoto,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message}) : super(error: message);
}

// Profile Events
abstract class ProfileEvent extends AppEvent {
  const ProfileEvent();
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfilePhotoUpdateRequested extends ProfileEvent {
  final File imageFile;

  const ProfilePhotoUpdateRequested({required this.imageFile});
}

class ProfileInfoUpdateRequested extends ProfileEvent {
  final Map<String, dynamic> updates;

  const ProfileInfoUpdateRequested({required this.updates});
}

class ProfileFavoriteMoviesRequested extends ProfileEvent {
  const ProfileFavoriteMoviesRequested();
}
```

## BLoC Dependency Injection

### BLoC Provider Setup
```dart
// bloc_providers.dart
class BlocProviders {
  static List<BlocProvider> get providers => [
    // Authentication
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        authRepository: GetIt.instance<AuthRepository>(),
        tokenStorage: GetIt.instance<TokenStorage>(),
      )..add(const AuthStatusChecked()),
    ),

    // Movie Discovery
    BlocProvider<MovieBloc>(
      create: (context) => MovieBloc(
        movieRepository: GetIt.instance<MovieRepository>(),
        favoriteRepository: GetIt.instance<FavoriteRepository>(),
      ),
    ),

    // Profile Management
    BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(
        userRepository: GetIt.instance<UserRepository>(),
        favoriteRepository: GetIt.instance<FavoriteRepository>(),
      ),
    ),

    // Navigation
    BlocProvider<NavigationBloc>(
      create: (context) => NavigationBloc(),
    ),

    // Theme
    BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(
        themeRepository: GetIt.instance<ThemeRepository>(),
      )..add(const ThemeLoadRequested()),
    ),

    // Payment
    BlocProvider<PaymentBloc>(
      create: (context) => PaymentBloc(
        paymentService: GetIt.instance<PaymentService>(),
      ),
    ),
  ];

  static Widget wrapWithProviders(Widget child) {
    return MultiBlocProvider(
      providers: providers,
      child: child,
    );
  }
}
```

## State Persistence

### Hydrated BLoC Implementation
```dart
// hydrated_bloc_setup.dart
class HydratedBlocSetup {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory(),
    );
    
    HydratedBloc.storage = storage;
  }
}

// Example of persisted BLoC
class PersistedMovieBloc extends HydratedBloc<MovieEvent, MovieState> {
  PersistedMovieBloc({
    required MovieRepository movieRepository,
  }) : _movieRepository = movieRepository,
       super(MovieInitial());

  final MovieRepository _movieRepository;

  @override
  MovieState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['type'] == 'MovieLoaded') {
        return MovieLoaded(
          movies: (json['movies'] as List)
              .map((movie) => Movie.fromJson(movie))
              .toList(),
          hasReachedMax: json['hasReachedMax'] ?? false,
          currentPage: json['currentPage'] ?? 1,
          totalPages: json['totalPages'] ?? 1,
        );
      }
    } catch (e) {
      LoggerService.error('Failed to restore movie state: $e');
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(MovieState state) {
    if (state is MovieLoaded) {
      return {
        'type': 'MovieLoaded',
        'movies': state.movies.map((movie) => movie.toJson()).toList(),
        'hasReachedMax': state.hasReachedMax,
        'currentPage': state.currentPage,
        'totalPages': state.totalPages,
      };
    }
    return null;
  }
}
```

## Testing BLoCs

### BLoC Testing Utilities
```dart
// bloc_test_helper.dart
class BlocTestHelper {
  static Widget createTestWidget({
    required Widget child,
    List<BlocProvider>? providers,
  }) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: providers ?? [],
        child: child,
      ),
    );
  }

  static MockAuthRepository createMockAuthRepository() {
    return MockAuthRepository();
  }

  static MockMovieRepository createMockMovieRepository() {
    return MockMovieRepository();
  }
}

// Example BLoC Test
group('AuthBloc Tests', () {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;
  late MockTokenStorage mockTokenStorage;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockTokenStorage = MockTokenStorage();
    authBloc = AuthBloc(
      authRepository: mockAuthRepository,
      tokenStorage: mockTokenStorage,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthLoginRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(() => mockAuthRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          rememberMe: any(named: 'rememberMe'),
        )).thenAnswer((_) async => const AuthResult(
          user: User(id: '1', name: 'Test User', email: 'test@example.com'),
          token: 'test_token',
          refreshToken: 'refresh_token',
        ));
        
        when(() => mockTokenStorage.saveToken(any()))
            .thenAnswer((_) async {});
        when(() => mockTokenStorage.saveRefreshToken(any()))
            .thenAnswer((_) async {});
        
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: 'test@example.com',
        password: 'password123',
      )),
      expect: () => [
        const AuthLoading(),
        isA<AuthAuthenticated>()
            .having((state) => state.user.email, 'email', 'test@example.com')
            .having((state) => state.token, 'token', 'test_token'),
      ],
      verify: (_) {
        verify(() => mockTokenStorage.saveToken('test_token')).called(1);
        verify(() => mockTokenStorage.saveRefreshToken('refresh_token')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockAuthRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          rememberMe: any(named: 'rememberMe'),
        )).thenThrow(const ApiException(
          message: 'Invalid credentials',
          statusCode: 401,
        ));
        
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLoginRequested(
        email: 'test@example.com',
        password: 'wrong_password',
      )),
      expect: () => [
        const AuthLoading(),
        isA<AuthError>()
            .having((state) => state.message, 'message', contains('Invalid')),
      ],
    );
  });
});
```

## Performance Considerations

### BLoC Optimization Tips
1. **Avoid Frequent State Emissions**: Use debouncing for rapid events
2. **Efficient State Copying**: Only copy changed properties
3. **Memory Management**: Dispose of BLoCs properly
4. **Stream Subscriptions**: Cancel subscriptions in close()
5. **Large Lists**: Use pagination instead of loading all data

### Debounced Events
```dart
// debounced_search_bloc.dart
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    
    try {
      final results = await searchRepository.searchMovies(event.query);
      emit(SearchLoaded(results: results));
    } catch (error) {
      emit(SearchError(message: error.toString()));
    }
  }
}
```

This comprehensive state management documentation provides a solid foundation for implementing the BLoC pattern throughout the ShartFlix application, ensuring maintainable and testable code architecture. 