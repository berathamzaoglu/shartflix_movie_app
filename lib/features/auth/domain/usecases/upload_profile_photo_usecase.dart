import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class UploadProfilePhotoUseCase implements UseCase<String, File> {
  final AuthRepository repository;

  UploadProfilePhotoUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(File params) async {
    return await repository.uploadProfilePhoto(params);
  }
} 