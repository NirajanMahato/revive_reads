import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/account/domain/entity/account_entity.dart';
import 'package:revive_reads/features/account/domain/repository/account_repository.dart';

class UpdateProfileUseCase {
  final IAccountRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, AccountEntity>> call({
    required String userId,
    required String name,
    required String phone,
    required String address,
    File? avatar,
  }) async {
    return await repository.updateProfile(
      userId: userId,
      name: name,
      phone: phone,
      address: address,
      avatar: avatar,
    );
  }
}