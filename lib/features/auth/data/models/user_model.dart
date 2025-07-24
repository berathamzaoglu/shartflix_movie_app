import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'profile_photo') String? profilePhoto,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      profilePhoto: profilePhoto,
      createdAt: createdAt,
    );
  }
}

extension UserX on User {
  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      profilePhoto: profilePhoto,
      createdAt: createdAt,
    );
  }
} 