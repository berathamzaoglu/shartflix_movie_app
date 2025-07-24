import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/auth_result.dart';
import 'user_model.dart';

part 'auth_result_model.freezed.dart';
part 'auth_result_model.g.dart';

@freezed
abstract class AuthResultModel with _$AuthResultModel {
  const factory AuthResultModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String email,
    @JsonKey(name: 'photoUrl') String? photoUrl,
    required String token,
  }) = _AuthResultModel;

  factory AuthResultModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResultModelFromJson(json);
}

extension AuthResultModelX on AuthResultModel {
  AuthResult toEntity() {
    return AuthResult(
      user: UserModel(
        id: id,
        name: name,
        email: email,
        profilePhoto: photoUrl,
      ).toEntity(),
      token: token,
      refreshToken: token, // Using same token as refresh for now
      expiresIn: 3600, // 1 hour default
    );
  }
} 