import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/account/domain/entity/account_entity.dart';

abstract class IAccountRepository {
  Future<Either<Failure, AccountEntity>> getAccount(String userId);
}