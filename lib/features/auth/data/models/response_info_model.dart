import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_info_model.freezed.dart';
part 'response_info_model.g.dart';

@freezed
abstract class ResponseInfoModel with _$ResponseInfoModel {
  const factory ResponseInfoModel({
    required int code,
    String? message,
  }) = _ResponseInfoModel;

  factory ResponseInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseInfoModelFromJson(json);
} 