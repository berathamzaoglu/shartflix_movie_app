import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

class RemoveFavoriteUseCase implements UseCase<bool, String> {
  final ProfileRepository repository;

  RemoveFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String movieId) async {
    return await repository.removeFavorite(movieId);
  }
} 