import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> createUser(UserEntity userEntity);
  Future<Either<Failure, String>> loginUser(String email, String password);
  Future<Either<Failure, List<UserEntity>>> getAllUsers();
  Future<Either<Failure, void>> deleteUser(String id, String? token);
  Future<Either<Failure, String>> uploadProfilePicture(File file);
}
