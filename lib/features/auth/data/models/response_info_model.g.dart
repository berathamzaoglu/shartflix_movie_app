// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResponseInfoModel _$ResponseInfoModelFromJson(Map<String, dynamic> json) =>
    _ResponseInfoModel(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ResponseInfoModelToJson(_ResponseInfoModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
