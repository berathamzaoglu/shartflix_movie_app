import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_model.freezed.dart';
part 'pagination_model.g.dart';

@freezed
abstract class PaginationModel with _$PaginationModel {
  const factory PaginationModel({
    @JsonKey(name: 'totalCount') required int totalCount,
    @JsonKey(name: 'perPage') required int perPage,
    @JsonKey(name: 'maxPage') required int maxPage,
    @JsonKey(name: 'currentPage') required int currentPage,
  }) = _PaginationModel;

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
} 