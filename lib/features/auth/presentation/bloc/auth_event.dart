import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  const factory AuthEvent.checkAuthStatus() = AuthCheckStatusRequested;
  
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
    @Default(false) bool rememberMe,
  }) = AuthLoginRequested;
  
  const factory AuthEvent.registerRequested({
    required String name,
    required String email,
    required String password,
  }) = AuthRegisterRequested;
  
  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;
  
  const factory AuthEvent.forgotPasswordRequested({
    required String email,
  }) = AuthForgotPasswordRequested;
} 