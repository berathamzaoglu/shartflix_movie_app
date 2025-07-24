import 'package:freezed_annotation/freezed_annotation.dart';

import 'movie_model.dart';
import 'pagination_model.dart';

part 'movies_response_model.freezed.dart';
part 'movies_response_model.g.dart';

@freezed
abstract class MoviesResponseModel with _$MoviesResponseModel {
  const factory MoviesResponseModel({
    required List<MovieModel> movies,
    required PaginationModel pagination,
  }) = _MoviesResponseModel;

  factory MoviesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseModelFromJson(json);
} 