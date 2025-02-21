import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/auth/data/repositories/user_remote_repository.dart';

class GetUserByIdUsecase {
  final UserRemoteRepository _userRepository;

  GetUserByIdUsecase(this._userRepository);

  Future<Either<Failure, dynamic>> call(String userId) async {
    try {
      final user = await _userRepository.getUserById(userId);
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
