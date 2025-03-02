import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:revive_reads/app/shared_prefs/token_shared_prefs.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/account/data/data_source/account_data_source.dart';
import 'package:revive_reads/features/account/domain/entity/account_entity.dart';
import 'package:revive_reads/features/account/domain/repository/account_repository.dart';

class AccountRemoteRepository implements IAccountRepository {
  final IAccountDataSource dataSource;
  final TokenSharedPrefs tokenSharedPrefs;

  AccountRemoteRepository(this.dataSource, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, AccountEntity>> getAccount(String userId) async {
    try {
      final tokenResult = await tokenSharedPrefs.getToken();

      return tokenResult.fold(
        (failure) => Left(failure),
        (token) async {
          try {
            final accountModel = await dataSource.getAccount(userId, token);
            return Right(accountModel.toEntity());
          } catch (e) {
            return Left(ApiFailure(message: e.toString()));
          }
        },
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> updateProfile({
    required String userId,
    required String name,
    required String phone,
    required String address,
    File? avatar,
  }) async {
    try {
      final tokenResult = await tokenSharedPrefs.getToken();

      return tokenResult.fold(
        (failure) => Left(failure),
        (token) async {
          try {
            final accountModel = await dataSource.updateProfile(
              userId: userId,
              name: name,
              phone: phone,
              address: address,
              avatar: avatar,
              token: token,
            );
            return Right(accountModel.toEntity());
          } catch (e) {
            return Left(ApiFailure(message: e.toString()));
          }
        },
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await tokenSharedPrefs.clearTokens();
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
