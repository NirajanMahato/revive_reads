import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:revive_reads/features/auth/domain/entity/user_entity.dart';
import 'package:revive_reads/features/auth/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDataSource _userRemoteDatasource;

  UserRemoteRepository(this._userRemoteDatasource);

  @override
  Future<Either<Failure, void>> createUser(UserEntity userEntity) async {
    try {
      _userRemoteDatasource.createUser(userEntity);
      return right(null);
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 400,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id, String? token) async {
    try {
      _userRemoteDatasource.deleteUser(id, token);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
    try {
      final users = await _userRemoteDatasource.getAllUsers();
      return Right(users);
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 400,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById(String userId) async {
    try {
      final user = await _userRemoteDatasource.getUserById(userId);
      return Right(user);
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 400,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> loginUser(
      String email, String password) async {
    try {
      final loginData = await _userRemoteDatasource.loginUser(email, password);

      // Ensure non-null values using the null-aware operator (?? '')
      final String id = loginData['id'] ?? '';
      final String token = loginData['token'] ?? '';

      return Right({'id': id, 'token': token});
    } catch (e) {
      return Left(
        ApiFailure(
          statusCode: 400,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final fileName = await _userRemoteDatasource.uploadProfilePicture(file);
      return Right(fileName);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 400));
    }
  }
}
