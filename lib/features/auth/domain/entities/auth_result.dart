import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'auth_result.freezed.dart';

@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult({
    required User user,
    required String token,
    required String refreshToken,
    required int expiresIn,
  }) = _AuthResult;
} 