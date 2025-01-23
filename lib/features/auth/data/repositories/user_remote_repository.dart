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
  Future<Either<Failure, void>> deleteUser(String id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
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
Future<Either<Failure, String>> loginUser(String email, String password) async {
  try {
    final token = await _userRemoteDatasource.loginUser(email, password);
    return Right(token);
  } catch (e) {
    return Left(
      ApiFailure(
        statusCode: 400,
        message: e.toString(),
      ),
    );
  }
}
}
