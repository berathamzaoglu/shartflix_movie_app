// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResultModelImpl _$$AuthResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthResultModelImpl(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$$AuthResultModelImplToJson(
        _$AuthResultModelImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'refresh_token': instance.refreshToken,
      'expires_in': instance.expiresIn,
    };
