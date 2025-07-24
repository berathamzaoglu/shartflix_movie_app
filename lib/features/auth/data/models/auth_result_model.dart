import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_result.dart';
import 'user_model.dart';

part 'auth_result_model.freezed.dart';
part 'auth_result_model.g.dart';

@freezed
class AuthResultModel with _$AuthResultModel {
  const factory AuthResultModel({
    required UserModel user,
    required String token,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_in') required int expiresIn,
  }) = _AuthResultModel;

  factory AuthResultModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResultModelFromJson(json);
}

extension AuthResultModelX on AuthResultModel {
  AuthResult toEntity() {
    return AuthResult(
      user: user.toEntity(),
      token: token,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }
} 