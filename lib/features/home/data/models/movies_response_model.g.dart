// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MoviesResponseModel _$MoviesResponseModelFromJson(Map<String, dynamic> json) =>
    _MoviesResponseModel(
      movies: (json['movies'] as List<dynamic>)
          .map((e) => MovieModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MoviesResponseModelToJson(
        _MoviesResponseModel instance) =>
    <String, dynamic>{
      'movies': instance.movies,
      'pagination': instance.pagination,
    };
