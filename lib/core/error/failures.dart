import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.network({
    required String message,
    int? statusCode,
  }) = NetworkFailure;

  const factory Failure.cache({
    required String message,
    int? statusCode,
  }) = CacheFailure;

  const factory Failure.auth({
    required String message,
    int? statusCode,
  }) = AuthFailure;
} 