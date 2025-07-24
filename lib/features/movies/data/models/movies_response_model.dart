import 'package:freezed_annotation/freezed_annotation.dart';

import 'movie_model.dart';

part 'movies_response_model.freezed.dart';
part 'movies_response_model.g.dart';

@freezed
class MoviesResponseModel with _$MoviesResponseModel {
  const factory MoviesResponseModel({
    required int page,
    required List<MovieModel> results,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'total_results') required int totalResults,
  }) = _MoviesResponseModel;

  factory MoviesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseModelFromJson(json);
} 