import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/account/domain/entity/account_entity.dart';
import 'package:revive_reads/features/account/domain/repository/account_repository.dart';

class GetAccountUseCase {
  final IAccountRepository repository;

  GetAccountUseCase(this.repository);

  Future<Either<Failure, AccountEntity>> call(String userId) async {
    return await repository.getAccount(userId);
  }
}