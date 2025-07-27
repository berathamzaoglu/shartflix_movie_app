import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/services/analytics_helper.dart';
import '../../../../core/services/crashlytics_helper.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/upload_profile_photo_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final UploadProfilePhotoUseCase _uploadProfilePhotoUseCase;

  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._checkAuthStatusUseCase,
    this._uploadProfilePhotoUseCase,
  ) : super(const AuthState.initial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthUpdateProfilePhotoRequested>(_onUpdateProfilePhotoRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    
    Logger.info('Login requested for: ${event.email}');
    
    // Analytics: Login attempt
    await AnalyticsHelper.logLogin(method: 'email');
    await CrashlyticsHelper.log('Login attempt for: ${event.email}');
    
    final result = await _loginUseCase(LoginParams(
      email: event.email,
      password: event.password,
      rememberMe: event.rememberMe,
    ));

    result.fold(
      (failure) {
        Logger.error('Login failed: ${failure.message}');
        
        // Analytics: Login failure
        AnalyticsHelper.logError(
          errorType: 'login_failure',
          errorMessage: failure.message,
          screenName: 'login_page',
        );
        
        // Crashlytics: Record login error
        CrashlyticsHelper.recordError(
          Exception('Login failed: ${failure.message}'),
          null,
          reason: 'Login failure for ${event.email}',
        );
        
        emit(AuthState.error(failure.message));
      },
      (authResult) {
        Logger.info('Login successful for user: ${authResult.user.email}');
        
        // Analytics: Login success
        AnalyticsHelper.setUserId(authResult.user.id);
        AnalyticsHelper.setUserProperty(name: 'user_email', value: authResult.user.email);
        AnalyticsHelper.setUserProperty(name: 'user_name', value: authResult.user.name);
        
        // Crashlytics: Set user identifier
        CrashlyticsHelper.setUserIdentifier(authResult.user.id);
        CrashlyticsHelper.setUserProperty(key: 'user_email', value: authResult.user.email);
        CrashlyticsHelper.setUserProperty(key: 'user_name', value: authResult.user.name);
        
        emit(AuthState.authenticated(authResult.user));
      },
    );
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    
    Logger.info('Registration requested for: ${event.email}');
    
    // Analytics: Sign up attempt
    await AnalyticsHelper.logSignUp(method: 'email');
    await CrashlyticsHelper.log('Registration attempt for: ${event.email}');
    
    final result = await _registerUseCase(RegisterParams(
      name: event.name,
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) {
        Logger.error('Registration failed: ${failure.message}');
        
        // Analytics: Registration failure
        AnalyticsHelper.logError(
          errorType: 'registration_failure',
          errorMessage: failure.message,
          screenName: 'register_page',
        );
        
        // Crashlytics: Record registration error
        CrashlyticsHelper.recordError(
          Exception('Registration failed: ${failure.message}'),
          null,
          reason: 'Registration failure for ${event.email}',
        );
        
        emit(AuthState.error(failure.message));
      },
      (authResult) {
        Logger.info('Registration successful for user: ${authResult.user.email}');
        
        // Analytics: Registration success
        AnalyticsHelper.setUserId(authResult.user.id);
        AnalyticsHelper.setUserProperty(name: 'user_email', value: authResult.user.email);
        AnalyticsHelper.setUserProperty(name: 'user_name', value: authResult.user.name);
        
        // Crashlytics: Set user identifier
        CrashlyticsHelper.setUserIdentifier(authResult.user.id);
        CrashlyticsHelper.setUserProperty(key: 'user_email', value: authResult.user.email);
        CrashlyticsHelper.setUserProperty(key: 'user_name', value: authResult.user.name);
        
        emit(AuthState.authenticated(authResult.user));
      },
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    Logger.info('Logout requested');
    
    // Analytics: Logout attempt
    await AnalyticsHelper.logLogout();
    await CrashlyticsHelper.log('Logout requested');
    
    final result = await _logoutUseCase(NoParams());

    result.fold(
      (failure) {
        Logger.error('Logout failed: ${failure.message}');
        
        // Analytics: Logout failure
        AnalyticsHelper.logError(
          errorType: 'logout_failure',
          errorMessage: failure.message,
          screenName: 'profile_page',
        );
        
        // Crashlytics: Record logout error
        CrashlyticsHelper.recordError(
          Exception('Logout failed: ${failure.message}'),
          null,
          reason: 'Logout failure',
        );
        
        // Even if logout API fails, we should still clear local data
        emit(const AuthState.unauthenticated());
      },
      (_) {
        Logger.info('Logout successful');
        
        // Analytics: Logout success
        AnalyticsHelper.setUserId('');
        AnalyticsHelper.setUserProperty(name: 'user_email', value: '');
        AnalyticsHelper.setUserProperty(name: 'user_name', value: '');
        
        // Crashlytics: Clear user identifier
        CrashlyticsHelper.setUserIdentifier('');
        CrashlyticsHelper.setUserProperty(key: 'user_email', value: '');
        CrashlyticsHelper.setUserProperty(key: 'user_name', value: '');
        
        emit(const AuthState.unauthenticated());
      },
    );
  }

  Future<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    Logger.info('Checking auth status');
    
    final result = await _checkAuthStatusUseCase(NoParams());

    result.fold(
      (failure) {
        Logger.warning('Auth status check failed: ${failure.message}');
        emit(const AuthState.unauthenticated());
      },
      (user) {
        if (user != null) {
          Logger.info('User is authenticated: ${user.email}');
          emit(AuthState.authenticated(user));
        } else {
          Logger.info('User is not authenticated');
          emit(const AuthState.unauthenticated());
        }
      },
    );
  }

  Future<void> _onUpdateProfilePhotoRequested(
    AuthUpdateProfilePhotoRequested event,
    Emitter<AuthState> emit,
  ) async {
    Logger.info('Updating profile photo');
    
    // Get current state
    final currentState = state;
    
    currentState.maybeWhen(
      authenticated: (user) {
        // Create updated user with new photo URL
        final updatedUser = user.copyWith(profilePhoto: event.photoUrl);
        Logger.info('Profile photo updated for user: ${user.email}');
        emit(AuthState.authenticated(updatedUser));
      },
      orElse: () {
        Logger.warning('Cannot update profile photo: user not authenticated');
      },
    );
  }

  Future<Either<Failure, String>> uploadProfilePhoto(File imageFile) async {
    Logger.info('Uploading profile photo: ${imageFile.path}');
    
    try {
      final result = await _uploadProfilePhotoUseCase(imageFile);
      
      result.fold(
        (failure) {
          Logger.error('Upload profile photo failed: ${failure.message}');
        },
        (photoUrl) {
          Logger.info('Profile photo uploaded successfully: $photoUrl');
          // Automatically update the user's profile photo in state
          final currentState = state;
          currentState.maybeWhen(
            authenticated: (user) {
              final updatedUser = user.copyWith(profilePhoto: photoUrl);
              emit(AuthState.authenticated(updatedUser));
              Logger.info('User state updated with new photo: $photoUrl');
            },
            orElse: () {
              Logger.warning('Cannot update profile photo: user not authenticated');
            },
          );
        },
      );
      
      return result;
    } catch (e) {
      Logger.error('Upload profile photo exception: $e');
      return Left(Failure.server(message: 'Upload failed: $e'));
    }
  }
} 